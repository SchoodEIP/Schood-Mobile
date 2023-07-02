import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const urlApi = "http://schood.fr:8080/";

class User_Data {
  final String name;
  final String firstname;
  User_Data({required this.name, required this.firstname});
}

class Get_Class {
  getData(token, url) async {
    var fullUrl = urlApi + url;

    final reponse = await http.get(
      Uri.parse(fullUrl),
      headers: {'x-auth-token': token},
    );
    return reponse;
  }
}
