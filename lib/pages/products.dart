import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';
import './side_drawer.dart';
import '../widgets/products/products.dart';

class ProductsPage extends StatelessWidget {
  IconData filter_icon = Icons.sort;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          drawer: SideDrawer(),
          appBar: AppBar(
            title: Text('EasyList'),
            actions: <Widget>[
              IconButton(
                icon: Icon(filter_icon),
                onPressed: () {
                  model.toggleDisplayMode();
                  filter_icon = model.showFavourites? Icons.favorite : Icons.favorite_border;
                },
              )
            ],
          ),
          body: Products(),
        );
      },
    );
  }
}
