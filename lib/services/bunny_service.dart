import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../credentials.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class BunnyService {
  var uuid = Uuid();
  // uploading gig media files
  Future<String> uploadMediaFileToBunny({
    @required File fileToUpload,
    @required String storageZonePath,
  }) async {
    String storageZoneName = 'fyrework';
    String fileName = (fileToUpload.path.split('/').last) +
        DateTime.now().millisecondsSinceEpoch.toString();
    try {
      var uri = Uri.parse(
        'https://storage.bunnycdn.com/$storageZoneName/$storageZonePath/$fileName',
      );

      var headers = {
        'AccessKey': BunnyStorage_ACESS_KEY,
        'Content-Type': 'application/octet-stream',
      };

      var data = await File(fileToUpload.path).readAsBytes();

      var res = await http.put(
        uri,
        headers: headers,
        body: data,
      );

      if (res.statusCode != 201) {
        throw Exception('http.put error: statusCode= ${res.statusCode}');
      }

      String downloadUrl =
          'https://$storageZoneName.b-cdn.net/$storageZonePath/$fileName';

      return downloadUrl;
    } catch (e) {
      print(e);
    }
  }

  // uploading profile picture

  Future<String> uploadAvatarToBunny({
    @required File fileToUpload,
    @required String userId,
    @required String storageZonePath,
  }) async {
    String uniuqId = uuid.v1();
    String storageZoneName = 'fyrework';
    try {
      var uri = Uri.parse(
        'https://storage.bunnycdn.com/$storageZoneName/$storageZonePath/$userId/$uniuqId',
      );

      var headers = {
        'AccessKey': BunnyStorage_ACESS_KEY,
        'Content-Type': 'application/octet-stream',
      };

      var data = await File(fileToUpload.path).readAsBytes();

      var res = await http.put(
        uri,
        headers: headers,
        body: data,
      );

      if (res.statusCode != 201) {
        throw Exception('http.put error: statusCode= ${res.statusCode}');
      }

      String downloadUrl =
          'https://$storageZoneName.b-cdn.net/$storageZonePath/$userId/$uniuqId';

      return downloadUrl;
    } catch (e) {
      print(e);
    }
  }

  // deleting profile picture

  Future<String> deleteAvatarFromBunny({
    @required String userAvatarUrl,
  }) async {
    String storageZoneName = 'fyrework';
    try {
      var headers = {
        'AccessKey': BunnyStorage_ACESS_KEY,
        'Content-Type': 'application/octet-stream',
      };

      var res = await http.delete(
        userAvatarUrl,
        headers: headers,
      );

      if (res.statusCode != 201) {
        throw Exception('http.put error: statusCode= ${res.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
