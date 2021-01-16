class OtherUser {
  final String uid;
  final String hashtag;
  final String name;
  final String username;
  final String email;
  final String userAvatarUrl;
  final String userLocation;
  final bool isMinor;
  final String location;
  final String phoneNumber;
  final dynamic ongoingGigsByGigId;
  final int lengthOfOngoingGigsByGigId;

  OtherUser({
    this.uid,
    this.hashtag,
    this.name,
    this.username,
    this.email,
    this.userAvatarUrl,
    this.userLocation,
    this.isMinor,
    this.location,
    this.phoneNumber,
    this.ongoingGigsByGigId,
    this.lengthOfOngoingGigsByGigId,
  });

  // OtherUser.fromData(Map<String, dynamic> data)
  //     : uid = data['id'],
  //       name = data['name'],
  //       email = data['email'],
  //       userAvatarUrl = data['userAvatarUrl'],
  //       userLocation = data['userLocation'],
  //       isMinor = data['isMinor'],
  //       ongoingGigsByGigId = data['ongoingGigsByGigId'],
  //       lengthOfOngoingGigsByGigId = data['lengthOfOngoingGigsByGigId'];

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'fullName': fullName,
  //     'email': email,
  //   };
  // }
}
