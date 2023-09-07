import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/Connexion_screen.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/global.dart' as global;
import 'package:url_launcher/url_launcher.dart';

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

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  LoginButton(
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
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      final textColor = themeProvider.isDarkModeEnabled
          ? Colors.white
          : AppColors.purple_Schood;

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
              color: textColor,
              fontSize: 12,
            ),
          ));
    });
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        signOutAndNavigateToLogin(context);
      },
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
        primary: AppColors.purple_Schood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
    );
  }
}

class HelpButtonWithArrow extends StatelessWidget {
  final route;
  final String text;

  HelpButtonWithArrow({required this.route, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.purple_Schood,
          borderRadius: BorderRadius.circular(26),
        ),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: H3ButtonTextApp(
                    text: text,
                  ),
                ),
                Row(
                  children: [
                    H4TextApp(
                      text: "Voir plus",
                      color: AppColors.background_lightMode,
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HelpCallButton extends StatelessWidget {
  final String number;
  HelpCallButton({required this.number});
  @override
  void _callURL() async {
    final url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible d\'ouvrir l\'URL $url';
    }
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.purple_Schood,
          borderRadius: BorderRadius.circular(26),
        ),
        child: InkWell(
          onTap: () {
            _callURL();
          },
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Center(
                      child: H3ButtonTextApp(
                    text: "Appeler $number",
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
