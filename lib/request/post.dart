import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const urlApi = "http://schood.fr:8080/";

class Post_Class{

  postData(context, data, url) async {
    var fullUrl = urlApi + url;
    final reponse = await http.post(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
      body: jsonEncode(data),
    );
    var token = (reponse.body);
    return reponse;
  }
  _setHeaders()=>{
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
  };
}