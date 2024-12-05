import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schood/Help/help_list.dart';
import 'package:schood/Notification/Notification_screen.dart';
import 'package:schood/main.dart';
import 'package:schood/request/get.dart';
import 'package:schood/style/AppButtons.dart';
import 'package:schood/style/AppColors.dart';
import 'package:schood/style/AppTexts.dart';
import 'package:schood/utils/BottomBarApp.dart';
import 'package:schood/global.dart' as global;

class HelpModifyScreen extends StatefulWidget {
  const HelpModifyScreen({Key? key}) : super(key: key);

  @override
  _HelpModifyScreenState createState() => _HelpModifyScreenState();
}

class _HelpModifyScreenState extends State<HelpModifyScreen> {
  List<dynamic> categories = [];

  @override
  void initState() {
    _getcategory();
    super.initState();
    _getcategory();

  }

  _getcategory() async {
    final getdata = GetClass();
    final response = await getdata.getData(global.globalToken, "user/helpNumbersCategories");
    print(response.body);
    setState(() {
      categories = jsonDecode(response.body);
    });
  }

  @override
  
  Widget build(BuildContext context) {



    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getBackgroundColor(),
       appBar: AppBar(
        backgroundColor: themeProvider.getBackgroundColor(),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: AppColors.purpleSchood,
                  ),
                  const SizedBox(width: 8),
                  H4TextApp(
                    text: "Retour",
                    color: themeProvider.getTextColor(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H1TextApp(text: "Aides"),
            const SizedBox(height: 120.0),
             Center(
              child: Column(
  children: categories.isEmpty
  ? [CircularProgressIndicator()]
  : categories.map((category) {
      return HelpButtonWithArrow(
        route: HelpList(categoryId: category['_id'], categoryName: category['name']), // Passer le nom de la catégorie ici
        text: category['name'],
      );
    }).toList(),

              ),
            ),
        ],
        ),
      )),
     
    );
  }
}