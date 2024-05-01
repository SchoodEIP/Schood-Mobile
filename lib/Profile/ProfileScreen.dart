// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:schood/Homepage_screen.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/main.dart';
import 'package:schood/style/AppColors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schood/global.dart' as global;
import 'package:schood/style/AppTexts.dart';

class ProfileScreen extends StatefulWidget {


  const ProfileScreen({Key? key,required this.email}) : super(key: key);
  final String email;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
    Uint8List? _pickedImage;

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final Directory cacheDir = await getTemporaryDirectory();
    const String fileName = 'picked_image.jpg';
    final File savedImage = File('${cacheDir.path}/$fileName');

    if (savedImage.existsSync()) {
      final Uint8List bytes = await savedImage.readAsBytes();
      setState(() {
        _pickedImage = bytes;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      await _saveImageToFile(bytes);
      await _loadSavedImage();
    }
  }

  Future<void> _saveImageToFile(Uint8List bytes) async {
    final Directory cacheDir = await getTemporaryDirectory();
    const String fileName = 'picked_image.jpg';
    final File imageFile = File('${cacheDir.path}/$fileName');
    await imageFile.writeAsBytes(bytes);

    print('Image saved to: ${imageFile.path}');
  }

  Future<void> _requestPermissionAndPickImage() async {
    var status = await Permission.photos.status;

    if (status.isDenied) {
      print('Permission denied. You cannot pick an image.');
    } else {
      await _pickImage();
      print('Permission granted. You can pick an image now.');
    }
  }

  @override
  Widget build(BuildContext context) {
     Uint8List ?photo = null;
    if (global.idimageprofil != "") {
      photo = base64Decode(global.idimageprofil);
    }
  final themeProvider = Provider.of<ThemeProvider>(context);
  print(global.idimageprofil);
    return Scaffold(
      appBar: AppBar(
              backgroundColor: themeProvider.getBackgroundColor(),
                      automaticallyImplyLeading: false,
                              elevation: 0.0,
            
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.purpleSchood),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),


        actions: [ InkWell(
            onTap: (){ Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
            },
            child: const Padding(
              padding:  EdgeInsets.all(8),
              child: Icon(Icons.notifications_none,
                  size: 40, color: AppColors.purpleSchood),
            ),
          ),
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
            backgroundColor: themeProvider.getBackgroundColor(),
      body: Column(
        children: [
          if (global.idimageprofil != "")
            ...[
            ],
          Container(
            alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(32),
            child: H1TextApp(text:"Profil"),
          ),
          InkWell(
            onTap: () {
              _requestPermissionAndPickImage();
            },
            child: global.idimageprofil != ""
  ? Image.memory(
      photo!,
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    )
  : Icon(
      Icons.account_circle,
      size: 200,
      color: AppColors.purpleSchood,
    ),
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
            child: H4TextApp(text:global.firstName,)
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
            child: H4TextApp(text:global.lastName)
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
            child: H4TextApp(text:global.classe),
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
child:H4TextApp(text: global.email),
                width: 200,
                /*child: TextField(
                  enabled: false,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: global.email,
                    enabledBorder: InputBorder.none,
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(14, 151, 74, 41),
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),*/
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