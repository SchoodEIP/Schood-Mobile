import 'package:flutter/material.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/style/AppTexts.dart';

class EmailValidation extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            H2TextApp(
              text: "Email envoyé avec succès",
            ),
            SizedBox(height: 20),
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page d'accueil ici
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text('Retour sur la page principale'),
            ),
          ],
        ),
      ),
    );
  }
}
