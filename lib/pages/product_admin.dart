import 'package:flutter/material.dart';

import './side_drawer.dart';
import './product_edit.dart';
import './product_list.dart';
import '../models/product.dart';


class ProductAdminPage extends StatelessWidget {
  final Function addProduct, deleteProduct, updateProduct;
  final List<Product> products;

  ProductAdminPage(this.addProduct, this.updateProduct, this.deleteProduct, this.products);

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text('Manage Products'),
      bottom: TabBar(
        tabs: <Widget>[
          Tab(
            icon: Icon(Icons.create),
            text: 'Create Product',
          ),
          Tab(
            icon: Icon(Icons.list),
            text: 'Manage Product',
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: SideDrawer(),
          appBar: _buildAppBar(),
          body: TabBarView(
            children: <Widget>[
              ProductEditPage(addProduct: addProduct),
              ProductListPage(products, updateProduct, deleteProduct)
            ],
          ),
        ),
      ),
    );
  }
}
