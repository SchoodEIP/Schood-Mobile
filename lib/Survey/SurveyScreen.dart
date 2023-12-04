// ignore_for_file: file_names
import 'dart:convert';
import 'dart:ffi';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import '../global.dart' as global;
import 'package:schood/main.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<SurveyScreen> {
  List<String> selectedMoods = [];
  String id = global.globalToken;

 Future<Map<String, dynamic>?> _getSurveyData(BuildContext context) async {
    final getdata = GetClass();
    final response = await getdata.getData(global.globalToken, "shared/questionnaire");

    if (response.statusCode == 200) {
      try {
        final surveyData = jsonDecode(response.body);
        print(surveyData);
        return surveyData.isNotEmpty ? surveyData[0] : null;
      } catch (e) {
        print('Erreur lors du décodage du JSON : $e');
      }
    } else {
      print(
          'Erreur lors de la récupération des données : ${response.statusCode}');
    }
    return null;
  }

  @override
  void initState() {
    _getSurveyData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const H1TextApp(
          text: "Questionnaire",
          color: AppColors.backgroundDarkmode,
        ),
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
      backgroundColor: themeProvider.getBackgroundColor(),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>?> (
          future: _getSurveyData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
  
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            }
  
            if (snapshot.hasData) {
              Map<String, dynamic> surveyData = snapshot.data!;
              List<Map<String, dynamic>> classes = (surveyData['classes'] as List<dynamic>).cast<Map<String, dynamic>>();
  
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H3TextApp(
                    text: surveyData['title'] ?? '',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Survey ID: ${surveyData['_id']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Classes:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  for (var classInfo in classes)
                    Text(classInfo['name'] ?? ''),
                ],
              );
            }
            return const Center(child: Text('No survey data available'));
          },
        ),
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 1,
        //Userinfo: widget.Userinfo,
      ),
    );
  }
}
