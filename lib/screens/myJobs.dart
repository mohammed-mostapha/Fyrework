import 'package:flutter/material.dart';
import 'package:myApp/ui/shared/theme.dart';

class MyJobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'My Activity',
            style:
                TextStyle(color: FyreworkrColors.fyreworkBlack, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: FyreworkrColors.white,
      ),
      body: Container(
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
      ),
    );
  }
}
