import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// import '../screens/authenticate/register.dart';
import '../ui/views/sign_up_view.dart';
import 'address_search.dart';
import 'place_service.dart';
import '../ui/shared/constants.dart';

class PlacesAutocomplete extends StatefulWidget {
  PlacesAutocomplete({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PlacesAutocompleteState createState() => _PlacesAutocompleteState();
}

class _PlacesAutocompleteState extends State<PlacesAutocomplete> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: buildSignUpInputDecoration('Location'),
            controller: locationController,
            validator: (val) =>
                val.isEmpty ? 'Please specify your location' : null,
            onChanged: (val) {
              setState(() {
                location = val;
              });
            },
            onTap: () async {
              // generate a new token here
              final sessionToken = Uuid().v4();
              final Suggestion result = await showSearch(
                context: context,
                delegate: AddressSearch(sessionToken),
              );
              // This will change the text displayed in the TextField
              if (result != null) {
                locationController.text = result.description;
              }
            },
            // with some styling
            // decoration: InputDecoration(
            //   icon: Container(
            //     margin: EdgeInsets.only(left: 20),
            //     width: 10,
            //     height: 10,
            //     child: Icon(
            //       Icons.home,
            //       color: Colors.black,
            //     ),
            //   ),
            //   hintText: "Location",
            //   border: InputBorder.none,
            //   contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
            // ),
          ),
        ],
      ),
    );
  }
}
