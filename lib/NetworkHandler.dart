import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseurl = "https://flutter-server.herokuapp.com";

  var log = Logger();

  Future get(String url) async {
    url = formater(url);
    // /user/register
    var response = await http.get(Uri.parse(url));
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);

      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

   Future<http.Response> post(String url, Map<String, String> body) async {    url = formater(url);
    log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      body: json.encode(body),
    );
    return response;
    log.d(response.body);
    log.d(response.statusCode);
  }

  String formater(String url) {
    return baseurl + url;
  }
}
