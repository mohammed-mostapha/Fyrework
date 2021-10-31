class MyUser {
  static String uid;
  static List favoriteHashtags;
  static String name;
  static String username;
  static String email;
  static String password;
  static String userAvatarUrl;
  static bool isMinor;
  static String location;
  static String phoneNumber;
  static dynamic openGigsByGigId;
  static dynamic completedGigsByGigId;

  MyUser();
  MyUser.fromData(Map<String, dynamic> data) {
    uid = data['id'];
    favoriteHashtags = data['favoriteHashtags'];
    name = data['name'];
    username = data['username'];
    email = data['email'];
    userAvatarUrl = data['userAvatarUrl'];
    // userLocation = data['userLocation'];
    isMinor = data['isMinor'];
    location = data['location'];
    phoneNumber = data['phoneNumber'];
    openGigsByGigId = data['openGigsByGigId'];
    completedGigsByGigId = data['completedGigsByGigId'];
  }

  MyUser.clearData() {
    uid = null;
    favoriteHashtags = null;
    name = null;
    username = null;
    email = null;
    userAvatarUrl = null;
    // userLocation = null;
    isMinor = null;
    location = null;
    phoneNumber = null;
    openGigsByGigId = null;
    completedGigsByGigId = null;
  }

  bool checkUserDataNullability() {
    print('see this: checking user data');
    print('critical: uid: ${MyUser.uid}');
    print('critical: favoriteHashtags: ${MyUser.favoriteHashtags}');
    print('critical: name: ${MyUser.name}');
    print('critical: username: ${MyUser.username}');
    print('critical: userAvatarUrl: ${MyUser.userAvatarUrl}');
    print('critical: location: ${MyUser.location}');
    return [
      uid,
      favoriteHashtags,
      name,
      username,
      email,
      userAvatarUrl,
      // userLocation,
      location,
    ].contains(null);
  }
}
