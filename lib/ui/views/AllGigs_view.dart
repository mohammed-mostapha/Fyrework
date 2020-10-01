import 'package:myApp/models/gig.dart';
import 'package:myApp/ui/widgets/gig_item.dart';
import 'package:myApp/viewmodels/AllGigs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class AllGigsView extends StatelessWidget {
  const AllGigsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AllGigsViewModel>.withConsumer(
        viewModelBuilder: () {
          return AllGigsViewModel();
        },
        onModelReady: (model) => model.listenToGigs(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              // floatingActionButton: FloatingActionButton(
              //   backgroundColor: Theme.of(context).primaryColor,
              //   child:
              //       !model.busy ? Icon(Icons.add) : CircularProgressIndicator(),
              //   onPressed: model.navigateToCreateView,
              // ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: model.gigs != null
                            ? ListView.builder(
                                itemCount: model.gigs.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () => model.editGig(index),
                                  child: GigItem(
                                    gigHashtags: model.gigs[index],
                                    gigPost: model.gigs[index],
                                    gigDeadline: model.gigs[index],
                                    gigCurrency: model.gigs[index],
                                    gigBudget: model.gigs[index],
                                    gigValue: model.gigs[index],
                                    adultContentText: model.gigs[index],
                                    adultContentBool: model.gigs[index],
                                    onDeleteItem: () => model.deleteGig(index),
                                  ),
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black),
                                ),
                              ))
                  ],
                ),
              ),
            ));
  }
}
