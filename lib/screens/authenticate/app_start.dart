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
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      previewButtons();
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: darkModeOn
                ? AssetImage('assets/images/splash.png')
                : AssetImage('assets/images/splash_light.png'),
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
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).accentColor,
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            AppLocalizations.of(context).translate('Register'),
                            // 'Create account',
                            style: Theme.of(context).textTheme.bodyText1,
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
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).accentColor),
                      // width: MediaQuery.of(context).size.width * 0.80,
                      // height: 50,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            AppLocalizations.of(context).translate('Login'),
                            // 'Create account',
                            style: Theme.of(context).textTheme.bodyText1,
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
