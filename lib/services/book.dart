import 'package:le_bon_mot/model/book.dart';
import 'package:le_bon_mot/repo/book/book.dart';

class BookService {
  final BookRepository bookRepo;
  
  BookService({required this.bookRepo});

  Future<List<Book>> searchBooks({String search = ""}) async {
    final books = await bookRepo.searchSavedBooks(search);
    if (search.isNotEmpty) {
      final otherBooks = await bookRepo.searchForNewBooks(search);
      for (final b in otherBooks) {
        final alreadySaved = books
            .where((savedBook) => savedBook.id == b.id).isNotEmpty;
        if (!alreadySaved) books.add(b);
      }
    }
    books.sort((b1, b2) => b1.quotes.length - b2.quotes.length);
    return books;
  }
}