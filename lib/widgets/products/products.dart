import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price.dart';
import '../ui_elements/title_default.dart';
import '../products/address.dart';
import '../../models/product.dart';
import '../../scoped_models/main.dart';

class Products extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductsState();
  }
}

class _ProductsState extends State<Products> {
  IconData _favourite_icon;
  Widget _buildProductList(List<Product> products) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );
    } else {
      productCards = Center(
        child: Text('No products found, please add some.'),
      );
    }
    return productCards;
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        _favourite_icon = model.displayedProducts[index].is_favourite
            ? Icons.favorite
            : Icons.favorite_border;

        return Card(
            child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TitleDefault(model.displayedProducts[index].title),
                    SizedBox(
                      width: 8.0,
                    ),
                    PriceTag(model.displayedProducts[index].price.toString()),
                  ],
                )),
            SizedBox(
              height: 10.0,
            ),
            FadeInImage(
              placeholder: AssetImage('assets/food.jpg'),
              height: 300.0,
              fit: BoxFit.cover,
              image: NetworkImage(model.displayedProducts[index].image),
            ),
            AddressTag('Union Square, San Fancisco'),
            Text(model.displayedProducts[index].userEmail),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.info),
                  color: Theme.of(context).accentColor,
                  onPressed: () => Navigator.pushNamed<bool>(
                        context,
                        '/product/' + model.displayedProducts[index].id,
                      ),
                ),
                IconButton(
                  icon: Icon(_favourite_icon),
                  color: Colors.red,
                  onPressed: () {
                    model.selectProduct(model.allProducts[index].id);
                    model.toggleFavourite();
                    _favourite_icon =
                        model.displayedProducts[index].is_favourite
                            ? Icons.favorite
                            : Icons.favorite_border;
                  },
                )
              ],
            )
          ],
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildProductList(model.displayedProducts);
      },
    );
  }
}
