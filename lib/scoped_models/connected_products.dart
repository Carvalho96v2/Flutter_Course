import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProducts on Model {
  List<Product> products = [];
  User authenticatedUser;
  String selProductId;
  bool isLoading = false;

  Future<bool> addProduct(
      String title, String description, String image, double price) {
        isLoading = true;
      notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/07/07/14/melting-choc-istock.jpg?w968h681',
      'price': price,
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id
    };
    return http
        .post('https://eaglevision-1554304063719.firebaseio.com/products.json?auth=${authenticatedUser.token}',
            body: json.encode(productData))
        .then((http.Response response) {
          if(response.statusCode != 200 && response.statusCode != 201){
            isLoading = false;
            notifyListeners();
            return false;
          }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData["name"],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id);
      print(newProduct.id);
      products.add(newProduct);
      selProductId = null;
      isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
        isLoading = false;
        notifyListeners();
        return false;
    });
  }
}
