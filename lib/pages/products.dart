import 'package:flutter/material.dart';

import './side_drawer.dart';
import '../product_manager.dart';

class ProductsPage extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  ProductsPage(this.products);

  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }

}

class _ProductsPageState extends State<ProductsPage> {
  bool _sort = false;
  List<Map<String, dynamic>> _products ;
  IconData filter_icon = Icons.sort;

  @override
  Widget build(BuildContext context) {
    _products = widget.products;
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: <Widget>[
          IconButton(
            icon: Icon(filter_icon),
            onPressed: () {
              setState(() {
                _sort = !_sort; 
                
                if(_sort){
                  filter_icon = Icons.short_text;
                  for (var product in widget.products) {
                    if (product['is_favourite']) {
                      _products.add(product);
                    }
                  }
                } else {
                  filter_icon = Icons.sort;
                  _products = widget.products;
                }
              });
            },
          )
        ],
      ),
      body: ProductManager(_products),
    );
  }
}
