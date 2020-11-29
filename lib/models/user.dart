class UserData {
  final String uid;
  final String name;
  final String email;
  final String location;
  final int ongoingGigsByGigId;

  UserData(
      {this.uid,
      this.name,
      this.email,
      this.location,
      this.ongoingGigsByGigId});
}

/////////////////////////////////

class User {
  final String id;
  final String uid;
  String fullName;
  final String email;
  String avatarUrl;

  User({
    this.id,
    this.uid,
    this.fullName,
    this.email,
    this.avatarUrl,
  });

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        uid = data['uid'],
        fullName = data['fullName'],
        email = data['email'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
    };
  }
}
