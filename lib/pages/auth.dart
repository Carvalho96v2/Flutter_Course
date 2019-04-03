import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';
    bool _acceptTerms = true;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.dstATop),
            fit: BoxFit.cover,
            image: AssetImage('assets/background.jpg'),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              TextField(
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
              ),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Password',
                    fillColor: Colors.white,
                    filled: true),
                obscureText: true,
                onChanged: (String _password) {
                  setState(() {
                    password = _password;
                  });
                },
              ),
              Container(
                margin: EdgeInsets.only(top:5.0),
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
              ),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text('LOGIN'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/products');
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
