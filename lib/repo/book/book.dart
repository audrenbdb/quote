import 'package:le_bon_mot/model/book.dart';

abstract class BookRepository {
  Future<List<Book>> searchForNewBooks(String search);
  Future<List<Book>> searchSavedBooks(String search);
}