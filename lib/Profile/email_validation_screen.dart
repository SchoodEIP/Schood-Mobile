import 'package:flutter/material.dart';
import 'package:schood/homepage_screen.dart';
import 'package:schood/style/app_texts.dart';

class EmailValidation extends StatelessWidget {
  const EmailValidation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const H2TextApp(
              text: "Email envoyé avec succès",
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page d'accueil ici
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
              child: const Text('Retour sur la page principale'),
            ),
          ],
        ),
      ),
    );
  }
}
