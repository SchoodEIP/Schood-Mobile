// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/Survey/SurveyQuestionScreen.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
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
    Uint8List? photo;
    if (global.idimageprofil != "") {
      photo = base64Decode(global.idimageprofil);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.notifications_none,
                  size: 40, color: AppColors.purpleSchood),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            icon: Container(
              width: 40,
              height: 40,
              child: Icon(
                Icons.account_circle,
                size: 40,
                color: AppColors.purpleSchood,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: themeProvider.getBackgroundColor(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: H1TextApp(
              text: "Historique",
              color: themeProvider.getTextColor(),
            ),
          ),
          SingleChildScrollView(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${surveyData['title']} à compléter',
                                style: const TextStyle(
                                  color: AppColors.purpleSchood,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              H4TextApp(
                                text: "Du " +
                                    _formatDate(surveyData['fromDate']) +
                                    " au " +
                                    _formatDate(surveyData['toDate']),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                }
                return const Center(child: Text('Pas de questionnaire'));
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 1,
      ),
    );
  }
String _formatDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  String day = date.day.toString().padLeft(2, '0');
  String month = date.month.toString().padLeft(2, '0');
  String year = date.year.toString();
  return "$day/$month/$year";
}
}