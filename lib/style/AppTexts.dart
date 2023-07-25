import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppColors.dart';

class H1TextApp extends StatelessWidget {
  final String text;
  final Color color;
  H1TextApp({required this.text, required this.color});
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
  H2TextApp({required this.text, required this.color});
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
  H3TextApp({required this.text});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final textColor = themeProvider.isDarkModeEnabled
            ? Colors.white
            : AppColors.purple_Schood;

        return Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 22,
          ),
        );
      },
    );
  }
}

class H3ButtonTextApp extends StatelessWidget {
  final String text;

  H3ButtonTextApp({required this.text});
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
  H4TextApp({required this.text, required this.color});
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

  ConversationTextApp({
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
  ButtonTextApp({required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.inter(
          color: AppColors.background_lightMode,
          fontSize: 22,
        ));
  }
}
