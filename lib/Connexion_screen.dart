// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/TextFieldForm.dart';
import 'package:schood/global.dart' as global;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
            backgroundColor: themeProvider.getBackgroundColor(),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          // Empêcher le retour en arrière
          return false;
        },
 
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:32, bottom: 32),
                child: Image.asset('lib/assets/Schood_logo.png'),
              ),
              Container(height: 30),
              const Center(
                child: H3TextApp(
                  text: "Email",
                  color: AppColors.purpleSchood,
                ),
              ),
              AppTextFieldForm(
                hinttext: "email",
                validator: "email",
                controller: _emailcontroller,
              ),
              const SizedBox(height: 20.0),
              const Center(
                child: H3TextApp(
                  text: "Mot de passe",
                  color: AppColors.purpleSchood,
                ),
              ),
              AppTextFieldForm(
                hinttext: "mot de passe",
                obs: true,
                validator: "Password",
                controller: _passwordcontroller,
              ),

              const SizedBox(height: 40.0),
              LoginButton(
                emailController: _emailcontroller,
                passwordController: _passwordcontroller,
              ),

                             TextButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgetPassword()),
          );
        },
        child: Text(
          "Mot de passe oublié ? Cliquez ici",
 style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.purpleSchood
        ))),
              const StayConnectedButton(),
            ],
          ),
        ),
      ),
    );
  }
}

void signOutAndNavigateToLogin(BuildContext context) async {
  global.globalToken = '';
global.name = '';
global.firstName = '';
global.lastName = '';
global.classe ='';
global.classeid = '';
global.email = '';
global.role = '';
global.idtoken = '';
global.idimageprofil = '';
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),

  );
}

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailcontroller = TextEditingController();

void resetPassword(String email) async {
  try {
    PostClass postdata = PostClass();
    var data = {"email": email.trim()};
    print(email);
    Response response = await postdata.postData(context, data, "user/forgottenPassword/?mail=true");
    
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Email de réinitialisation envoyé'),
              content: const Text(
                  'Veuillez consulter votre boîte de réception pour réinitialiser votre mot de passe.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
    }  else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: Text('Erreur du serveur: ${response.statusCode} - ${response.reasonPhrase}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    print('Erreur lors de l\'envoi de l\'email de réinitialisation: $e');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text('Erreur: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}



  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.purpleSchood,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: H3TextApp(
              text: "Email",
            ),
          ),
          AppTextFieldForm(
            validator: "email",
            controller: _emailcontroller,
          ),
      ElevatedButton(  onPressed: () {
    resetPassword(_emailcontroller.text);
  },style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purpleSchood,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: ButtonTextApp(
        text: "Envoyer",
        color: AppColors.textDarkmode,
      ),
    )
        ],
      ),  
    );
  }
}
