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
                          // Navigator.of(context).pushNamed('/register');
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => CustomDialog(
                                    title:
                                        "Would you like to create a free account?",
                                    description:
                                        "With an account, your data will be securely saved, allowing you to access it from multiple devices. ",
                                    primaryButtonText: "Create My Account",
                                    primaryButtonRoute: "/signUp",
                                    secondaryButtonText: "Maybe later",
                                    secondaryButtonRoute: "/anonymousSignIn",
                                  ));
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
                            child: AutoSizeText(
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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  child: AutoSizeText(
                                    AppLocalizations.of(context)
                                        .translate('Login'),
                                    // 'Login',
                                    style: TextStyle(
                                      color: FyreworkrColors.fyreworkGrey,
                                      fontSize: 20,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/signIn');
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  child: AutoSizeText(
                                    AppLocalizations.of(context)
                                        .translate('Browse'),
                                    // 'Browse',
                                    style: TextStyle(
                                        color: FyreworkrColors.fyreworkGrey,
                                        fontSize: 20),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        "/anonymousSignIn");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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
