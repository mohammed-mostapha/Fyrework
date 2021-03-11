import 'package:Fyrework/ui/views/sign_up_view.dart';

class MyUser {
  static String uid;
  static List favoriteHashtags;
  static String name;
  static String username;
  static String email;
  static String password;
  static String userAvatarUrl;
  static String userLocation;
  static bool isMinor;
  static String location;
  static String phoneNumber;
  static dynamic ongoingGigsByGigId;
  static int lengthOfOngoingGigsByGigId;

  MyUser();
  MyUser.fromData(Map<String, dynamic> data)

  // uid = data['uid'],
  {
    print('fromData before');
    uid = data['id'];
    favoriteHashtags = data['favoriteHashtags'];
    name = data['name'];
    username = data['username'];
    email = data['email'];
    password = data['password'];
    userAvatarUrl = data['userAvatarUrl'];
    userLocation = data['userLocation'];
    isMinor = data['isMinor'];
    location = data['location'];
    phoneNumber = data['phoneNumber'];
    ongoingGigsByGigId = data['ongoingGigsByGigId'];
    lengthOfOngoingGigsByGigId = data['lengthOfOngoingGigsByGigId'];
    print('fromData uid: $uid');
  }

  MyUser.clearData() {
    uid = null;
    favoriteHashtags = null;
    name = null;
    username = null;
    email = null;
    password = null;
    userAvatarUrl = null;
    userLocation = null;
    isMinor = null;
    location = null;
    phoneNumber = null;
    ongoingGigsByGigId = null;
    lengthOfOngoingGigsByGigId = null;
  }

  bool checkUserDataNullability() {
    print('checking user data');
    return [
      uid,
      favoriteHashtags,
      name,
      username,
      email,
      password,
      userAvatarUrl,
      userLocation,
      location,
    ].contains(null);
  }
}
