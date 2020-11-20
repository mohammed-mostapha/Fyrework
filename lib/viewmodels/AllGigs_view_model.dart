import 'package:myApp/constants/route_names.dart';
import 'package:myApp/locator.dart';
import 'package:myApp/models/gig.dart';
import 'package:myApp/services/dialog_service.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:myApp/services/navigation_service.dart';
import 'package:myApp/viewmodels/base_model.dart';

class AllGigsViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  List<Gig> _gigs;
  List<Gig> get gigs => _gigs;

  bool get busy => false;

  void listenToGigs() {
    setBusy(true);
    _firestoreService.listenToGigsRealTime().listen((gigsData) {
      List<Gig> updatedGigs = gigsData;
      if (updatedGigs != null && updatedGigs.length > 0) {
        _gigs = updatedGigs;
        notifyListeners();
      }

      setBusy(false);
    });
  }

  Future deleteGig(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the gig?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      setBusy(true);
      await _firestoreService.deleteGig(_gigs[index].gigId);
      setBusy(false);
    }
  }

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreateGigViewRoute);
  }

  void editGig(int index) {
    _navigationService.navigateTo(CreateGigViewRoute, arguments: _gigs[index]);
  }
}
