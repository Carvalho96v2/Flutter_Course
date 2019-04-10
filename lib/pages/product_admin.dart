import 'package:flutter/material.dart';

import '../widgets/misc/side_drawer.dart';
import './product_edit.dart';
import './product_list.dart';
import '../scoped_models/main.dart';


class ProductAdminPage extends StatelessWidget {
  final MainModel model;
  ProductAdminPage(this.model);

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
              ProductEditPage(),
              ProductListPage(model)
            ],
          ),
        ),
      ),
    );
  }
}
