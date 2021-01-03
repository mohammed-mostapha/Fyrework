// import 'package:flutter/material.dart';

// class BuyerGigs extends StatefulWidget {
//   @override
//   _BuyerGigsState createState() => _BuyerGigsState();
// }

// class _BuyerGigsState extends State<BuyerGigs>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Container(
//       child: ListView.builder(
//         itemCount: 200,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Card(
//               color: index % 2 == 0 ? Colors.teal : null,
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     '#Hashtag ${index + 1}',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: index % 2 == 0 ? Colors.white : null,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                       'lorem ipsum lorem ipsum lorem ipsumlorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum',
//                       style: TextStyle(fontSize: 20)),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

///////////////////////////////////////////////////////////////////
///
///

// Future fetchPopularHashtags() async {
//   popularHashtags = await DatabaseService().fetchPopularHashtags();
//   print('popularHashtags: $popularHashtags');
// }

import 'package:flutter/material.dart';
import 'package:myApp/services/database.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _result;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await CustomDelegate().fetchPopularHashtags();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search")),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(_result ?? "", style: TextStyle(fontSize: 18)),
            RaisedButton(
              onPressed: () async {
                // await CustomDelegate().fetchPopularHashtags();

                var result = await showSearch<String>(
                  context: context,
                  delegate: CustomDelegate(),
                );
                setState(() {
                  _result = result;
                });
              },
              child: Text("Search"),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDelegate<T> extends SearchDelegate<T> {
  List<dynamic> popularHashtags = List();

  // Future fetchPopularHashtags() async {
  //   popularHashtags = await DatabaseService().fetchPopularHashtags();
  //   print('popularHashtags: $popularHashtags');
  // }

  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: Icon(Icons.chevron_left), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    var listToShow;
    if (query.isNotEmpty)
      listToShow = popularHashtags
          .where((e) => e.contains(query) && e.startsWith(query))
          .toList();
    else
      listToShow = popularHashtags;

    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var hashtag = listToShow[i];
        return ListTile(
          title: Text(hashtag),
          onTap: () => close(context, hashtag),
        );
      },
    );
  }
}
