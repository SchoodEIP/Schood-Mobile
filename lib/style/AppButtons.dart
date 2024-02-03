// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
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
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StandardButton extends StatelessWidget {
  final String text;
  final Function? function;

  const StandardButton({super.key, required this.text, this.function});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        function;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purpleSchood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      child: ButtonTextApp(
        text: text,
        color: AppColors.textDarkmode,
      ),
    );
  }
}

class TokenFileManager {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static const String fileName = 'token_file.txt';

  static Future<void> writeTokenToFile(String token) async {
    try {
      final path = await _localPath;
      final file = File('$path/$fileName');
      await file.writeAsString(token);
    } catch (e) {
      if (kDebugMode) {
        print('Error writing token to file: $e');
      }
    }
  }

  static Future<String?> readTokenFromFile() async {
    try {
      final path = await _localPath;
      final file = File('$path/$fileName');
      final exists = await file.exists();
      if (exists) {
        final contents = await file.readAsString();
        return contents;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error reading token from file: $e');
      }
    }
    return null;
  }
}

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const LoginButton(
      {super.key,
      required this.emailController,
      required this.passwordController});

  _login(BuildContext context) async {
    var data = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };
    final postclass = PostClass();
    try {
      Response response = await postclass.postData(context, data, 'user/login');
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final getdata = GetClass();
        global.globalToken = body['token'];
        await TokenFileManager.writeTokenToFile(global.globalToken);

        final writtenToken = await TokenFileManager.readTokenFromFile();
        if (writtenToken == global.globalToken) {
          print('Token successfully written to the file!');

          final fileContent = await TokenFileManager.readTokenFromFile();
          print('Content of the file: $fileContent');

          final filePath = await TokenFileManager._localPath;
          print('Location of the file: $filePath/$TokenFileManager.fileName');
        } else {
          print('Error writing token to the file!');
        }

        Response response2 =
            await getdata.getData(global.globalToken, "user/profile");

        Map<String, dynamic> userData = jsonDecode(response2.body);
        global.name = userData['firstname'];
        global.email = userData['email'];
        global.idtoken = userData['_id'];
//        global.role = userData['role'];
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        }));
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erreur'),
              content: Text(body['message']),
              actions: [
                TextButton(
                  child: const Text('OK'),
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
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text('Une erreur s\'est produite.'),
            actions: [
              TextButton(
                child: const Text('OK'),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purpleSchood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      child: const ButtonTextApp(
        text: "Connexion",
        color: AppColors.textDarkmode,
      ),
    );
  }
}

class KeepConnectedButton extends StatefulWidget {
  const KeepConnectedButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KeepConnectedButtonState createState() => _KeepConnectedButtonState();
}

class _KeepConnectedButtonState extends State<KeepConnectedButton> {
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          isConnected = !isConnected;
          if (isConnected) {
            if (kDebugMode) {
              print('Connection established!');
            }
          } else {
            if (kDebugMode) {
              print('Connection disconnected!');
            }
          }
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isConnected ? Icons.check_box : Icons.check_box_outline_blank,
            color: Colors.black,
            size: 30.0,
          ),
          const SizedBox(width: 8.0),
          const Text(
            'Restez connecté',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class ForgottenPasswordButtonApp extends StatelessWidget {
  const ForgottenPasswordButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgetPassword()),
          );
        },
        child: Text(
          "Mot de passe oublié ? Cliquez ici",
          style: GoogleFonts.inter(
            color: themeProvider.getTextColor(),
            fontSize: 12,
          ),
        ));
  }
}

class EmailButton extends StatelessWidget {
  final TextEditingController messagecontroller;

  const EmailButton({super.key, required this.messagecontroller});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: global.email,
      queryParameters: {
        'subject': "[NOUVEAU TICKET] Problème avec l'application",
      },
    );
    return ElevatedButton(
      onPressed: () {
        // ignore: deprecated_member_use
        launch(emailLaunchUri.toString());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purpleSchood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      child: ButtonTextApp(
        text: "Ouvrir un ticket",
        color: themeProvider.textDarkMode,
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ElevatedButton(
      onPressed: () {
        signOutAndNavigateToLogin(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.redSchood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      child: ButtonTextApp(
        text: "Deconnexion",
        color: themeProvider.textDarkMode,
      ),
    );
  }
}

class HelpButton extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final route;
  final String text;
  const HelpButton({super.key, required this.route, required this.text});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purpleSchood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      child: ButtonTextApp(
        text: text,
        color: AppColors.backgroundLightmode,
      ),
    );
  }
}

class HelpButtonWithArrow extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final route;
  final String text;

  const HelpButtonWithArrow(
      {super.key, required this.route, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.purpleSchood,
          borderRadius: BorderRadius.circular(26),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => route));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: H3ButtonTextApp(
                    text: text,
                    color: AppColors.textDarkmode,
                  ),
                ),
                const Row(
                  children: [
                    H4TextApp(
                      text: "Voir plus",
                      color: AppColors.backgroundLightmode,
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
  const HelpCallButton({super.key, required this.number});
  void _callURL() async {
    final url = 'tel:$number';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Impossible d\'ouvrir l\'URL $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.purpleSchood,
          borderRadius: BorderRadius.circular(26),
        ),
        child: InkWell(
          onTap: () {
            _callURL();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Center(
                      child: H3ButtonTextApp(
                    text: "Appeler $number",
                    color: AppColors.textDarkmode,
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
