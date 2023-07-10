import 'package:flutter/material.dart';
import 'package:schood/style/AppColors.dart';

class AppTextFieldForm extends StatefulWidget {
  final String validator;
  final String? hinttext;
  final bool? obs;
  final TextEditingController controller;

  const AppTextFieldForm({
    this.hinttext,
    required this.validator,
    required this.controller,
    this.obs,
  });

  @override
  _AppTextFieldFormState createState() => _AppTextFieldFormState();
}

class _AppTextFieldFormState extends State<AppTextFieldForm> {
  bool obscure = true;

  @override
  void initState() {
    super.initState();
    if (widget.obs == null || widget.obs == false) {
      obscure = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.pink_Schood,
        borderRadius: BorderRadius.circular(26),
      ),
      child: TextFormField(
        obscureText: obscure,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.validator;
          }
          return null;
        },
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hinttext,
          hintStyle: TextStyle(color: Colors.white),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: widget.obs != null && widget.obs!
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.purple_Schood,
                  ),
                )
              : null,
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
