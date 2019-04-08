import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import './connected_products.dart';

mixin ProductsModel on ConnectedProducts {
  bool showFavourites = false;

  void selectProduct(int index) {
    selProductIndex = index;
  }

  List<Product> get allProducts {
    return List.from(products);
  }

  List<Product> get displayedProducts {
    if(showFavourites){
      return List.from(products.where((Product product) => product.is_favourite).toList());
    }
    return List.from(products);
  }

  int get selectedProductIndex {
    return selProductIndex;
  }

  Product get selectedProduct {
    if (selProductIndex == null) {
      return null;
    }
    return products[selProductIndex];
  }



  void deleteProduct() {
    products.removeAt(selectedProductIndex);
    selProductIndex = null;
    notifyListeners();

  }

  void updateProduct({String title, String description, String image, double price}) {
    products[selectedProductIndex] = Product(title: title, description: description, image: image, price: price, userEmail: authenticatedUser.email, userId: authenticatedUser.id);
    selProductIndex = null;
    notifyListeners();
  }

  void toggleFavourite() {
    final bool isFavourite = products[selectedProductIndex].is_favourite;
    final bool newStatus = !isFavourite;
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        is_favourite: newStatus,
        userEmail: authenticatedUser.email,
        userId: authenticatedUser.id);
    products[selectedProductIndex] = updatedProduct;  
    selProductIndex = null;
    notifyListeners();
  }

  void toggleDisplayMode(){
    showFavourites = !showFavourites;
    notifyListeners();
  }
}
