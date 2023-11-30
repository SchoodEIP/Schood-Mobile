// ignore_for_file: file_names
import 'dart:convert';
import 'dart:ffi';

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
  bool? amIGoodShape;
  bool? amISatisfied;
  bool? areClassesGoingWell;
  bool? doIFeelDifficulties;
  bool? doIHaveProblemsWithClassmates;
  String id = global.globalToken;

  @override
  _getSurvey(BuildContext context) async {
    final getdata = GetClass();
    print(global.globalToken);
    final response = await getdata.getData(global.globalToken, "student/questionnaire");
  }

  Widget build(BuildContext context) {
    _getSurvey(context);
    return Scaffold(
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
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       const H3TextApp(
      //         text: "Comment te sens-tu aujourd'hui ?",
      //       ),
      //       const SizedBox(
      //         height: 30,
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           Column(
      //             children: [
      //               IconButton(onPressed: () {}, icon: const Icon(Icons.mood)),
      //               MoodOption(
      //                 mood: 'Good',
      //                 isSelected: selectedMoods.contains('Good'),
      //                 onSelected: (isSelected) {
      //                   setState(() {
      //                     if (isSelected) {
      //                       selectedMoods.add('Good');
      //                     } else {
      //                       selectedMoods.remove('Good');
      //                     }
      //                   });
      //                 },
      //               ),
      //             ],
      //           ),
      //           Column(
      //             children: [
      //               IconButton(onPressed: () {}, icon: const Icon(Icons.face)),
      //               MoodOption(
      //                 mood: 'Neutral',
      //                 isSelected: selectedMoods.contains('Neutral'),
      //                 onSelected: (isSelected) {
      //                   setState(() {
      //                     if (isSelected) {
      //                       selectedMoods.add('Neutral');
      //                     } else {
      //                       selectedMoods.remove('Neutral');
      //                     }
      //                   });
      //                 },
      //               ),
      //             ],
      //           ),
      //           Column(
      //             children: [
      //               IconButton(
      //                   onPressed: () {}, icon: const Icon(Icons.mood_bad)),
      //               MoodOption(
      //                 mood: 'Bad',
      //                 isSelected: selectedMoods.contains('Bad'),
      //                 onSelected: (isSelected) {
      //                   setState(() {
      //                     if (isSelected) {
      //                       selectedMoods.add('Bad');
      //                     } else {
      //                       selectedMoods.remove('Bad');
      //                     }
      //                   });
      //                 },
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //       const SizedBox(height: 30),
      //       const H3TextApp(
      //         text: "Suis je en bonne forme ?",
      //       ),
      //       Row(
      //         children: [
      //           Radio<bool>(
      //             value: true,
      //             groupValue: amIGoodShape,
      //             onChanged: (value) {
      //               setState(() {
      //                 amIGoodShape = value;
      //               });
      //             },
      //           ),
      //           const H3TextApp(text: "Oui"),
      //           Radio<bool>(
      //             value: false,
      //             groupValue: amIGoodShape,
      //             onChanged: (value) {
      //               setState(() {
      //                 amIGoodShape = value;
      //               });
      //             },
      //           ),
      //           const H3TextApp(text: "Non"),
      //         ],
      //       ),
      //       const SizedBox(height: 30),
      //       const H3TextApp(
      //         text: "Suis je satisfait de ma semaine ?",
      //       ),
      //       Row(
      //         children: [
      //           Radio<bool>(
      //             value: true,
      //             groupValue: amISatisfied,
      //             onChanged: (value) {
      //               setState(() {
      //                 amISatisfied = value;
      //               });
      //             },
      //           ),
      //           const H3TextApp(text: "Oui"),
      //           Radio<bool>(
      //             value: false,
      //             groupValue: amISatisfied,
      //             onChanged: (value) {
      //               setState(() {
      //                 amISatisfied = value;
      //               });
      //             },
      //           ),
      //           const H3TextApp(
      //             text: "Non",
      //           ),
      //         ],
      //       ),
      //       const SizedBox(height: 30),
      //       const H3TextApp(
      //         text: "Les cours se déroulent-ils bien ?",
      //       ),
      //       const SizedBox(height: 30),
      //       const H3TextApp(
      //         text: "Ai je l'impression d'avoir des difficultés ?",
      //       ),
      //       const SizedBox(height: 30),
      //       const H3TextApp(
      //         text: "Ai je des problèmes avec mes camarades de classe ?",
      //       ),
      //       const SizedBox(height: 30),
      //       ElevatedButton(
      //         onPressed: () {
      //           // Envoyer le formulaire avec les humeurs sélectionnées
      //           if (selectedMoods.isNotEmpty) {
      //             // Ici, vous pouvez envoyer les données du formulaire à une API ou effectuer d'autres actions nécessaires.
      //           } else {}
      //         },
      //         child: const Text('Submit'),
      //       ),
      //     ],
      //   ),
      ),
      bottomNavigationBar: const BottomBarApp(
        indexapp: 1,
        //Userinfo: widget.Userinfo,
      ),
    );
  }
}

class MoodOption extends StatefulWidget {
  final String mood;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const MoodOption({
    super.key,
    required this.mood,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MoodOptionState createState() => _MoodOptionState();
}

class _MoodOptionState extends State<MoodOption> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _isSelected,
      onChanged: (newValue) {
        setState(() {
          _isSelected = newValue!;
          widget.onSelected(newValue);
        });
      },
    );
  }
}
