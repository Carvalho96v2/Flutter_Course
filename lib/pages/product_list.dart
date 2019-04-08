import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_edit.dart';
import '../models/product.dart';
import '../scoped_models/main.dart';

class ProductListPage extends StatelessWidget {
  final List<Product> products;
  final Function updateProduct, deleteProduct;

  ProductListPage(this.products, this.updateProduct, this.deleteProduct);

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {        
        model.selectProduct(index);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage();
            },
          ),
        );
      },
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      color: Colors.red,
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(child: SizedBox()),
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.delete_sweep,
                size: 40.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectProduct(index);
                  model.deleteProduct();
                }
              },
              key: Key(model.allProducts[index].title),
              background: _buildDismissibleBackground(),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                        model.allProducts[index].image,
                      ),
                    ),
                    title: Text(model.allProducts[index].title),
                    subtitle:
                        Text('\$${model.allProducts[index].price.toString()}'),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.allProducts.length,
        );
      },
    );
  }
}
