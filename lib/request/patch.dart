// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:schood/global.dart' as global;

class PatchClass {
  patchData(context, data, url) async {
    var fullUrl = global.urlApi + url;
    final response = await http.patch(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
      body: jsonEncode(data),
    );
    return response;
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}

class PatchFileClass {
  Future<http.Response> patchDataWithFile(
      Map<String, dynamic> data, String url, File file) async {
    var fullUrl = global.urlApi + url;

    var request = http.MultipartRequest('PATCH', Uri.parse(fullUrl));

    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(file.path),
      contentType: MediaType('application', 'octet-stream'),
    );
    request.files.add(multipartFile);

    // Send the request
    var response = await http.Response.fromStream(await request.send());

    return response;
  }
}
