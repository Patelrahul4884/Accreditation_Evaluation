import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDUGlrxQcBswmf5Rr8zizk03-_1kkUi9Sg';
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
        print(json.decode(response.body));
  }
  Future<void> login(String email, String password) async {
    const url=
    'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDUGlrxQcBswmf5Rr8zizk03-_1kkUi9Sg';
     final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
        print(json.decode(response.body));
}
}