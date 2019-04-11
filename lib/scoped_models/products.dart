import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/location_data.dart';
import '../models/product.dart';
import './connected_products.dart';

mixin ProductsModel on ConnectedProducts {
  bool showFavourites = false;

  void selectProduct(String productId) {
    selProductId = productId;
    if (productId == null) {
      return;
    }
    notifyListeners();
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
            'https://eaglevision-1554304063719.firebaseio.com/products/${productId}.json?auth=${authenticatedUser.token}')
        .then((http.Response response) {
      selProductId = null;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> updateProduct(
      {String title, String description, String image, double price, LocationData location}) {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/07/07/14/melting-choc-istock.jpg?w968h681',
      'price': price,
      'address': location.address,
      'longitude': location.longitude,
      'latitude': location.latitude,
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id
    };
    final int selectedProductIndex = products.indexWhere((Product product) {
      return product.id == selProductId;
    });
    return http
        .put(
            'https://eaglevision-1554304063719.firebaseio.com/products/${selectedProduct.id}.json?auth=${authenticatedUser.token}',
            body: json.encode(updateData))
        .then((http.Response response) {
      products[selectedProductIndex] = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          location: location,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id);
      selProductId = null;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> fetchProducts({bool onlyForUser = false}) {
    isLoading = true;
    return http
        .get(
            'https://eaglevision-1554304063719.firebaseio.com/products.json?auth=${authenticatedUser.token}')
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
            userId: productData['userId'],
            location: LocationData(
                address: productData['address'],
                longitude: productData['longitude'],
                latitude: productData['latitude']),
            is_favourite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(authenticatedUser.id));
        fetchedProductList.add(product);
      });
      selProductId = null;
      List<Product> filteredProducts =
          fetchedProductList.where((Product product) {
        return product.userId == authenticatedUser.id;
      }).toList();
      products = onlyForUser ? filteredProducts : fetchedProductList;
      isLoading = false;
      notifyListeners();
    });
  }

  void toggleFavourite() async {
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
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    products[selectedProductIndex] = updatedProduct;
    http.Response response;
    notifyListeners();
    if (newStatus) {
      response = await http.put(
          'https://eaglevision-1554304063719.firebaseio.com/products/${products[selectedProductIndex].id}/wishlistUsers/${authenticatedUser.id}.json?auth=${authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
        'https://eaglevision-1554304063719.firebaseio.com/products/${products[selectedProductIndex].id}/wishlistUsers/${authenticatedUser.id}.json?auth=${authenticatedUser.token}',
      );
    }

    if (response.statusCode != 201 && response.statusCode != 200) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          is_favourite: !newStatus,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id);
      products[selectedProductIndex] = updatedProduct;
    }

    selProductId = null;
    notifyListeners();
  }

  void toggleDisplayMode() {
    showFavourites = !showFavourites;
    notifyListeners();
  }
}
