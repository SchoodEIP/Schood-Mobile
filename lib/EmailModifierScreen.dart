import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schood/style/AppColors.dart';

class EmailModifier extends StatelessWidget {
  String email = 'email';
  final TextEditingController _textFieldController = TextEditingController();
  EmailModifier({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.purple_Schood),
            onPressed: () => Navigator.pop(context, email),
          ),
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
                controller: _textFieldController,
                textAlign: TextAlign.center,
                cursorColor: AppColors.purple_Schood,
                decoration: InputDecoration(
                  hintText: '$email',
                  hintStyle: const TextStyle(
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
                String textFieldContent = _textFieldController.text;
                email = textFieldContent;
                Navigator.pop(context, email);
              },
              child: Text('Sauvegarder'),
            ),
          ],
        )));
  }
}
