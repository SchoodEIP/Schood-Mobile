import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:schood/Connexion_screen.dart';

class ErrorChecker {
  static void checkError(BuildContext context, Response response) {
    try {
      if (response.statusCode == 200) {
        // Pas d'erreur, traitement normal
        print("Pas d'erreur - ${response.statusCode}");
      } else {
        // Gestion des erreurs
        showErrorDialog(context, response.statusCode);
      }
    } catch (e) {
      // Gestion des erreurs inattendues
      print("Erreur inattendue - $e");
    }
  }

  static void showErrorDialog(BuildContext context, int httpErrorCode) {
    String errorMessage = _getErrorMessage(httpErrorCode);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur HTTP $httpErrorCode'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (httpErrorCode == 403) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static String _getErrorMessage(int httpErrorCode) {
    switch (httpErrorCode) {
      case 400:
        return 'Requête invalide';
      case 401:
        return 'Non autorisé';
      case 403:
        return 'Erreur, veuillez vous reconnecter';
      case 404:
        return 'Ressource non trouvée';
      case 422:
        return 'Utilisateur inconnu';
      case 500:
        return 'Erreur interne du serveur';
      default:
        return 'Erreur inconnue';
    }
  }
}
