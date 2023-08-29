import 'package:flutter/material.dart';
import 'package:schood/style/AppColors.dart';

class EmailModifier extends StatelessWidget {
  final String email = 'OldEmail';
  const EmailModifier({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.purple_Schood),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: TextField(
        textAlign: TextAlign.center,
        cursorColor: AppColors.purple_Schood,
        decoration: InputDecoration(
          hintText: '$email',
          enabledBorder: InputBorder.none,
          hintStyle: const TextStyle(
              color: Color.fromARGB(146, 41, 41, 41),
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),
      ),

      // TODO ADD SAVE BUTTON
    );
  }
}
