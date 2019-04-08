import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {
    "email": null,
    "password": null,
    "accept": false
  };

  Decoration _buildBackgroundImage() {
    return BoxDecoration(
      image: DecorationImage(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
        fit: BoxFit.cover,
        image: AssetImage('assets/background.jpg'),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter a valid email address.';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', fillColor: Colors.white, filled: true),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 8) {
          return 'Password needs to be at least 8 characters long.';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildAcceptTermsSwitch() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(color: Colors.white),
      child: SwitchListTile(
        title: Text(
          'Accept Terms',
          style: TextStyle(color: Colors.black),
        ),
        value: _formData['accept'],
        onChanged: (bool value) {
          setState(() {
            _formData['accept'] = value;
          });
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: Text('LOGIN'),
          onPressed: () => _submitForm(model.login),
        );
      },
    );
  }

  void _submitForm(Function login) {
    if (!_formkey.currentState.validate()) {
      return;
    }
    _formkey.currentState.save();
    login(_formData['email'], _formData['password']);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double targetWidth = MediaQuery.of(context).size.width > 768.0
        ? 500.0
        : MediaQuery.of(context).size.width * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        decoration: _buildBackgroundImage(),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(
                      height: 5.0,
                    ),
                    _buildPasswordTextField(),
                    _buildAcceptTermsSwitch(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
