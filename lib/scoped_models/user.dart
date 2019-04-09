import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import './connected_products.dart';
import '../models/user.dart';

mixin UserModel on ConnectedProducts {
  Map<String, dynamic> login(String email, String password) {

    authenticatedUser = User(id: 'avewve', email: email, password: password);

    return {'success' : true, 'message': 'Authentication Succeeded'};

  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final http.Response response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyA6x6uJjZdXnVBDOlHSoIKSgYi9Gd2pu9w',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(authData),
    );

    bool hasError = true;
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    String message = 'Oops, something went wrong! Please try again later.';
    if(responseData.containsKey('idToken')){
      hasError = false;
       message = 'Authentication succeeded!';
    } else if(responseData['error']['message'] == 'EMAIL_EXISTS'){
      message = 'Email already exists!';
    } 

    isLoading = false;
    notifyListeners();
    return {'success' : !hasError, 'message': message};

  }
}
