import 'package:flutter/material.dart';

class ProviderGigs extends StatefulWidget {
  @override
  _ProviderGigsState createState() => _ProviderGigsState();
}

class _ProviderGigsState extends State<ProviderGigs>
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
              color: index % 2 == 0 ? Colors.teal : null,
              child: Column(
                children: <Widget>[
                  Text(
                    '#Hashtag ${index + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: index % 2 == 0 ? Colors.white : null,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      'lorem ipsum lorem ipsum lorem ipsumlorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum',
                      style: TextStyle(fontSize: 20)),
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
