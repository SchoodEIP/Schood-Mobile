import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';

class DocsScreen extends StatefulWidget {
  @override
  _DocsScreenState createState() => _DocsScreenState();
}

class _DocsScreenState extends State<DocsScreen> {
  List<String> selectedMoods = [];
  bool? amIGoodShape;
  bool? amISatisfied;
  bool? areClassesGoingWell;
  bool? doIFeelDifficulties;
  bool? doIHaveProblemsWithClassmates;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            H3TextApp(
              text: "Comment te sens-tu aujourd'hui ?",
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.mood)),
                    MoodOption(
                      mood: 'Good',
                      isSelected: selectedMoods.contains('Good'),
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            selectedMoods.add('Good');
                          } else {
                            selectedMoods.remove('Good');
                          }
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.face)),
                    MoodOption(
                      mood: 'Neutral',
                      isSelected: selectedMoods.contains('Neutral'),
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            selectedMoods.add('Neutral');
                          } else {
                            selectedMoods.remove('Neutral');
                          }
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.mood_bad)),
                    MoodOption(
                      mood: 'Bad',
                      isSelected: selectedMoods.contains('Bad'),
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            selectedMoods.add('Bad');
                          } else {
                            selectedMoods.remove('Bad');
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            H3TextApp(
              text: "Suis je en bonne forme ?",
            ),
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: amIGoodShape,
                  onChanged: (value) {
                    setState(() {
                      amIGoodShape = value;
                    });
                  },
                ),
                H3TextApp(text: "Oui"),
                Radio<bool>(
                  value: false,
                  groupValue: amIGoodShape,
                  onChanged: (value) {
                    setState(() {
                      amIGoodShape = value;
                    });
                  },
                ),
                H3TextApp(text: "Non"),
              ],
            ),
            SizedBox(height: 30),
            H3TextApp(
              text: "Suis je satisfait de ma semaine ?",
            ),
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: amISatisfied,
                  onChanged: (value) {
                    setState(() {
                      amISatisfied = value;
                    });
                  },
                ),
                H3TextApp(text: "Oui"),
                Radio<bool>(
                  value: false,
                  groupValue: amISatisfied,
                  onChanged: (value) {
                    setState(() {
                      amISatisfied = value;
                    });
                  },
                ),
                H3TextApp(
                  text: "Non",
                ),
              ],
            ),
            SizedBox(height: 30),
            H3TextApp(
              text: "Les cours se déroulent-ils bien ?",
            ),
            SizedBox(height: 30),
            H3TextApp(
              text: "Ai je l'impression d'avoir des difficultés ?",
            ),
            SizedBox(height: 30),
            H3TextApp(
              text: "Ai je des problèmes avec mes camarades de classe ?",
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Envoyer le formulaire avec les humeurs sélectionnées
                if (selectedMoods.isNotEmpty) {
                  print('Selected moods: $selectedMoods');
                  print('Am I in good shape? $amIGoodShape');
                  print('Am I satisfied with my week? $amISatisfied');
                  // Ici, vous pouvez envoyer les données du formulaire à une API ou effectuer d'autres actions nécessaires.
                } else {
                  print('Please select at least one mood');
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBarApp(
        index_app: 1,
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
    required this.mood,
    required this.isSelected,
    required this.onSelected,
  });

  @override
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
