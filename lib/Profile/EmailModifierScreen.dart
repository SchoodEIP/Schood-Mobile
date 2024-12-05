import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:schood/Profile/ProfileScreen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/patch.dart';
import 'package:schood/request/post.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/global.dart' as global;

class EmailModifier extends StatefulWidget {
  const EmailModifier({Key? key}) : super(key: key);

  @override
  State<EmailModifier> createState() => _EmailModifierState();
}

class _EmailModifierState extends State<EmailModifier> {
  final TextEditingController _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    _email.text = global.email; 
  }

  void _modifyemail() async {
    final patchdata = PatchClass();
    var newemail = _email.text; 
    var data = { 
      "email": newemail,
    };

    try{
     Response response = await patchdata.patchData(global.globalToken, data, "user/modifyProfile/${global.idtoken}");
          print(response.body);
          print("test");
          global.email = newemail;

    }catch(e){
      print("erreur");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.purpleSchood),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(email: _email.text),
              ),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const H1TextApp(
              text: "Modifier l'adresse mail",
            ),
            const SizedBox(height: 120.0),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      style: TextStyle(color: themeProvider.getTextColor()),
                      controller: _email,
                      textAlign: TextAlign.center,
                      cursorColor: AppColors.purpleSchood,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: themeProvider.getTextColor(),
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.purpleSchood,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {
                      _modifyemail();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(email: _email.text),
                        ),
                      );
                    },
                    child: const Text('Sauvegarder'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
