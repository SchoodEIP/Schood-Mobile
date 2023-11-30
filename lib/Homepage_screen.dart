// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String firstName = '';
  String lastName = '';
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.account_circle,
                  size: 40, color: AppColors.purpleSchood),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              H1TextApp(
                text:
                    'Bonjour $firstName $lastName\nComment te sens tu aujourd\'hui ?',
              ),
              const WidgetCard(
                height: 216,
                width: 401,
                title: "Stats hebdomadaire",
              ),
              const WidgetCard(
                height: 216,
                width: 401,
                title: "Questionnaires",
              ),
              const WidgetCard(
                height: 216,
                width: 401,
                title: "Messagerie",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 0,
      ),
    );
  }
}

class WidgetCard extends StatelessWidget {
  final double width;
  final double height;
  final String title;

  const WidgetCard({
    super.key,
    required this.width,
    required this.height,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.0),
      ),
      color: AppColors.purpleSchood,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H2TextApp(text: title, color: AppColors.backgroundLightmode),
            const Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/stats');
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    H4TextApp(
                        text: "Voir plus",
                        color: AppColors.backgroundLightmode),
                    Icon(
                      Icons.forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
