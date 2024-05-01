import 'package:flutter/material.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppTexts.dart';

class AlerteScreen extends StatefulWidget {
  @override
  _AlerteScreenState createState() => _AlerteScreenState();
}

class _AlerteScreenState extends State<AlerteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alertes'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
          children: [
            H1TextApp(text: "Alertes"),
            SizedBox(height: 120.0),
            Center(
              child: Column(
                children: [
                  StandardButton(text: "Créer une alerte"),
                  StandardButton(text: "Voir les alertes"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
