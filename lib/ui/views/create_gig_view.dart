// import 'package:myApp/models/gig.dart';
// import 'package:myApp/ui/shared/ui_helpers.dart';
// import 'package:myApp/ui/widgets/input_field.dart';
// import 'package:myApp/viewmodels/create_gig_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider_architecture/provider_architecture.dart';

// class CreateGigView extends StatelessWidget {
//   final gigHashtagsController = TextEditingController();
//   final Gig edittingGig;

//   CreateGigView({Key key, this.edittingGig, Gig edittinGig}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelProvider<CreateGigViewModel>.withConsumer(
//       viewModel: CreateGigViewModel(),
//       onModelReady: (model) {
//         // update the text in the controller
//         gigHashtagsController.text = edittingGig?.gigHashtags ?? '';

//         model.setEdittingGig(edittingGig);
//       },
//       builder: (context, model, child) => Scaffold(
//           floatingActionButton: FloatingActionButton(
//             child: !model.busy
//                 ? Icon(Icons.add)
//                 : CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation(Colors.white),
//                   ),
//             onPressed: () {
//               if (!model.busy) {
//                 model.addGig(gigHashtags: gigHashtagsController.text);
//               }
//             },
//             backgroundColor:
//                 !model.busy ? Theme.of(context).primaryColor : Colors.grey[600],
//           ),
//           body: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   verticalSpace(40),
//                   Text(
//                     'Create Post',
//                     style: TextStyle(fontSize: 26),
//                   ),
//                   verticalSpaceMedium,
//                   InputField(
//                     placeholder: 'Title',
//                     controller: gigHashtagsController,
//                   ),
//                   verticalSpaceMedium,
//                   Text('Post Image'),
//                   verticalSpaceSmall,
//                   Container(
//                     height: 250,
//                     decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(10)),
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Tap to add post image',
//                       style: TextStyle(color: Colors.grey[400]),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }
