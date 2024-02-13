// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:schood/Help/help_screen.dart';
import 'package:schood/Help/help_list.dart';
import 'package:schood/homepage_screen.dart';
import 'package:schood/Profile/settings_screen.dart';

import 'package:schood/main.dart';
import 'package:schood/style/app_buttons.dart';

import 'tests_helper/GoogleFonts.dart';

class MockThemeProvider extends ThemeProvider {
  @override
  bool get isDarkMode =>
      false; // Utilisez les valeurs appropriées pour votre test

  // Ajoutez d'autres méthodes ou propriétés simulées au besoin
}

void main() {
  testWidgets('Test de redirection de page de Homepage à Homepage',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>.value(
            value: MockThemeProvider(), // Utilisez un simulateur ou un mock ici
          ),
        ],
        child: const  MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    final titleFinder = find.text('Stats hebdomadaire');
    expect(titleFinder, findsOneWidget);

    await tester.tap(find.byIcon(Icons.home));
    await tester
        .pumpAndSettle(); // Attend la transition et le rendu de la nouvelle page

    final tittlefinder2 = find.text("Stats hebdomadaire");
    expect(tittlefinder2, findsOneWidget);
  });
  testWidgets('Test de redirection de page entre Homepage et Statistique',
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>.value(
            value: MockThemeProvider(), // Utilisez un simulateur ou un mock ici
          ),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        )));

    final titleFinder = find.text('Stats hebdomadaire');
    expect(titleFinder, findsOneWidget);

    await tester.tap(find.byIcon(Icons.show_chart));
    await tester
        .pumpAndSettle(); // Attend la transition et le rendu de la nouvelle page

    final tittlefinder2 = find.text("Stats hebdomadaires");
    expect(tittlefinder2, findsOneWidget);
  });
  testWidgets('Test de redirection de page entre toutes les pages',
      (WidgetTester tester) async {
    await loadAppFonts();
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>.value(
            value: MockThemeProvider(), // Utilisez un simulateur ou un mock ici
          ),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        )));
  });
  testWidgets('Test de vérification de normes graphiques',
      (WidgetTester tester) async {
    await loadAppFonts();
    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>.value(
            value: MockThemeProvider(), // Utilisez un simulateur ou un mock ici
          ),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        )));
    expect(
        find.byType(HomeScreen), matchesGoldenFile('goldenTests/Homepage.png'));
  });
  testWidgets('Test de vérification du darkmode', (WidgetTester tester) async {
    await loadAppFonts();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>.value(
            value: MockThemeProvider(), // Utilisez un simulateur ou un mock ici
          ),
        ],
        child: const MaterialApp(
          home: SettingsScreen(),
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
  testWidgets('Test de vérification des aides', (WidgetTester tester) async {
    await loadAppFonts();
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(
          value: MockThemeProvider(), // Utilisez un simulateur ou un mock ici
        ),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.info_rounded));
    await tester.pumpAndSettle();
    await tester.pump();
    expect(
        find.byType(HelpScreen), matchesGoldenFile('goldenTests/HelpPage.png'));
  });
  testWidgets('Test de redirection pour appel', (WidgetTester tester) async {
    await loadAppFonts();
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(
          value: MockThemeProvider(), // Utilisez un simulateur ou un mock ici
        ),
      ],
      child: const MaterialApp(
        home: HelpList(),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(HelpButton, 'Drogue Info services'));
    await tester.pumpAndSettle();
    //await tester.tap(find.widgetWithText(HelpCallButton, '0800231313'));
    await tester.pump();
    final titleFinder = find.text('Drogue Info services');
    expect(titleFinder, findsOneWidget);
    //expect(
    //    find.byType(HelpScreen), matchesGoldenFile('goldenTests/HelpPage.png'));
  });
}
