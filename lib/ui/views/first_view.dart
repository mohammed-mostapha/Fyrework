import 'package:flutter/material.dart';
import 'package:Fyrework/ui/widgets/custom_dialog.dart';

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        color: Colors.black,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: _height * 0.10,
              ),
              Text(
                'Welcome',
                style: TextStyle(fontSize: 44, color: Colors.white),
              ),
              SizedBox(
                height: _height * 0.10,
              ),
              Text('The Community waits you...',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40, color: Colors.white)),
              SizedBox(
                height: _height * 0.15,
              ),
              RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                  child: Text(
                    'Get Starred',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                            title: "Would you like to create a free account?",
                            description:
                                "With an account, your data will be securely saved, allowing you to access it from multiple devices. ",
                            primaryButtonText: "Create My Account",
                            primaryButtonRoute: "/signUp",
                            secondaryButtonText: "Maybe later",
                            secondaryButtonRoute: "/anonymousSignIn",
                          ));
                },
              ),
              SizedBox(height: _height * 0.05),
              FlatButton(
                child: Text(
                  "Sign in",
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/signIn');
                },
              )
            ],
          ),
        )),
      ),
    );
  }
}
