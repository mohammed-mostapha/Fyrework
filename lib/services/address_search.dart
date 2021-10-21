import 'package:Fyrework/ui/shared/fyreworkDarkTheme.dart';
import 'package:flutter/material.dart';
import 'place_service.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final sessionToken;
  PlaceApiProvider apiClient;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        color: Colors.grey,
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      color: Colors.grey,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == ""
          ? null
          : apiClient.fetchSuggestions(
              query, Localizations.localeOf(context).languageCode),
      builder: (context, snapshot) => query == ''
          ? Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Enter your address',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      (snapshot.data[index] as Suggestion).description,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onTap: () {
                      close(context, snapshot.data[index] as Suggestion);
                      // locationController.text =
                      //     '${snapshot.data[index].description}';
                    },
                  ),
                  itemCount: snapshot.data.length,
                )
              : Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Loading...',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
    );
  }
}
