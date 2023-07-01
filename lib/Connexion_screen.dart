import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/utils/TextFieldForm.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

/*  void signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print('Connecté avec succès: ${userCredential.user!.email}');
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur de connexion'),
            content: Text('Email ou mot de passe érroné, merci de réessayer.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }*/

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
                child: Text(
                  "Email",
                  style: GoogleFonts.inter(
                    color: AppColors.purpleSchood,
                    fontSize: 22,
                  ),
                ),
              ),
              AppTextFieldForm(
                validator: "email",
                controller: _emailController,
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  "Password",
                  style: GoogleFonts.inter(
                    color: AppColors.purpleSchood,
                    fontSize: 22,
                  ),
                ),
              ),
              AppTextFieldForm(
                obs: true,
                validator: "Password",
                controller: _passwordController,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {},
                //onPressed: signInWithEmailAndPassword,
                child: Text('Connection'),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.purpleSchood,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPassword()),
                  );
                },
                child: Text("Mot de passe oublié"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/create_account');
                },
                child: Text("Vous n'avez pas de compte ?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void signOutAndNavigateToLogin(BuildContext context) async {
  //await FirebaseAuth.instance.signOut();
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
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  void resetPassword() async {
    try {
      //await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      // Email de réinitialisation envoyé avec succès
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
          color: AppColors.purpleSchood,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Email",
              style: GoogleFonts.inter(
                color: AppColors.purpleSchood,
                fontSize: 22,
              ),
            ),
          ),
          AppTextFieldForm(
            validator: "email",
            controller: _emailController,
          ),
          ElevatedButton(
            onPressed: resetPassword,
            child: Text("Envoyer"),
            style: ElevatedButton.styleFrom(
              primary: AppColors.purpleSchood,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
