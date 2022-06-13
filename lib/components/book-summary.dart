import 'package:flutter/material.dart';
import 'package:le_bon_mot/model/book.dart';

class BookSummary extends StatelessWidget {
  final Book book;
  const BookSummary({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            leading: Icon(
              Icons.book,
              color:
              Theme.of(context).colorScheme.secondary,
            ),
            title: Text(book.title),
            subtitle: Text(book.authors.join(", "))),
        Container(height: 16.0),
        if (book.thumbnail.isNotEmpty)
          Image.network(
            book.thumbnail,
            height: 171,
            fit: BoxFit.contain,
            frameBuilder: (_, image, loadingBuilder, __) {
              if (loadingBuilder == null) {
                return SizedBox(
                  height: 171,
                  width: 128,
                  child: Container(color: Colors.grey),
                );
              }
              return image;
            },
            loadingBuilder: (BuildContext context,
                Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                  child: SizedBox(
                    height: 171,
                    width: 128,
                    child: CircularProgressIndicator(
                      value: loadingProgress
                          .expectedTotalBytes !=
                          null
                          ? loadingProgress
                          .cumulativeBytesLoaded /
                          loadingProgress
                              .expectedTotalBytes!
                          : null,
                    ),
                  ));
              return child;
            },
          ),
        Container(height: 16.0),
        Text(
          "${book.quotes.length} quotes saved",
          style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey),
        ),
        Container(height: 16.0),
      ],
    );
  }
}
