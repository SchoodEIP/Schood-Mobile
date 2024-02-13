// ignore_for_file: file_names, use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api
import 'dart:async';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:schood/Survey/survey_question_screen.dart';
import 'package:schood/utils/bottom_bar_app.dart';
import 'package:schood/style/app_colors.dart';
import 'package:schood/style/app_texts.dart';
import 'package:schood/request/get.dart';
import '../global.dart' as global;
import 'package:schood/main.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:typed_data';

class SurveySummaryScreen extends StatefulWidget {
  const SurveySummaryScreen({Key? key});

  @override
  _SurveySummaryState createState() => _SurveySummaryState();
}

class _SurveySummaryState extends State<SurveySummaryScreen> {
  List<String> selectedMoods = [];
  String id = global.globalToken;

  Future<List<Map<String, dynamic>>?> _getSurveyData(
      BuildContext context) async {
    final getdata = GetClass();
    final response =
        await getdata.getData(global.globalToken, "shared/questionnaire");

    if (response.statusCode == 200) {
      try {
        final surveyList = jsonDecode(response.body);
        print(surveyList);
        return surveyList.cast<Map<String, dynamic>>();
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('Error fetching data: ${response.statusCode}');
    }
    return null;
  }

  Future<void> _storeIdInCache(String id) async {
    final cacheManager = DefaultCacheManager();
    await cacheManager.putFile(
      'survey_id',
      Uint8List.fromList(
          utf8.encode(id)),
      fileExtension: '.txt', 
    );
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
          text: "Questionnaires",
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
        child: FutureBuilder<List<Map<String, dynamic>>?>(
          future: _getSurveyData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            }

            if (snapshot.hasData) {
              List<Map<String, dynamic>> surveyList = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  for (var surveyData in surveyList) ...[
                    TextButton(
                      onPressed: () async {
                        await _storeIdInCache("${surveyData['_id']}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurveyQuestionsScreen(
                                id: "${surveyData['_id']}"),
                          ),
                        );
                      },
                      child: Text(
                        'Survey ID: ${surveyData['_id']} A Compléter',
                        style: const TextStyle(
                            color: AppColors.purpleSchood,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              );
            }
            return const Center(child: Text('No survey data available'));
          },
        ),
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 1,
      ),
    );
  }
}
