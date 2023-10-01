// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/TextFieldForm.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                  child: H3TextApp(
                text: "Email",
              )),
              AppTextFieldForm(
                validator: "email",
                controller: _emailcontroller,
              ),
              const SizedBox(height: 10.0),
              const Center(
                  child: H3TextApp(
                text: "Mot de passe",
              )),
              AppTextFieldForm(
                obs: true,
                validator: "Password",
                controller: _passwordcontroller,
              ),
              const ForgottenPasswordButtonApp(),
              const SizedBox(height: 20.0),
              LoginButton(
                emailController: _emailcontroller,
                passwordController: _passwordcontroller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void signOutAndNavigateToLogin(BuildContext context) async {
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

  void resetPassword() async {
    try {
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
    } catch (e) {
      //print('Erreur lors de l\'envoi de l\'email de réinitialisation: $e');
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
          StandardButton(
            text: "Envoyer",
            function: resetPassword,
          )
        ],
      ),
    );
  }
}
