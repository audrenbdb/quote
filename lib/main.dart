import 'package:flutter/material.dart';
import 'package:le_bon_mot/auth/authenticator.dart';
import 'package:le_bon_mot/auth/inmem.dart';
import 'package:le_bon_mot/auth/ui.dart';
import 'package:le_bon_mot/components/home.dart';
import 'package:le_bon_mot/repo/book/inmem.dart';
import 'package:le_bon_mot/services/book.dart';
import 'package:le_bon_mot/services/services.dart';

void main() {
  //final authenticator = InMemAuthenticator(authenticatedUser: jonDoe);
  final authenticator = InMemAuthenticator();
  final bookRepo = InMemBookRepository();
  final bookService = BookService(bookRepo: bookRepo);
  runApp(MyApp(
    authenticator: authenticator,
    bookService: bookService,
  ));
}

class MyApp extends StatelessWidget {
  final Authenticator authenticator;
  final BookService bookService;

  const MyApp({
    Key? key,
    required this.authenticator,
    required this.bookService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white24,
      ),
      home: Scaffold(
          body: Services(
              bookService: bookService,
              child: AuthWrapper(
                  authenticator: authenticator,
                  child: const Home(),
              ),
          ),
      ),
    );
  }
}
