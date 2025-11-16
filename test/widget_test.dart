// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:expense_manager/Providers/CardProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:expense_manager/main.dart'; // This imports HomePage

void main() {
  testWidgets('HomePage shows correct initial UI', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We must provide the same widget tree as in main.dart
    await tester.pumpWidget(
      ChangeNotifierProvider<CardProvider>(
        create: (context) => CardProvider(),
        child: new MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Verify that the title is present.
    expect(find.text('Home page'), findsOneWidget);

    // Verify that the "Last Transactions" text is present.
    expect(find.text('Last Transactions'), findsOneWidget);

    // Verify that the "add card" prompt is shown (since provider is empty).
    expect(find.text("Add your new card click the \n + \n button in the top right."), findsOneWidget);

    // Verify the add icon is present in the AppBar.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}