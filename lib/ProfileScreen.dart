// ignore: file_names
import 'package:flutter/material.dart';
import 'package:schood/EmailModifierScreen.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/style/AppColors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatelessWidget {
  final String firstName = 'firstname';
  final String lastName = 'lastname';
  final String classe = 'class';
  final String email;

  const ProfileScreen({Key? key, required this.email}) : super(key: key);

  // Method to pick an image using the image picker
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Handle the selected image as needed
      // For example, set it as the profile picture or perform any other action
    }
  }

  // Method to request permission and pick an image using the image picker
  Future<void> _requestPermissionAndPickImage() async {
    const permission = Permission.photos;

    if (await permission.isDenied) {
      final result = await permission.request();

      if (result.isGranted) {
        // Permission is granted, proceed to pick an image
        await _pickImage();
      } else if (result.isDenied) {
        // Permission is denied
        // Handle accordingly, e.g., show a message to the user
      } else if (result.isPermanentlyDenied) {
        // Permission is permanently denied
        // Handle accordingly, e.g., show a message to the user to enable permissions in settings
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.purple_Schood),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
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
              child: Icon(Icons.settings,
                  size: 40, color: AppColors.purple_Schood),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 10, bottom: 15, left: 30),
            child: const Text('Profile',
                style: TextStyle(
                    color: AppColors.background_darkMode,
                    fontSize: 30,
                    fontWeight: FontWeight.w600)),
          ),
          InkWell(
            onTap: () {
              _requestPermissionAndPickImage(); // Call the method to request permission and pick an image
            },
            child: Icon(Icons.account_circle,
                size: 200, color: AppColors.purple_Schood),
          ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text('Prénom:',
                  style: TextStyle(
                      color: AppColors.purple_Schood,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(firstName,
                  style: const TextStyle(
                      color: AppColors.background_darkMode,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text('Nom de famille:',
                  style: TextStyle(
                      color: AppColors.purple_Schood,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(lastName,
                  style: const TextStyle(
                      color: AppColors.background_darkMode,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text('Classe:',
                  style: TextStyle(
                      color: AppColors.purple_Schood,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(classe,
                  style: const TextStyle(
                      color: AppColors.background_darkMode,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text('Adresse email:',
                  style: TextStyle(
                      color: AppColors.purple_Schood,
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
                    icon: const Icon(Icons.create,
                        color: AppColors.purple_Schood),
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, '/emailModifier'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }