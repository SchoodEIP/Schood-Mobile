import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/ChatScreen.dart';
import 'package:schood/Connexion_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:schood/DocsScreen.dart';
import 'package:schood/HelpScreen.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/Settings_screen.dart';
import 'package:schood/WeeklyStats.dart';
import 'package:schood/style/AppColors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
        child: Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'SCHOOD',
            theme: themeProvider.isDarkModeEnabled
                ? _buildDarkTheme()
                : _buildLightTheme(),
<<<<<<< HEAD
            initialRoute: '/',
            routes: {
              '/a': (context) => LoginPage(),
=======
            initialRoute:
                '/home', // à modifier et remplacer par uniquement '/' pour revenir à la page de connexion
            routes: {
              '/': (context) => LoginPage(),
>>>>>>> 67005ee10ae07a00b112ea7325ee418eb15f82ef
              '/home': (context) => HomeScreen(),
              '/docs': (context) => DocsScreen(/*Userinfo: currentUser*/),
              '/stats': (context) => StatsScreen(/*Userinfo: currentUser*/),
              '/chat': (context) => ChatScreen(/*Userinfo: currentUser*/),
              '/info': (context) => HelpScreen(/*Userinfo: currentUser*/),
<<<<<<< HEAD
              '/': (context) => SettingsScreen(),
=======
              '/settings': (context) =>
                  SettingsScreen(), // à ajouter au bouton du profil
>>>>>>> 67005ee10ae07a00b112ea7325ee418eb15f82ef
            },
          );
        }));
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.purple_Schood,
      scaffoldBackgroundColor: AppColors.background_lightMode,
      textTheme: TextTheme(
        bodyText1: TextStyle(color: AppColors.text_lightMode),

        // Définissez d'autres styles de texte pour le mode clair
      ),
      // Définissez d'autres propriétés du thème pour le mode clair
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.purple_Schood,
      scaffoldBackgroundColor: AppColors.background_darkMode,
      textTheme: TextTheme(
        bodyText1: TextStyle(color: AppColors.text_darkMode),
        // Définissez d'autres styles de texte pour le mode sombre
      ),
      // Définissez d'autres propriétés du thème pour le mode sombre
    );
  }
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  set isDarkModeEnabled(bool value) {
    print("Value is $value");
    _isDarkModeEnabled = value;
    notifyListeners();
  }
}
