import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_bon_mot/components/book-sheet.dart';
import 'package:le_bon_mot/components/book-summary.dart';
import 'package:le_bon_mot/services/services.dart';

import '../model/book.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final search = TextEditingController();
  List<Book> books = [];
  bool loading = false;
  Timer? debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchSavedBookings();
  }

  void fetchSavedBookings({String search = ""}) async {
    if (isDebounceActive()) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () async {
      setState(() => loading = true);
      try {
        books =
            await Services.of(context).bookService.searchBooks(search: search);
      } finally {
        setState(() => loading = false);
      }
    });
  }

  bool isDebounceActive() => debounce?.isActive ?? false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: search,
              decoration: InputDecoration(
                  hintText: "Search books",
                  icon: const Icon(Icons.search),
                  suffixIcon: search.text != ""
                      ? IconButton(
                          onPressed: () {
                            search.clear();
                            fetchSavedBookings();
                          },
                          icon: const Icon(Icons.cancel),
                        )
                      : null),
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (val) => fetchSavedBookings(search: val),
            ),
          )),
          if (loading)
            const Padding(
                padding: EdgeInsets.only(top: 48.0),
                child: CircularProgressIndicator()),
          if (!loading)
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, i) {
                  final book = books[i];
                  final summary = BookSummary(book: book);
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 40.0, right: 40.0, bottom: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BookSheet(book: book)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.5),
                              blurRadius: 40.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: BookSummary(book: book),
                      ),
                    ),
                  );
                  return ListTile(title: Text(book.title));
                },
              ),
            ),
        ],
      ),
    );
  }
}
