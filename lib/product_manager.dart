import 'package:flutter/material.dart';

import './products.dart';
import 'product_control.dart';

class ProductManager extends StatefulWidget {
  final Map<String, String> startingProduct;

  ProductManager({this.startingProduct});

  @override
  State<StatefulWidget> createState() {
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<Map<String, String>> _products = [];

  @override
  void initState() {
    //called whenever this state object is initialised (when ProductManager is rendered for this first time)
    super.initState();
    if (widget.startingProduct != null) {
      _products.add(widget.startingProduct);
    }
  }

  void _addProduct(Map<String, String> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index){
    setState(() {
      _products.removeAt(index); 
    });
  }

  @override
  Widget build(BuildContext context) {
    Column column = Column(
      children: [
        Container(
          child: ProductControl(_addProduct),
          margin: EdgeInsets.all(10.0),
        ),
        Expanded(child: Products(_products, _deleteProduct))
      ],
    );
    return column;
  }
}
