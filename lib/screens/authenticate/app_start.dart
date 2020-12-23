import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myApp/app_localizations.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/ui/widgets/custom_dialog.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(50),
                  width: MediaQuery.of(context).size.width,
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.50
                          : MediaQuery.of(context).size.height * 0.40,
                  child: Image(
                    image: AssetImage('assets/images/fyrework_logo.png'),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        padding: EdgeInsets.all(0),
                        color: FyreworkrColors.fyreworkBlack,
                        onPressed: () {
                          Navigator.of(context).pushNamed("/signUp");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: FyreworkrColors.fyreworkBlack,
                            boxShadow: [
                              BoxShadow(color: Colors.black, spreadRadius: 3),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: 50,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('Create account'),
                                // 'Create account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(0),
                        color: FyreworkrColors.fyreworkBlack,
                        onPressed: () {
                          Navigator.of(context).pushNamed("/signIn");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: FyreworkrColors.fyreworkBlack,
                            boxShadow: [
                              BoxShadow(color: Colors.black, spreadRadius: 3),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: 50,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                AppLocalizations.of(context).translate('Login'),
                                // 'Create account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
