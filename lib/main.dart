import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/Chat/ConversationScreen.dart';
import 'package:schood/Connexion_screen.dart';
import 'package:schood/Survey/SurveySummaryScreen.dart';
import 'package:schood/Help/HelpScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/Profile/EmailModifierScreen.dart';
import 'package:schood/Profile/ProfileScreen.dart';
import 'package:schood/Profile/Settings_screen.dart';

import 'package:schood/WeeklyStats.dart';
import 'package:schood/request/get.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schood/global.dart' as global;
import 'package:intl/date_symbol_data_local.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SCHOOD',
          themeMode: themeProvider.getThemeMode(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('fr', ''), // Français
            const Locale('en', ''), // Anglais
          ],
          initialRoute: '/splash',
          routes: {
            '/': (context) => const LoginPage(),
            '/home': (context) => const HomeScreen(),
            '/surveySummary': (context) => const SurveySummaryScreen(),
            '/stats': (context) => const StatsScreen(),
            '/info': (context) => const HelpScreen(),
            '/chat': (context) => const ConversationScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/profile': (context) => ProfileScreen(email: ''),
            '/emailModifier': (context) => const EmailModifier(),
            '/splash': (context) => const SplashScreen(),
          },
        );
      },
    );
  }
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  Color backgroundDarkMode = AppColors.backgroundDarkmode;
  Color backgroundLightMode = AppColors.backgroundLightmode;
  Color textDarkMode = AppColors.textDarkmode;
  Color textLightMode = AppColors.textLightmode;
Color barDarkMode = AppColors.backgroundDarkmode;
  Color barLightMode = AppColors.pinkSchood;
  Color iconDarkMode = AppColors.backgroundLightmode;
  Color iconLightMode = AppColors.purpleSchood;

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
Brightness getkeyboardColor(){
  return isDarkMode ? Brightness.dark : Brightness.light;
}
  Color getBackgroundColor() {
    return isDarkMode ? backgroundDarkMode : backgroundLightMode;
  }

Color getBarColor(){
  return isDarkMode?  barDarkMode : barLightMode;
}
Color getIconColor(){
  return isDarkMode? iconDarkMode : iconLightMode;
}
  Color getTextColor() {
    return isDarkMode ? textDarkMode : textLightMode;
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    loadIsConnected();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );

    _controller.forward();
    _checkTokenAndNavigate();
  }

  Future<void> loadIsConnected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isConnected = prefs.getBool('isConnected') ?? false;
    });
  }

  Future<void> saveIsConnected(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isConnected', value);
    print('isConnected value stored: $value');
  }

  // ignore: no_leading_underscores_for_local_identifiers
  Future<void> _checkTokenAndNavigate() async {
    String? tokenContent = await TokenFileManager.readTokenFromFile();
    // TODO: Perform a GET request to check if the token exists or perform any necessary validations
    if (tokenContent == null || !isConnected) {
      if (kDebugMode) {
        print(
            'No token content found or error reading the file, or not connected.');
      }

      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      });
    } else {
      if (kDebugMode) {
        print('Token content from file: $tokenContent');
      }

      // Perform any additional actions if isConnected is true (e.g., navigate to HomeScreen)
      // ...

      // Navigate to HomeScreen
      final getdata = GetClass();
Response response2 =
            await getdata.getData(tokenContent, "user/profile");
        Map<String, dynamic> userData = jsonDecode(response2.body);
        global.globalToken = tokenContent;
        global.name = userData['firstname'] +' '+ userData['lastname'];
        global.firstName =userData['firstname'];
        global.lastName = userData['lastname'];
        global.email = userData['email'];
if (userData.containsKey('classes') && userData['classes'] is List && userData['classes'].isNotEmpty) {
  // Accédez à la première classe de l'utilisateur
  Map<String, dynamic> firstClass = userData['classes'][0];
  global.classe = firstClass['name'];
  global.classeid = firstClass['_id'];
} else {
  // Si l'utilisateur n'a pas de classe, vous pouvez attribuer des valeurs par défaut ou gérer le cas en conséquence
}
        global.idtoken = userData['_id'];
        global.role = userData['role']['name'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/Schood_logo.png'),
            const SizedBox(height: 20.0),
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: CustomPaint(
                    size: const Size(100.0, 100.0),
                    painter: SmilePainter(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    final path = Path();

    // Dessinez un arc pour former un sourire
    path.moveTo(size.width * 0.1, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.9,
      size.width * 0.9,
      size.height * 0.6,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}