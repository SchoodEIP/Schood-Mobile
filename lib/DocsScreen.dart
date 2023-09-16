// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';

class DocsScreen extends StatefulWidget {
  const DocsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
            const H3TextApp(
              text: "Comment te sens-tu aujourd'hui ?",
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.mood)),
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
                    IconButton(onPressed: () {}, icon: const Icon(Icons.face)),
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
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.mood_bad)),
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
            const SizedBox(height: 30),
            const H3TextApp(
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
                const H3TextApp(text: "Oui"),
                Radio<bool>(
                  value: false,
                  groupValue: amIGoodShape,
                  onChanged: (value) {
                    setState(() {
                      amIGoodShape = value;
                    });
                  },
                ),
                const H3TextApp(text: "Non"),
              ],
            ),
            const SizedBox(height: 30),
            const H3TextApp(
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
                const H3TextApp(text: "Oui"),
                Radio<bool>(
                  value: false,
                  groupValue: amISatisfied,
                  onChanged: (value) {
                    setState(() {
                      amISatisfied = value;
                    });
                  },
                ),
                const H3TextApp(
                  text: "Non",
                ),
              ],
            ),
            const SizedBox(height: 30),
            const H3TextApp(
              text: "Les cours se déroulent-ils bien ?",
            ),
            const SizedBox(height: 30),
            const H3TextApp(
              text: "Ai je l'impression d'avoir des difficultés ?",
            ),
            const SizedBox(height: 30),
            const H3TextApp(
              text: "Ai je des problèmes avec mes camarades de classe ?",
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Envoyer le formulaire avec les humeurs sélectionnées
                if (selectedMoods.isNotEmpty) {
                  // Ici, vous pouvez envoyer les données du formulaire à une API ou effectuer d'autres actions nécessaires.
                } else {}
              },
              child: const Text('Submit'),
            ),
          ],
        ),
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
