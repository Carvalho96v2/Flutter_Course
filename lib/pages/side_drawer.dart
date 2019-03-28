import 'package:flutter/material.dart';


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
                Navigator.pushReplacementNamed(context, '/admin');
              },
            ),
            ListTile(
              title: Text('Products Page'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/products');
              },
            ),
          ],
        ),
      );
  }

}