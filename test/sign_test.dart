// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:le_bon_mot/auth/exceptions.dart';
import 'package:le_bon_mot/auth/inmem.dart';
import 'package:le_bon_mot/components/home.dart';
import 'package:le_bon_mot/main.dart';
import 'package:le_bon_mot/repo/book/inmem.dart';
import 'package:le_bon_mot/services/book.dart';
import 'package:le_bon_mot/validate/validate.dart';

void main() {
  signInWithInvalidEmail(WidgetTester tester) async {
    await tester.enterText(find.byType(TextFormField).first, "jon");
    await tester.tap(find.text("SIGN IN"));
    await tester.pumpAndSettle();

    expect(find.text(invalidEmail), findsOneWidget,
        reason: "A user cannot sign-in with invalid email");
  }

  signInWithInvalidPassword(WidgetTester tester) async {
    await tester.enterText(find.byType(TextFormField).first, "jon@doe.org");
    await tester.enterText(find.byType(TextFormField).last, "123");
    await tester.tap(find.text("SIGN IN"));
    await tester.pumpAndSettle();

    expect(find.text(invalidPassword), findsOneWidget,
        reason: "A user cannot sign-in with invalid password");
  }

  signInWithUserNotFound(WidgetTester tester) async {
    final wrongPassword = "${jonDoe.password}abc";
    await tester.enterText(find.byType(TextFormField).first, jonDoe.email);
    await tester.enterText(find.byType(TextFormField).last, wrongPassword);
    await tester.tap(find.text("SIGN IN"));
    await tester.pumpAndSettle();

    expect(find.text(userNotFoundWithEmailAndPassword), findsOneWidget,
        reason: "Mismatching user/password should return not found");
  }

  signInWithMatchingCredentialsShouldRedirectHome(WidgetTester tester) async {
    await tester.enterText(find.byType(TextFormField).first, jonDoe.email);
    await tester.enterText(find.byType(TextFormField).last, jonDoe.password);
    await tester.tap(find.text("SIGN IN"));
    await tester.pumpAndSettle();

    expect(find.byType(Home), findsOneWidget,
        reason: "User should be redirect to home page after login");
  }

  testWidgets("Sign in", (tester) async {
    final authenticator = InMemAuthenticator();
    final bookRepo = InMemBookRepository();
    final bookService = BookService(bookRepo: bookRepo);

    await tester.pumpWidget(
        MyApp(authenticator: authenticator, bookService: bookService));
    await tester.pumpAndSettle();

    await signInWithInvalidEmail(tester);
    await signInWithInvalidPassword(tester);
    await signInWithUserNotFound(tester);
    await signInWithMatchingCredentialsShouldRedirectHome(tester);
  });
}
