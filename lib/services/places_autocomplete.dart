import 'package:flutter/material.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/ui/shared/fyreworkLightTheme.dart';
import 'package:uuid/uuid.dart';
import 'address_search.dart';
import 'place_service.dart';
import '../ui/shared/constants.dart';

class PlacesAutocomplete extends StatefulWidget {
  PlacesAutocomplete({Key key, this.title, this.signUpDecoraiton})
      : super(key: key);

  final String title;
  bool signUpDecoraiton;
  static TextEditingController placesAutoCompleteController =
      TextEditingController(
          text: MyUser.location == null ? null : MyUser.location);
  @override
  _PlacesAutocompleteState createState() => _PlacesAutocompleteState();
}

class _PlacesAutocompleteState extends State<PlacesAutocomplete> {
  @override
  void dispose() {
    // PlacesAutocomplete.placesAutoCompleteController.clear();
    // PlacesAutocomplete.placesAutoCompleteController.dispose();

    print(
        'placesAutoComplete after dispose: ${PlacesAutocomplete.placesAutoCompleteController}');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: TextFormField(
          decoration: widget.signUpDecoraiton
              ? signUpInputDecoration(context, 'Location')
              : profileEditingInputDecoration(context, 'Location'),
          style: TextStyle(
              color: widget.signUpDecoraiton
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
              fontSize: 14),
          controller: PlacesAutocomplete.placesAutoCompleteController,
          validator: (val) => val.isEmpty ? '' : null,
          onChanged: (val) {
            setState(() {
              // location = val;
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
              // locationController.text = result.description;
              PlacesAutocomplete.placesAutoCompleteController.text =
                  result.description;
              print(
                  'placesAutoCompleteController: ${PlacesAutocomplete.placesAutoCompleteController}');
            }
          },
        ),
      ),
    );
  }
}
