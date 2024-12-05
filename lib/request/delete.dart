import 'package:http/http.dart' as http;
import 'package:schood/global.dart' as global;

class DeleteClass {
  deleteData(token, url) async {
    var fullUrl = global.urlApi + url;

    final response = await http.delete(
      Uri.parse(fullUrl),
      headers: {'x-auth-token': token},
    );
    return response;
  }

  deleteDataAuth(url) async {
    var fullUrl = global.urlApi + url;

    final response = await http.delete(
      Uri.parse(fullUrl),
      headers: {
        'x-auth-token': global.globalToken,
        'Content-Type': 'application/json',
      },
    );
    return response;
  }
}
