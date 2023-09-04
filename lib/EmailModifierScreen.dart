import 'package:flutter/material.dart';
import 'package:schood/ProfileScreen.dart';
import 'package:schood/style/AppColors.dart';


class EmailModifier extends StatefulWidget {
  const EmailModifier({Key? key}) : super(key: key);

  @override
  State<EmailModifier> createState() => _EmailModifierState();
}

class _EmailModifierState extends State<EmailModifier> {
  TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back, color: AppColors.purple_Schood),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen(email: _email.text)),
                );
              }),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                controller: _email,
                textAlign: TextAlign.center,
                cursorColor: AppColors.purple_Schood,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                      color: Color.fromARGB(146, 41, 41, 41),
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.purple_Schood,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(email: _email.text)));
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        )));
  }
}
