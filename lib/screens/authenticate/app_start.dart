import 'package:flutter/material.dart';
import 'package:myApp/app_localizations.dart';
import 'package:myApp/ui/shared/theme.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  double _buttonsOpacity = 0;

  Future previewButtons() {
    return Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        _buttonsOpacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      previewButtons();
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: FyreworkrColors.fyreworkBlack,
        // body: ListView(
        //   children: [
        //     Container(
        //       padding: EdgeInsets.all(20),
        //       height: MediaQuery.of(context).size.height,
        //       child: Padding(
        //         padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             Container(
        //               width: MediaQuery.of(context).size.width / 2,
        //               height: 50,
        //               child: Image(
        //                 image: AssetImage('assets/images/fyrework_logo.png'),
        //               ),
        //             ),
        //             Container(
        //               child: Column(
        //                 children: [
        //                   RaisedButton(
        //                     padding: EdgeInsets.all(0),
        //                     color: FyreworkrColors.fyreworkBlack,
        //                     onPressed: () {
        //                       Navigator.of(context).pushNamed("/signUp");
        //                     },
        //                     child: Container(
        //                       height: 30,
        //                       decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(5),
        //                         color: FyreworkrColors.fyreworkBlack,
        //                         boxShadow: [
        //                           BoxShadow(
        //                               color: Colors.black, spreadRadius: 8),
        //                         ],
        //                       ),
        //                       // width: MediaQuery.of(context).size.width * 0.80,
        //                       // height: 50,
        //                       child: Center(
        //                         child: FittedBox(
        //                           fit: BoxFit.contain,
        //                           child: Text(
        //                             AppLocalizations.of(context)
        //                                 .translate('Register'),
        //                             // 'Create account',
        //                             style: TextStyle(
        //                               color: Colors.white,
        //                               fontSize: 20,
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                   SizedBox(
        //                     height: 20,
        //                   ),
        //                   Row(
        //                     children: [
        //                       Container(
        //                         child: FittedBox(
        //                           fit: BoxFit.contain,
        //                           child: Text(
        //                             AppLocalizations.of(context)
        //                                 .translate('Have an account? '),
        //                             // 'Create account',
        //                             style: TextStyle(
        //                               fontSize: 18,
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                       Container(
        //                           child: GestureDetector(
        //                         onTap: () {
        //                           Navigator.of(context).pushNamed("/signIn");
        //                         },
        //                         child: FittedBox(
        //                           fit: BoxFit.scaleDown,
        //                           child: Text(
        //                             AppLocalizations.of(context)
        //                                 .translate('Login'),
        //                             style: TextStyle(fontSize: 18),
        //                           ),
        //                         ),
        //                       )),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             FittedBox(
        //               fit: BoxFit.contain,
        //               child: Text(
        //                 AppLocalizations.of(context)
        //                     .translate('GIGS BY HUMANS FOR HUMANS'),
        //                 style: TextStyle(fontSize: 18),
        //                 maxLines: 1,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.png'),
            ),
          ),
          child: Align(
            alignment: Alignment(0, 0.5),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: AnimatedOpacity(
                opacity: _buttonsOpacity,
                duration: const Duration(milliseconds: 1500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/signUp");
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black,
                        ),
                        // width: MediaQuery.of(context).size.width * 0.80,
                        // height: 50,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('Register'),
                              // 'Create account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/signIn");
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black,
                        ),
                        // width: MediaQuery.of(context).size.width * 0.80,
                        // height: 50,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              AppLocalizations.of(context).translate('Login'),
                              // 'Create account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
