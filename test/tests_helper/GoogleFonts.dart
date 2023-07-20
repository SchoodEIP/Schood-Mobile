import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> loadAppFonts() async {
  final fontLoader = FontLoader('Inter'); // Nom de la police
  fontLoader
      .addFont(rootBundle.load('test/tests_helper/Fonts/Inter-Regular.ttf'));
  fontLoader.addFont(rootBundle.load('test/tests_helper/Fonts/Inter-Bold.ttf'));
  await fontLoader.load();
}
