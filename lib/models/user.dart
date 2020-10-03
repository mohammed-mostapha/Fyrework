// class User {
//   final String uid;

//   User({this.uid});
// }

import 'dart:io';

import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/storage_repo.dart';

import '../locator.dart';

class UserData {
  final String uid;
  final String name;
  final String location;

  UserData({this.uid, this.name, this.location});
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
