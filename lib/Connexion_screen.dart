import 'package:flutter/material.dart';

import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/TextFieldForm.dart';

class LoginPage extends StatefulWidget {
  @override
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
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: H3TextApp(
                text: "Email",
              )),
              AppTextFieldForm(
                validator: "email",
                controller: _emailcontroller,
              ),
              SizedBox(height: 10.0),
              Center(
                  child: H3TextApp(
                text: "Mot de passe",
              )),
              AppTextFieldForm(
                obs: true,
                validator: "Password",
                controller: _passwordcontroller,
              ),
              ForgottenPasswordButtonApp(),
              SizedBox(height: 20.0),
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
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}

class ForgetPassword extends StatefulWidget {
  @override
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
            title: Text('Email de réinitialisation envoyé'),
            content: Text(
                'Veuillez consulter votre boîte de réception pour réinitialiser votre mot de passe.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Erreur lors de l\'envoi de l\'email de réinitialisation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: AppColors.purple_Schood,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
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
