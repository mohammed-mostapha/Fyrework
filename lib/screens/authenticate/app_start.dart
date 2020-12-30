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
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    child: Image(
                      image: AssetImage('assets/images/fyrework_logo.png'),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'GIGS BY HUMANS FOR HUMANS',
                      style: TextStyle(fontSize: 400),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                    padding: EdgeInsets.all(0),
                    color: FyreworkrColors.fyreworkBlack,
                    onPressed: () {
                      Navigator.of(context).pushNamed("/signUp");
                    },
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: FyreworkrColors.fyreworkBlack,
                        boxShadow: [
                          BoxShadow(color: Colors.black, spreadRadius: 8),
                        ],
                      ),
                      // width: MediaQuery.of(context).size.width * 0.80,
                      // height: 50,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: Row(
                      children: [
                        Container(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('Have an account already? '),
                              // 'Create account',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("/signIn");
                          },
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              AppLocalizations.of(context).translate('Login'),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
