import 'package:flutter/material.dart';
import 'package:myApp/services/authh.dart';
import 'package:myApp/ui/shared/constants.dart';
import 'package:myApp/ui/shared/loading.dart';
import 'package:myApp/ui/shared/loading.dart';
import 'package:myApp/ui/shared/theme.dart';

import '../../route_generator.dart';
import '../../ui/shared/theme.dart';

class SignIn extends StatefulWidget {
  // final Function toggleView;
  // SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : MaterialApp(
            onGenerateRoute: RouteGenerator.generateRoute,
            home: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: FyreworkrColors.fyreworkBlack,
                  elevation: 0.0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Text('Sign in to FyreWork'),
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        // widget.toggleView();
                        Navigator.of(context).popAndPushNamed('/register');
                      },
                    )
                  ],
                ),
                body: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration:
                                textInputDecoration.copyWith(hintText: 'Email'),
                            validator: (val) =>
                                val.isEmpty ? 'Enter you email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Password'),
                            obscureText: true,
                            validator: (val) => val.length < 6
                                ? 'Enter a password 6+ chars long'
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          RaisedButton(
                            color: FyreworkrColors.fyreworkBlack,
                            child: Text(
                              'Sign in',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email.trim(), password.trim());
                                if (result != null) {
                                  Navigator.of(context).popAndPushNamed('/');
                                }
                                if (result == null) {
                                  setState(() {
                                    error =
                                        'could not sigh in with those credentials';
                                    loading = false;
                                  });
                                }
                              }
                            },
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          )
                        ],
                      ),
                    ))),
          );
  }
}
