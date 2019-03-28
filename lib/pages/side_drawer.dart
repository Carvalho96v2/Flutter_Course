import 'package:flutter/material.dart';

import './product_admin.dart';
import './products.dart';


class SideDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).accentColor,
              title: Text('Choose'),
            ),
            ListTile(
              title: Text('Manage Products'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductAdminPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Products Page'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      );
  }

}