import 'package:http/http.dart' as http;
import 'package:schood/global.dart' as global;

class User_Data {
  final String name;
  final String firstname;
  User_Data({required this.name, required this.firstname});
}

class Get_Class {
  getData(token, url) async {
    var fullUrl = global.urlApi + url;

    final reponse = await http.get(
      Uri.parse(fullUrl),
      headers: {'x-auth-token': token},
    );
    return reponse;
  }
}
