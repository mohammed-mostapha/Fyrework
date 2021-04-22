import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WorkerActions extends StatefulWidget {
  @required
  final String passedGigId;

  WorkerActions({this.passedGigId});

  @override
  _WorkerActionsState createState() => _WorkerActionsState();
}

class _WorkerActionsState extends State<WorkerActions> {
  final String done = 'assets/svgs/flaticon/done.svg';

  final String requestPayment = 'assets/svgs/flaticon/request_payment.svg';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          DatabaseService().showGigWorkstreamActions(gigId: widget.passedGigId),
      builder: (BuildContext context, AsyncSnapshot gigActionSnapshot) {
        if (!gigActionSnapshot.hasData) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        } else if (gigActionSnapshot.hasData &&
            !(gigActionSnapshot.data.docs.length > 0)) {
          return Container(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Actions',
                      style: Theme.of(context).textTheme.headline1,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Wrap(
                  // alignment: WrapAlignment.spaceEvenly,
                  spacing: 20,
                  runSpacing: 20,
                  runAlignment: WrapAlignment.center,
                  children: [
                    GestureDetector(
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(
                                  done,
                                  semanticsLabel: 'done',
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Mark As Done',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyText1)
                            ],
                          ),
                        ),
                        onTap: () {
                          DatabaseService().addGigWorkstreamActions(
                            gigId: widget.passedGigId,
                            action: 'marked as done',
                            userAvatarUrl: MyUser.userAvatarUrl,
                            gigActionOwner: "worker",
                          );
                        }),
                    GestureDetector(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(
                                requestPayment,
                                semanticsLabel: 'request_payment',
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Request Payment',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        DatabaseService().addGigWorkstreamActions(
                          gigId: widget.passedGigId,
                          action: 'request payment',
                          userAvatarUrl: MyUser.userAvatarUrl,
                          gigActionOwner: "worker",
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          String lastGigActionOwner =
              gigActionSnapshot.data.docs.last['gigActionOwner'];
          bool workerAction = (lastGigActionOwner == 'worker') ? true : false;
          List gigActionsList = List.from(gigActionSnapshot.data.docs);
          bool markedAsCompleted = gigActionsList.any(
            (element) => element["gigAction"] == "marked as completed",
          );
          bool wokerGotPaid = gigActionsList.any(
            (element) => element["gigAction"] == "worker got paid",
          );

          return Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Actions',
                      style: Theme.of(context).textTheme.headline1,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  runAlignment: WrapAlignment.center,
                  children: [
                    GestureDetector(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(
                                done,
                                semanticsLabel: 'done',
                                color: markedAsCompleted
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5)
                                    : !workerAction
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Mark As Done',
                                textAlign: TextAlign.center,
                                style: markedAsCompleted
                                    ? Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity((0.5)))
                                    : !workerAction
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )
                                        : Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity((0.5))))
                          ],
                        ),
                      ),
                      onTap: !workerAction
                          ? () {
                              DatabaseService().addGigWorkstreamActions(
                                gigId: widget.passedGigId,
                                action: 'mark as done',
                                userAvatarUrl: MyUser.userAvatarUrl,
                                gigActionOwner: "worker",
                              );
                            }
                          : null,
                    ),
                    GestureDetector(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(requestPayment,
                                    semanticsLabel: 'request_payment',
                                    color: !workerAction
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context)
                                            .primaryColor
                                            .withOpacity((0.5)))),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Request Payment',
                                textAlign: TextAlign.center,
                                style: !workerAction
                                    ? Theme.of(context).textTheme.bodyText1
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity((0.5)))),
                          ],
                        ),
                      ),
                      onTap: !workerAction
                          ? () {
                              DatabaseService().addGigWorkstreamActions(
                                gigId: widget.passedGigId,
                                action: 'requested payment',
                                userAvatarUrl: MyUser.userAvatarUrl,
                                gigActionOwner: "worker",
                              );
                            }
                          : null,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    (!workerAction)
                        ? Container(
                            width: 0,
                            height: 0,
                          )
                        : Text(
                            'Waiting for client action...',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                  ],
                )
              ],
            ),
          );
        }
      },
    );
  }
}
