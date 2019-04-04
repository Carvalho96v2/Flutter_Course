import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {

  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String _titleValue, _description = '';
  double _price = 0.0;

  Widget _buildTitleTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Product Title'),
      onChanged: (String value) {
        setState(() {
          _titleValue = value;
        });
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Product Description'),
      maxLines: 4,
      onChanged: (String description) {
        setState(() {
          _description = description;
        });
      },
    );
  }

  Widget _buildPriceTextField(){
    return TextField(
      decoration: InputDecoration(labelText: 'Product Price'),
      keyboardType: TextInputType.number,
      onChanged: (String price) {
        setState(() {
          _price = double.parse(price);
        });
      },
    );
  }

  Widget _buildSaveButton(){
    return RaisedButton(
      color: Theme.of(context).accentColor,
      textColor: Colors.white,
      child: Text('Save'),
      onPressed: () {

        final Map<String, dynamic> product = {
          'title' :_titleValue,
          'description':_description,
          'price':_price,
          'image': 'assets/food.jpg'
          };

        widget.addProduct(product);
        Navigator.pushReplacementNamed(context, '/products');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
        child: ListView(
      children: <Widget>[
        _buildTitleTextField(),
        _buildDescriptionTextField(),
        _buildPriceTextField(),
        SizedBox(height: 10.0,),
        _buildSaveButton()
      ],
    ));
  }
}
