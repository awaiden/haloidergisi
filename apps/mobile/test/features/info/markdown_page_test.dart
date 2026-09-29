import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/info/presentation/screens/markdown_page_screen.dart';

void main() {
  testWidgets('renders the bundled about page', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MarkdownPageScreen(title: 'Hakkımızda', asset: 'assets/contents/about.md'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Pamukkale Üniversitesi', findRichText: true), findsWidgets);
  });
}
