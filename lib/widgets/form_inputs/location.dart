import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/location_data.dart';
import '../../models/product.dart';

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, [this.product]);
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();
  Uri _staticMapUri;
  LocationData _locationData;

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    if (widget.product != null) {
      getStaticMap(widget.product.location.address);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  void getStaticMap(String address) async {
    if (address.isEmpty) {
      setState(() {
        _staticMapUri = null;
      });
      widget.setLocation(null);
      return;
    }

    if (widget.product == null) {
      final Uri uri = Uri.https(
          'maps.googleapis.com', '/maps/api/geocode/json', {
        'address': address,
        'key': 'AIzaSyDR8xsggmoJX5rfNfGrgFVoxs_qUYKMChU'
      });
      final http.Response response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      print(decodedResponse);
      final formattedAddress =
          decodedResponse['results'][0]['formatted_address'];
      final coords = decodedResponse['results'][0]['geometry']['location'];
      _locationData = LocationData(
          latitude: coords['lat'],
          longitude: coords['lng'],
          address: formattedAddress);
    } else {
      _locationData = widget.product.location;
    }

    final StaticMapProvider staticMapProvider =
        StaticMapProvider('AIzaSyA0qgFSB8eBUY2YU8klBfxLNt7JmoHXFb0');
    final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers([
      Marker('position', 'Position', _locationData.latitude,
          _locationData.longitude)
    ],
        center: Location(_locationData.latitude, _locationData.longitude),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);
    widget.setLocation(_locationData);
    setState(() {
      _addressInputController.text = _locationData.address;
      _staticMapUri = staticMapUri;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _addressInputController,
          focusNode: _addressInputFocusNode,
          decoration: InputDecoration(labelText: 'Address'),
          validator: (String value) {
            if (_locationData == null || value.isEmpty) {
              return 'No valid location found';
            }
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        _staticMapUri != null
            ? Image.network(_staticMapUri.toString())
            : Container(),
      ],
    );
  }
}
