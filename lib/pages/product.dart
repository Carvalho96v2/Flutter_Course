import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';
import '../widgets/ui_elements/title_default.dart';
import '../widgets/products/price.dart';

class ProductPage extends StatelessWidget {
  final int index;

  ProductPage(this.index);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
            appBar: AppBar(
              title: Text(model.products[index].title),
            ),
            body: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TitleDefault(model.products[index].title),
                  ),
                  Image.asset(model.products[index].image),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(model.products[index].description),
                  ),
                  PriceTag(model.products[index].price.toString())
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
