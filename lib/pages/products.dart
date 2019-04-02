import 'package:flutter/material.dart';

import './side_drawer.dart';
import '../product_manager.dart';

class ProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  ProductsPage(this.products);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        drawer: SideDrawer(),
        appBar: AppBar(
          title: Text('EasyList'),
        ),
        body: ProductManager(products),
      );
  }
}
