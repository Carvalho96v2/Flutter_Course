import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';
import './side_drawer.dart';
import '../widgets/products/products.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  IconData filter_icon = Icons.sort;

  @override
  void initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Products Found'));
        if (model.displayedProducts.length >= 0 && !model.isLoading) {
          content = Products();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          child: content,
          onRefresh: model.fetchProducts,
        );
      },
    );
  }

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
                  filter_icon = model.showFavourites
                      ? Icons.favorite
                      : Icons.favorite_border;
                },
              )
            ],
          ),
          body: _buildProductsList(),
        );
      },
    );
  }
}
