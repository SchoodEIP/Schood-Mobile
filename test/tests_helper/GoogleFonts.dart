// ignore_for_file: file_names

import 'package:flutter/services.dart';

Future<void> loadAppFonts() async {
  final fontLoader = FontLoader('Inter'); // Nom de la police
  fontLoader
      .addFont(rootBundle.load('test/tests_helper/Fonts/Inter-Regular.ttf'));
  fontLoader.addFont(rootBundle.load('test/tests_helper/Fonts/Inter-Bold.ttf'));
  await fontLoader.load();
}
