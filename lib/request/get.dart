import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


const urlApi = "http://schood.fr:8080/";

class Get_Class{

  getData(token, url) async {

    var fullUrl = urlApi + url;

    final reponse = await http.post(
      Uri.parse(fullUrl),
      headers: {'x-auth-token': token},
    );
    return reponse;
  }
}