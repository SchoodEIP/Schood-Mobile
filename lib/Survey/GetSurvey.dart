import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import '../global.dart' as global;
import 'package:schood/main.dart';

Future<List<Map<String, dynamic>>?> _getSurveyData(BuildContext context) async {
    final getdata = GetClass();

    final response = await getdata.getData(global.globalToken, "/shared/questionnaire/");

    if (response.statusCode == 200) {
      try {
        final surveyData = jsonDecode(response.body);
        print(surveyData);
      } catch (e) {
        print('Erreur lors du décodage du JSON : $e');
      }
    } else {
      print(
          'Erreur lors de la récupération des données : ${response.statusCode}');
    }
    return null;
  }