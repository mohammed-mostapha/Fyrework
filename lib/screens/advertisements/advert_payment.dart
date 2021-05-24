import 'dart:typed_data';

import 'package:flutter/material.dart';

class AdvertPayment extends StatefulWidget {
  final Uint8List receivedAdvertScreenshot;
  List receivedAdvertHashtags;
  AdvertPayment({
    @required this.receivedAdvertScreenshot,
    @required this.receivedAdvertHashtags,
  });
  @override
  _AdvertPaymentState createState() => _AdvertPaymentState();
}

class _AdvertPaymentState extends State<AdvertPayment> {
  ScrollController _scrollController = ScrollController();
  // List _advertHashtags = List();
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
      body: Container(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 2.5, 2.5),
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
                                      onDeleted: () {
                                        setState(() {
                                          widget.receivedAdvertHashtags
                                              .removeWhere((item) => item == e);
                                        });
                                      },
                                      deleteIconColor:
                                          Theme.of(context).accentColor),
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
                        ))
                ],
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
