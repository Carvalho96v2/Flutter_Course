import 'package:flutter/material.dart';

import './products.dart'; 

class ProductManager extends StatefulWidget {

  final String startingProduct;

  ProductManager({this.startingProduct});

  @override
  State<StatefulWidget> createState() {
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<String> _products = [];
  
  @override
  void initState() { //called whenever this state object is initialised (when ProductManager is rendered for this first time)
    super.initState();
    if (widget.startingProduct != null) {
      _products.add(widget.startingProduct);
    }
  }


  @override
  Widget build(BuildContext context) {
    Column column = Column(
      children: [
        Container(
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            onPressed: () {
              setState(() {
                _products.add('Advanced Food Tester');
              });
            },
            child: Text('Add Product'),
          ),
          margin: EdgeInsets.all(10.0),
        ),
        Expanded(
          child:Products(_products)
        )
      ],
    );
    return column;
  }
}
