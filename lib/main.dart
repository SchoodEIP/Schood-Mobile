import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Chat/ConversationScreen.dart';
import 'package:schood/Connexion_screen.dart';
import 'package:schood/Survey/SurveySummaryScreen.dart';
import 'package:schood/Help/HelpScreen.dart';

import 'package:schood/Homepage_screen.dart';
import 'package:schood/Profile/EmailModifierScreen.dart';
import 'package:schood/Profile/ProfileScreen.dart';
import 'package:schood/Profile/Settings_screen.dart';

import 'package:schood/WeeklyStats.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          debugShowCheckedModeBanner: false,
          title: 'SCHOOD',
          themeMode: Provider.of<ThemeProvider>(context).getThemeMode(),
          initialRoute: '/splash',
          routes: {
            '/': (context) => const LoginPage(),
            '/home': (context) => const HomeScreen(),
            '/surveySummary': (context) => const SurveySummaryScreen(),
            '/stats': (context) => const StatsScreen(),
            '/info': (context) => const HelpScreen(),
            '/chat': (context) => const ConversationScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/profile': (context) => ProfileScreen(email: _email.text),
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
