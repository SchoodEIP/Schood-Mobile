import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schood/global.dart' as global;

class Post_Class {
  postData(context, data, url) async {
    var fullUrl = global.urlApi + url;
    final reponse = await http.post(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
      body: jsonEncode(data),
    );
    return reponse;
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
