import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> httpRequest(
    String url, String method, {Map<String, dynamic>? body}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String baseUrl = "http://192.168.67.52:3000";

  // Ensure token is not null
  if (token == null) {
    throw Exception("Token not found in SharedPreferences");
  }

  Uri fullUrl = Uri.parse("$baseUrl/$url");

  try {
    http.Response response;

    // Handle HTTP methods
    if (method.toLowerCase() == "get") {
      response = await http.get(
        fullUrl,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
    } else if (method.toLowerCase() == "post") {
      response = await http.post(
        fullUrl,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode(body), // Encode the body to JSON format
      );
    } else if (method.toLowerCase() == "delete") {
      response = await http.delete(
        fullUrl,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
    } else {
      throw Exception("Unsupported HTTP method: $method");
    }

    // Check for successful response
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
          "Failed to fetch data. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error during HTTP request: $e");
  }
}
