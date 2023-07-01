import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/utils/TextFieldForm.dart';

class CreateProfilePage extends StatefulWidget {
  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  /*Future<void> _createProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String userId = userCredential.user!.uid;

        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(userId)
            .set({
          'Prénom': _firstNameController.text,
          'Nom': _lastNameController.text,
          'Email': _emailController.text,
          'Status': "Étudiant"
        });

        Navigator.pop(context);
      } catch (e) {
        print('Error creating profile: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred while creating the profile.'),
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
  }*/

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IconButton(
                onPressed: () {},
                color: AppColors.purpleSchood,
                icon: Icon(Icons.person),
                iconSize: 72,
              ),
              SizedBox(height: 16),
              Center(
                  child: Text("Name",
                      style: GoogleFonts.inter(
                          color: AppColors.purpleSchood, fontSize: 22))),
              AppTextFieldForm(
                  hinttext: "Name",
                  validator: "Please enter your name",
                  controller: _firstNameController),
              SizedBox(height: 16),
              Center(
                child: Text("Lastname",
                    style: GoogleFonts.inter(
                        color: AppColors.purpleSchood, fontSize: 22)),
              ),
              AppTextFieldForm(
                  validator: "Please enter your lastname",
                  hinttext: "Lastname",
                  controller: _lastNameController),
              SizedBox(height: 16),
              Center(
                child: Text("Email",
                    style: GoogleFonts.inter(
                        color: AppColors.purpleSchood, fontSize: 22)),
              ),
              AppTextFieldForm(
                  validator: "Please enter your email",
                  hinttext: "Email",
                  controller: _emailController),
              SizedBox(height: 16),
              Center(
                child: Text(
                  "Password",
                  style: GoogleFonts.inter(
                      color: AppColors.purpleSchood, fontSize: 22),
                ),
              ),
              AppTextFieldForm(
                  obs: true,
                  validator: "Please enter your password",
                  hinttext: "Password",
                  controller: _passwordController),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {},
                //onPressed: _createProfile,
                style: ElevatedButton.styleFrom(
                  primary: AppColors.purpleSchood,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text('Create Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmationInscription extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Text("Thanks !"),
        Text("You will receive a confirmation by email")
      ]),
    );
  }
}
