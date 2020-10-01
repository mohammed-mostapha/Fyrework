import 'package:flutter/material.dart';
import 'package:myApp/screens/home/home.dart';
import 'package:myApp/screens/wrapper.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../models/Gig_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../ui/shared/theme.dart';

import '../add_gig/addGigDetails.dart';

class AllGigs extends StatefulWidget {
  @override
  _AllGigsState createState() => _AllGigsState();
}

class _AllGigsState extends State<AllGigs> with AutomaticKeepAliveClientMixin {
  String id;
  final db = Firestore.instance;

  void updateData(DocumentSnapshot doc) async {
    await db
        .collection('Gigs')
        .document(doc.documentID)
        .updateData({'job description': 'new job description'});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('Gigs').document(doc.documentID).delete();
    setState(() => id = null);
  }

  Card gigItem(DocumentSnapshot doc) {
    return Card(
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    '${doc.data['Gig_hashtags']}',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    '${doc.data['Gig_post']}',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
//
//
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => updateData(doc),
                  child: Text('Update Gig post',
                      style: TextStyle(color: FyreworkrColors.white)),
                  color: FyreworkrColors.fyreworkBlack,
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteData(doc),
                  child: Text('Delete',
                      style: TextStyle(color: FyreworkrColors.white)),
                  color: FyreworkrColors.fyreworkBlack,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: db.collection('Gigs').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.documents
                      .map((doc) => gigItem(doc))
                      .toList(),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
