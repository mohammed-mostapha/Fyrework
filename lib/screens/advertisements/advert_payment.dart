import 'dart:typed_data';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/services/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AdvertPayment extends StatefulWidget {
  final Uint8List receivedAdvertScreenshot;
  final List receivedAdvertHashtags;
  AdvertPayment({
    @required this.receivedAdvertScreenshot,
    @required this.receivedAdvertHashtags,
  });
  @override
  _AdvertPaymentState createState() => _AdvertPaymentState();
}

class _AdvertPaymentState extends State<AdvertPayment> {
  @override
  void initState() {
    super.initState();
    StripeServices.init();
  }

  ScrollController _scrollController = ScrollController();
  String clientSideWarning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(0),
          child: Text(
            'Advert Payments',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        elevation: 0.0,
      ),
      body: Builder(
        builder: (context) => Container(
          child: Form(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    clientSideAlert(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: double.infinity,
                        child: Wrap(
                          children: widget.receivedAdvertHashtags
                              .map((e) => Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 0, 2.5, 2.5),
                                    child: Chip(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      label: Text(
                                        '$e',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .accentColor),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    widget.receivedAdvertScreenshot != null
                        ? Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 2,
                            child: Image.memory(
                              // File(widget.receivedAdvertScreenshot.path),
                              widget.receivedAdvertScreenshot,
                            ),
                          )
                        : Container(
                            child: Center(
                            child: Text(
                              'Try again',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )),
                    ElevatedButton(
                        onPressed: () async {
                          EasyLoading.show();
                          var response = await StripeServices.payWithCard(
                              amount: 500.toString(), currency: 'usd');
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text(response.message)));
                          for (var i = 0; i < widget.receivedAdvertHashtags.length; i++) {
                            await DatabaseService().fetchOrCreateGigsForAdverts(
                                widget.receivedAdvertHashtags[i]);
                          }
                          EasyLoading.dismiss();
                        },
                        child: Text('Stripe Pay \$5.00'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor))),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'You advert will go under the selected hashtags at the top',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget clientSideAlert() {
    if (clientSideWarning != null) {
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      return Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.error_outline,
                color: Theme.of(context).accentColor,
              ),
            ),
            Expanded(
              child: Text(
                clientSideWarning,
                maxLines: 3,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).accentColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).hintColor,
                ),
                onPressed: () {
                  setState(() {
                    clientSideWarning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
