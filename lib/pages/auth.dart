import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String email = '';
  String password = '';
  bool _acceptTerms = true;

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
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (String _email) {
        setState(() {
          email = _email;
        });
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Password', fillColor: Colors.white, filled: true),
      obscureText: true,
      onChanged: (String _password) {
        setState(() {
          password = _password;
        });
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
        value: _acceptTerms,
        onChanged: (bool value) {
          setState(() {
            _acceptTerms = value;
          });
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      child: Text('LOGIN'),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/products');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double targetWidth = MediaQuery.of(context).size.width > 768.0? 500.0 : MediaQuery.of(context).size.width * 0.95;
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
              width:  targetWidth,
              child: Column(children: <Widget>[
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
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
