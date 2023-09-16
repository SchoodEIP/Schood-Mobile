// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schood/style/AppColors.dart';

class H1TextApp extends StatelessWidget {
  final String text;
  final Color color;
  const H1TextApp({super.key, required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 30,
      ),
    );
  }
}

class H2TextApp extends StatelessWidget {
  final String text;
  final Color color;
  const H2TextApp({super.key, required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: color,
        fontSize: 24,
      ),
    );
  }
}

class H3TextApp extends StatelessWidget {
  final String text;
  const H3TextApp({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    /*return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final textColor = themeProvider.isDarkModeEnabled
            ? Colors.white
            : AppColors.purpleSchood;*/
    const textColor = Colors.white;
    return Text(
      text,
      style: const TextStyle(
        color: textColor,
        fontSize: 22,
      ),
    );
  }
}

class H3ButtonTextApp extends StatelessWidget {
  final String text;

  const H3ButtonTextApp({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 22,
      ),
    );
  }
}

class H4TextApp extends StatelessWidget {
  final String text;
  final Color color;
  const H4TextApp({super.key, required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: color,
        fontSize: 18,
      ),
    );
  }
}

class ConversationTextApp extends StatelessWidget {
  final String text;

  const ConversationTextApp({
    super.key,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }
}

class ButtonTextApp extends StatelessWidget {
  final String text;
  const ButtonTextApp({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.inter(
          color: AppColors.backgroundLightmode,
          fontSize: 22,
        ));
  }
}
