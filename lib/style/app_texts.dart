import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';

class H1TextApp extends StatelessWidget {
  final String text;
  final Color? color;
  const H1TextApp({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Text(
      text,
      style: GoogleFonts.inter(
        color: color ?? themeProvider.getTextColor(),
        fontSize: 30,
      ),
    );
  }
}

class H2TextApp extends StatelessWidget {
  final String text;
  final Color? color;
  const H2TextApp({super.key, required this.text, this.color});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Text(
      text,
      style: GoogleFonts.inter(
        color: color ?? themeProvider.getTextColor(),
        fontSize: 24,
      ),
    );
  }
}

class H3TextApp extends StatelessWidget {
  final String text;
  final Color? color;
  const H3TextApp({super.key, required this.text, this.color});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Text(
      text,
      style: TextStyle(
        color: color ?? themeProvider.getTextColor(),
        fontSize: 22,
      ),
    );
  }
}

class H3ButtonTextApp extends StatelessWidget {
  final String text;
  final Color? color;
  const H3ButtonTextApp({super.key, required this.text, this.color});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Text(
      text,
      style: GoogleFonts.inter(
        color: color ?? themeProvider.getTextColor(),
        fontSize: 22,
      ),
    );
  }
}

class H4TextApp extends StatelessWidget {
  final String text;
  final Color? color;
  const H4TextApp({super.key, required this.text, this.color});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Text(
      text,
      style: GoogleFonts.inter(
        color: color ?? themeProvider.getTextColor(),
        fontSize: 18,
      ),
    );
  }
}

class ConversationTextApp extends StatelessWidget {
  final String text;
  final Color? color;
  const ConversationTextApp({super.key, required this.text, this.color});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Text(
      text,
      style: GoogleFonts.inter(
        color: color ?? themeProvider.getTextColor(),
        fontSize: 16,
      ),
    );
  }
}

class ButtonTextApp extends StatelessWidget {
  final String text;
  final Color? color;
  const ButtonTextApp({super.key, required this.text, this.color});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Text(text,
        style: GoogleFonts.inter(
          color: color ?? themeProvider.getTextColor(),
          fontSize: 22,
        ));
  }
}
