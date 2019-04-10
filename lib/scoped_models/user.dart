import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import './connected_products.dart';
import '../models/user.dart';
import '../models/auth.dart';

mixin UserModel on ConnectedProducts {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyA6x6uJjZdXnVBDOlHSoIKSgYi9Gd2pu9w',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(authData),
      );
    } else {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyA6x6uJjZdXnVBDOlHSoIKSgYi9Gd2pu9w',
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(authData));
    }

    bool hasError = true;
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    String message = 'Oops, something went wrong! Please try again later.';

    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      authenticatedUser = User(
          id: responseData['localId'],
          email: responseData['email'],
          token: responseData['idToken']);

      setAuthTimeout(int.parse(responseData['expiresIn']));
      final DateTime now = DateTime.now();
      final expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final SharedPreferences prefs =
          await SharedPreferences.getInstance(); //this is asynchronous
      prefs.setString('token', authenticatedUser.token);
      prefs.setString('email', authenticatedUser.email);
      prefs.setString('id', authenticatedUser.id);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
      _userSubject.add(true);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'No user with that email address was found';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Please enter a valid password';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Email already exists!';
    }

    isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final DateTime parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        authenticatedUser = null;
        return;
      }
      final String userEmail = prefs.getString('email');
      final String userId = prefs.getString('id');
      final tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _authTimer.cancel();
    prefs.remove('token');
    prefs.remove('email');
    prefs.remove('id');
    _userSubject.add(false);
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), () => logout);
  }
}
