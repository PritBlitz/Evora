import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';
import '../models/user_model.dart';

class ApiService {
  static const String eventUrl = "https://powerful-art-production.up.railway.app/events";
  static const String registerUrl = "https://evora-production.up.railway.app/api/users";

  static Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse(eventUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception("Failed to load events");
    }
  }

  static Future<bool> registerUser(User user) async {
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    return response.statusCode == 201;
  }
}
