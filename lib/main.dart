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
          theme: themeProvider.isDarkModeEnabled
              ? _buildDarkTheme()
              : _buildLightTheme(),
          initialRoute: '/home',
          routes: {
            '/': (context) => const LoginPage(),
            '/home': (context) => const HomeScreen(),
            '/docs': (context) => const DocsScreen(),
            '/stats': (context) => const StatsScreen(),
            '/chat': (context) => ChatScreen(),
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

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.purpleSchood,
      scaffoldBackgroundColor: AppColors.backgroundLightmode,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.purpleSchood,
      scaffoldBackgroundColor: AppColors.backgroundDarkmode,
    );
  }
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  set isDarkModeEnabled(bool value) {
    _isDarkModeEnabled = value;
    notifyListeners();
  }
}
