import 'package:flutter/material.dart';

import '../ui_elements/logout_list_tile.dart';

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
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/admin');
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_basket),
              title: Text('Products Page'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/products');
              },
            ),
            Divider(),
            LogoutListTile(),
          ],
        ),
      );
  }

}