import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:schood/global.dart' as global;

class DeleteClass {
  deleteData(context, data, url) async {
    var fullUrl = global.urlApi + url;
    final reponse = await http.post(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
      body: jsonEncode(data),
    );
    return reponse;
  }

  deleteDataAuth(context, data, url) async {
    var fullUrl = global.urlApi + url;
    print(data);
    final response = await http.post(Uri.parse(fullUrl),
        headers: {
          'x-auth-token': global.globalToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data));
    return response;
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
