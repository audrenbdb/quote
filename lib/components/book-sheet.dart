import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:le_bon_mot/model/book.dart';
import 'package:le_bon_mot/model/quote.dart';
import 'package:url_launcher/url_launcher.dart';

class BookSheet extends StatelessWidget {
  final Book book;

  const BookSheet({Key? key, required this.book}) : super(key: key);


  void copyQuote(BuildContext context, Quote quote) {
    final text = "${book.authors.join(" ")}, ${book.title}, p.${quote.page}: \"${quote
        .fullText}\"\n\n${getQuoteHashTagsText(quote)}";
    Clipboard.setData(ClipboardData(text: text))
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Copied to clipboard")));
    });
  }

  void tweetQuote(BuildContext context, Quote quote) {
    final text = "${book.authors.join(" ")}, ${book.title}, p.${quote.page}: \"${quote
        .fullText}\"\n\n";
    final hashTags = quote.hashTags.join(",");
    launchUrl(Uri.parse("https://twitter.com/intent/tweet?text=$text&hashtags=$hashTags"));
  }

  String getQuoteHashTagsText(Quote quote) {
    return quote.hashTags.map((h) => "#$h").toList().join(" ");
  }

  @override
  Widget build(BuildContext context) {
    book.quotes.sort((b1, b2) => b1.page - b2.page);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        SafeArea(
            child: Column(
              children: [
                ListTile(
                    leading: Icon(
                      Icons.book,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                    ),
                    title: Text(book.title),
                    subtitle: Text(book.authors.join(", "))),
                Container(
                    padding: const EdgeInsets.all(24.0),
                    child: const Text("Quotes",
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            )),
        Expanded(
          child: ListView.builder(
              itemCount: book.quotes.length,
              itemBuilder: (context, i) {
                final quote = book.quotes[i];
                return Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: Colors.grey.withOpacity(.5), width: .5),
                        bottom: BorderSide(
                            color: Colors.grey.withOpacity(.5), width: .5),
                      )),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Page ${quote.page}"),
                        Text(dateAddedText(quote),
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey))
                      ],
                    ),
                    Container(height: 24.0),
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: Colors.grey.withOpacity(.5),
                                  width: 4.0))),
                      child: Text(quote.fullText,
                          style: const TextStyle(color: Colors.grey)),
                    ),
                    Container(height: 24.0),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          getQuoteHashTagsText(quote),
                          style: const TextStyle(color: Colors.blue),
                        )),
                    Container(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          style: TextButton.styleFrom(primary: Colors.grey),
                          onPressed: () => tweetQuote(context, quote),
                          icon: const Icon(Icons.loop),
                          label: const Text("tweet"),
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(primary: Colors.grey),
                          onPressed: () => copyQuote(context, quote),
                          icon: const Icon(Icons.copy),
                          label: const Text("copy"),
                        )
                      ],
                    )
                  ]),
                );
                return Text(quote.fullText);
              }),
        )
      ]),
    );
  }

  String dateAddedText(Quote quote) {
    final days = DateTime
        .now()
        .difference(quote.dateAdded)
        .inDays;
    if (days == 0) {
      return "added today";
    }
    return "added $days days ago";
  }
}
