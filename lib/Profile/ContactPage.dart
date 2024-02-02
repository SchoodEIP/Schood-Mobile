import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schood/Profile/EmailValidationPage.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/SendEmail.dart';
import 'package:schood/global.dart' as global;

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final TextEditingController _messagecontroller = TextEditingController();
    List<Problem> problems = [
      Problem(
        'J\'ai un problème qui n\'est pas en lien avec l\'école',
        'Pour ce genre de problème, nous ne sommes malheureusement pas en mesure de vous aider.',
      ),
      Problem(
        'Il y a un bug',
        'OUPS! Nous sommes désolés que vous rencontriez un bug. Pourriez-vous remonter ce bug à notre équipe en utilisant l\'option \"Ouvrir un ticket\" ? Notre équipe se chargera de le corriger au plus vite.',
      ),
      Problem(
        'Je ne peux plus envoyer de message',
        'Si vous ne pouvez plus envoyé de message, essayer de redémarrer l\'application. Si le problème persiste, merci d\'ouvrir un ticket.',
      ),
    ];

    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.purpleSchood),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            H1TextApp(
              text: "About us",
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  for (var i in problems) ...[
                    ProblemCard(problem: i),
                    if (i == problems.last) ...[
                      SizedBox(height: 20),
                      EmailButton(
                        messagecontroller: _messagecontroller,
                      )
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Problem {
  final String title;
  final String solution;

  Problem(this.title, this.solution);
}

class ProblemCard extends StatefulWidget {
  final Problem problem;

  ProblemCard({required this.problem});

  @override
  _ProblemCardState createState() => _ProblemCardState();
}

class _ProblemCardState extends State<ProblemCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(widget.problem.title),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(widget.problem.solution),
            ),
        ],
      ),
    );
  }
}