import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import './connected_products.dart';

mixin ProductsModel on ConnectedProducts {
  bool showFavourites = false;

  void selectProduct(String productId) {
    selProductId = productId;
  }

  List<Product> get allProducts {
    return List.from(products);
  }

  List<Product> get displayedProducts {
    if (showFavourites) {
      return List.from(
          products.where((Product product) => product.is_favourite).toList());
    }
    return List.from(products);
  }

  String get selectedProductId {
    return selProductId;
  }

  Product get selectedProduct {
    if (selProductId == null) {
      return null;
    }
    return products.firstWhere((Product product) {
      return product.id == selProductId;
    });
  }

  void deleteProduct() {
    isLoading = true;
    final productId = selectedProduct.id;
    final int selectedProductIndex = products.indexWhere((Product product) {
      return product.id == selProductId;
    });
    products.removeAt(selectedProductIndex);
    selProductId = null;
    notifyListeners();
    http
        .delete(
            'https://eaglevision-1554304063719.firebaseio.com/products/${productId}.json')
        .then((http.Response response) {
          selProductId = null;
          isLoading = false;
          notifyListeners();
        });
  }

  Future<Null> updateProduct(
      {String title, String description, String image, double price}) {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/07/07/14/melting-choc-istock.jpg?w968h681',
      'price': price,
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id
    };
    final int selectedProductIndex = products.indexWhere((Product product) {
      return product.id == selProductId;
    });
    return http
        .put(
            'https://eaglevision-1554304063719.firebaseio.com/products/${selectedProduct.id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      products[selectedProductIndex] = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id);
      selProductId = null;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> fetchProducts() {
    isLoading = true;
    return http
        .get('https://eaglevision-1554304063719.firebaseio.com/products.json')
        .then((http.Response response) {
      final Map<String, dynamic> productListData = json.decode(response.body);
      final List<Product> fetchedProductList = [];
      if (productListData == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);
        fetchedProductList.add(product);
      });
      selProductId = null;
      products = fetchedProductList;
      isLoading = false;
      notifyListeners();
    });
  }

  void toggleFavourite() {
    final int selectedProductIndex = products.indexWhere((Product product) {
      return product.id == selProductId;
    });
    final bool isFavourite = products[selectedProductIndex].is_favourite;
    final bool newStatus = !isFavourite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        is_favourite: newStatus,
        userEmail: authenticatedUser.email,
        userId: authenticatedUser.id);
    products[selectedProductIndex] = updatedProduct;
    selProductId = null;
    notifyListeners();
  }

  void toggleDisplayMode() {
    showFavourites = !showFavourites;
    notifyListeners();
  }
}
