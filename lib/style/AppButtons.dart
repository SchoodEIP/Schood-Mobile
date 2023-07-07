import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:schood/Connexion_screen.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/global.dart' as global;

class StandardButton extends StatelessWidget {
  final String text;
  final Function? function;

  StandardButton({required this.text, this.function});
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        function;
      },
      child: ButtonTextApp(text: text),
      style: ElevatedButton.styleFrom(
        primary: AppColors.purple_Schood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
    );
  }
}

class loginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  loginButton(
      {required this.emailController, required this.passwordController});
  _login(BuildContext context) async {
    var data = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };
    final postclass = Post_Class();
    try {
      Response response = await postclass.postData(context, data, 'user/login');
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final getdata = Get_Class();
        global.globalToken = body['token'];
        Response response2 =
            await getdata.getData(global.globalToken, "user/profile");

        Map<String, dynamic> userData = jsonDecode(response2.body);
        global.name = userData['firstname'];
        global.email = userData['email'];

        global.role = userData['role'];

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text(body['message']),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Une erreur s\'est produite.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _login(context);
      },
      child: ButtonTextApp(text: "Connexion"),
      style: ElevatedButton.styleFrom(
        primary: AppColors.purple_Schood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
    );
  }
}

class ForgottenPasswordButtonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgetPassword()),
          );
        },
        child: Text(
          "Mot de passe oublié ? Cliquez ici",
          style: GoogleFonts.inter(
            color: AppColors.purple_Schood,
            fontSize: 12,
          ),
        ));
  }
}

class logoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: ButtonTextApp(text: "Deconnexion"),
      style: ElevatedButton.styleFrom(
        primary: AppColors.red_Schood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
    );
  }
}

class HelpButton extends StatelessWidget {
  final route;
  final String text;
  HelpButton({required this.route, required this.text});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: ButtonTextApp(text: text),
      style: ElevatedButton.styleFrom(
        primary: AppColors.red_Schood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
    );
  }
}
