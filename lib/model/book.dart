import 'package:le_bon_mot/model/quote.dart';

class Book {
  String id;
  String title;
  String subtitle;
  List<String> authors;
  int pageCount;
  String thumbnail;

  List<Quote> quotes;

  Book({
    required this.id,
    required this.title,
    this.subtitle = "",
    required this.authors,
    required this.pageCount,
    required this.thumbnail,
    required this.quotes,
  });
}