import 'package:flutter/material.dart';
import './price.dart';
import '../ui_elements/title_default.dart';
import '../products/address.dart';


class Products extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products);

  @override
  State<StatefulWidget> createState() {
    return _ProductsState();
  }

}

class _ProductsState extends State<Products> {

  IconData _favourite_icon;  

  Widget _buildProductList() {
    Widget productCards;
    if (widget.products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: widget.products.length,
      );
    } else {
      productCards = Center(
        child: Text('No products found, please add some'),
      );
    }
    return productCards;
  }

  Widget _buildProductItem(BuildContext context, int index) {
    if(widget.products[index]['is_favourite'] == null){
      widget.products[index]['is_favourite'] = false;
    }
    _favourite_icon = widget.products[index]['is_favourite']? Icons.favorite : Icons.favorite_border; 
    
    return Card(
        child: Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TitleDefault(widget.products[index]['title']),
                SizedBox(
                  width: 8.0,
                ),
                PriceTag( widget.products[index]['price'].toString()),
              ],
            )),
        SizedBox(
          height: 10.0,
        ),
        Image.asset(widget.products[index]['image']),
        AddressTag('Union Square, San Fancisco'),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              color: Theme.of(context).accentColor,
              onPressed: () => Navigator.pushNamed<bool>(
                    context,
                    '/product/' + index.toString(),
                  ),
            ),
            IconButton(
              icon: Icon(_favourite_icon),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  widget.products[index]['is_favourite'] = !widget.products[index]['is_favourite'];
                  _favourite_icon = widget.products[index]['is_favourite']? Icons.favorite : Icons.favorite_border; 
                });
              },
            )
          ],
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList();
  }
}
