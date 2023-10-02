// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:schood/Homepage_screen.dart';
import 'package:schood/style/AppColors.dart';

class ProfileScreen extends StatelessWidget {
  final String firstName = 'firstname';
  final String lastName = 'lastname';
  final String classe = 'class';
  final String email;
  File? image;

  ProfileScreen({Key? key, required this.email}) : super(key: key);

  Future getImage() async {
    try {
       final image = await ImagePicker().pickImage(source: ImageSource.gallery);

       if (image == null) return;

        final imageTemp = File(image.path);

        setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.purpleSchood),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child:
                  Icon(Icons.settings, size: 40, color: AppColors.purpleSchood),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 10, left: 30),
            child: const Text('Profile',
                style: TextStyle(
                    color: AppColors.backgroundDarkmode,
                    fontSize: 30,
                    fontWeight: FontWeight.w600)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Icon(Icons.account_circle,
                size: 200, color: AppColors.purpleSchood),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text('Prénom:',
                style: TextStyle(
                    color: AppColors.purpleSchood,
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(firstName,
                style: const TextStyle(
                    color: AppColors.backgroundDarkmode,
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text('Nom de famille:',
                style: TextStyle(
                    color: AppColors.purpleSchood,
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(lastName,
                style: const TextStyle(
                    color: AppColors.backgroundDarkmode,
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text('Classe:',
                style: TextStyle(
                    color: AppColors.purpleSchood,
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(classe,
                style: const TextStyle(
                    color: AppColors.backgroundDarkmode,
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text('Adresse email:',
                style: TextStyle(
                    color: AppColors.purpleSchood,
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  enabled: false,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: email,
                    enabledBorder: InputBorder.none,
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(146, 41, 41, 41),
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: IconButton(
                  icon: const Icon(Icons.create, color: AppColors.purpleSchood),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/emailModifier'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
