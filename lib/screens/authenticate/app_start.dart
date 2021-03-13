import 'package:flutter/material.dart';
import 'package:Fyrework/app_localizations.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  double _buttonsOpacity = 0;

  Future previewButtons() {
    return Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted)
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
        backgroundColor: Theme.of(context).primaryColor,
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
                // opacity: 1,
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
                        width: 70,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black,
                        ),
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
                        width: 70,
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

  @override
  void dispose() {
    super.dispose();
  }
}
