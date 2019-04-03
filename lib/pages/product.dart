import 'package:flutter/material.dart';
import 'dart:async';

class ProductPage extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductPage(this.product);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(product['title']),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(product['title']),
              ),
              Image.asset(product['image']),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(product['description'])),
            ],
          ),
        ),
      ),
    );
  }
}
