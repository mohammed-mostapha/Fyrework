// class UserData {
//   final String uid;
//   final String name;
//   final String email;
//   final String location;
//   final String avatarUrl;
//   final bool isMinor;
//   final dynamic ongoingGigsByGigId;
//   final int lengthOfOngoingGigsByGigId;

//   UserData(
//       {this.uid,
//       this.name,
//       this.email,
//       this.location,
//       this.avatarUrl,
//       this.isMinor,
//       this.ongoingGigsByGigId,
//       this.lengthOfOngoingGigsByGigId});
// }

/////////////////////////////////

class MyUser {
  static String uid;
  static String name;
  static String username;
  static String email;
  static String password;
  static String userAvatarUrl;
  static String userLocation;
  static bool isMinor;
  static String location;
  static dynamic ongoingGigsByGigId;
  static int lengthOfOngoingGigsByGigId;

  // User({
  //   this.uid,
  //   this.name,
  //   this.email,
  //   this.password,
  //   this.userAvatarUrl,
  //   this.userLocation,
  //   this.isMinor,
  //   this.lengthOfOngoingGigsByGigId,
  //   this.ongoingGigsByGigId,
  // });
  MyUser();
  MyUser.fromData(Map<String, dynamic> data)

  // uid = data['uid'],
  {
    uid = data['id'];
    name = data['name'];
    username = data['username'];
    email = data['email'];
    password = data['password'];
    userAvatarUrl = data['userAvatarUrl'];
    userLocation = data['userLocation'];
    isMinor = data['isMinor'];
    location = data['location'];
    ongoingGigsByGigId = data['ongoingGigsByGigId'];
    lengthOfOngoingGigsByGigId = data['lengthOfOngoingGigsByGigId'];
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'uid': uid,
  //     'name': name,
  //     'email': email,
  //     'password': password,
  //     'userAvatarUrl': userAvatarUrl,
  //     'userLocation': userLocation,
  //     'isMinor': isMinor,
  // 'location': location,
  //     'ongoingGigsByGigId': ongoingGigsByGigId,
  //     'lengthOfOngoingGigsByGigId': lengthOfOngoingGigsByGigId,
  //   };
  // }
}
