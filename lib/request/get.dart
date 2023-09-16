import 'package:http/http.dart' as http;
import 'package:schood/global.dart' as global;

class UserData {
  final String name;
  final String firstname;
  UserData({required this.name, required this.firstname});
}

class GetClass {
  getData(token, url) async {
    var fullUrl = global.urlApi + url;

    final reponse = await http.get(
      Uri.parse(fullUrl),
      headers: {'x-auth-token': token},
    );
    return reponse;
  }
}
