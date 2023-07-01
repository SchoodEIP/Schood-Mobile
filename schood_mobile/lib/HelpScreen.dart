import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schood/utils/BottomBarApp.dart';

class HelpScreen extends StatelessWidget {
  final User? Userinfo;
  HelpScreen({required this.Userinfo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Aide'), automaticallyImplyLeading: false),
        body: Center(child: Text('Écran d\'aide')),
        bottomNavigationBar: BottomBarApp(
          index_app: 4,
          Userinfo: Userinfo,
        ));
  }
}
