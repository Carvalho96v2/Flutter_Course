import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget {

  final String address;

  AddressTag(this.address);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(7.0)),
      padding: EdgeInsets.all(3.0),
      child: Text(address),
    );
  }
}
