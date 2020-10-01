import 'package:flutter/material.dart';
import 'package:myApp/ui/shared/theme.dart';

class AllAccounts extends StatefulWidget {
  @override
  _AllAccountsState createState() => _AllAccountsState();
}

class _AllAccountsState extends State<AllAccounts>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: ListView.builder(
        itemCount: 200,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color:
                  index % 2 == 0 ? Colors.teal : FyreworkrColors.fyreworkBlack,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.account_circle,
                        size: 30,
                        color: FyreworkrColors.white,
                      ),
                      Text(
                        'Account No. ${index + 1}',
                        style: TextStyle(
                            fontSize: 30, color: FyreworkrColors.white),
                      ),
                      Icon(
                        Icons.mail,
                        size: 30,
                        color: FyreworkrColors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
