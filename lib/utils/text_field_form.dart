// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:schood/style/app_colors.dart';

class AppTextFieldForm extends StatefulWidget {
  final String validator;
  final String? hinttext;
  final bool? obs;
  final TextEditingController controller;

  const AppTextFieldForm({
    super.key,
    this.hinttext,
    required this.validator,
    required this.controller,
    this.obs,
  });

  @override
  // ignore: library_private_types_in_public_api
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
        color: AppColors.pinkSchood,
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
          hintStyle: const TextStyle(color: Colors.white),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: widget.obs != null && widget.obs!
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.purpleSchood,
                  ),
                )
              : null,
        ),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
