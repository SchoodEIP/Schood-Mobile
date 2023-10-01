import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/ChatScreen.dart';
import 'package:schood/Connexion_screen.dart';
import 'package:schood/DocsScreen.dart';
import 'package:schood/Help/HelpScreen.dart';

import 'package:schood/Homepage_screen.dart';
import 'package:schood/Profile/EmailModifierScreen.dart';
import 'package:schood/Profile/ProfileScreen.dart';
import 'package:schood/Profile/Settings_screen.dart';

import 'package:schood/WeeklyStats.dart';
import 'package:schood/style/AppColors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final TextEditingController _email = TextEditingController();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'SCHOOD',
          themeMode: Provider.of<ThemeProvider>(context).getThemeMode(),
          initialRoute: '/home',
          routes: {
            '/': (context) => const LoginPage(),
            '/home': (context) => const HomeScreen(),
            '/docs': (context) => const DocsScreen(),
            '/stats': (context) => const StatsScreen(),
            '/chat': (context) => const ChatScreen(),
            '/info': (context) => const HelpScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/profile': (context) => ProfileScreen(email: _email.text),
            '/emailModifier': (context) =>
                const EmailModifier(), // à ajouter au bouton du profil
          },
        );
      },
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  Color backgroundDarkMode = AppColors.backgroundDarkmode;
  Color backgroundLightMode = AppColors.backgroundLightmode;
  Color textDarkMode = AppColors.textDarkmode;
  Color textLightMode = AppColors.textLightmode;
  bool get isDarkMode => _isDarkMode;

  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Color getBackgroundColor() {
    return isDarkMode ? backgroundDarkMode : backgroundLightMode;
  }

  Color getTextColor() {
    return isDarkMode ? textDarkMode : textLightMode;
  }
}
