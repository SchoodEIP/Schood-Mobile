// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:schood/ChatScreen.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/Settings_screen.dart';
import 'package:schood/main.dart';
import 'package:schood/utils/BottomBarApp.dart';

import 'tests_helper/GoogleFonts.dart';

void main() {
  testWidgets('Test de redirection de page de Homepage à Homepage',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(),
    ));

    final titleFinder = find.text('Weekly Stats');
    expect(titleFinder, findsOneWidget);

    await tester.tap(find.byIcon(Icons.home));
    await tester
        .pumpAndSettle(); // Attend la transition et le rendu de la nouvelle page

    final TittleFinder2 = find.text("Weekly Stats");
    expect(TittleFinder2, findsOneWidget);
  });
  testWidgets('Test de redirection de page entre Homepage et Statistique',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(),
    ));

    final titleFinder = find.text('Weekly Stats');
    expect(titleFinder, findsOneWidget);

    await tester.tap(find.byIcon(Icons.show_chart));
    await tester
        .pumpAndSettle(); // Attend la transition et le rendu de la nouvelle page

    final TittleFinder2 = find.text("Weekly Stats");
    expect(TittleFinder2, findsOneWidget);
  });
  testWidgets('Test de redirection de page entre toutes les pages',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(),
    ));
    await tester.tap(find.byIcon(Icons.show_chart));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.description));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chat));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.info_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
  });
  testWidgets('Test de vérification de normes graphiques',
      (WidgetTester tester) async {
    await loadAppFonts();
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(),
    ));
    expect(
        find.byType(HomeScreen), matchesGoldenFile('goldenTests/Homepage.png'));
  });
  testWidgets('Test de vérification du darkmode', (WidgetTester tester) async {
    await loadAppFonts();
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
          child: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final Finder switchFinder = find.byType(Switch);
    final Switch switchWidget = tester.widget(switchFinder);
    expect(switchWidget.value, false);
    await tester.tap(switchFinder);
    await tester.pump();
    expect(find.byType(SettingsScreen),
        matchesGoldenFile('goldenTests/DarkMode.png'));
  });
}
