import '../credentials.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class BunnyService {
  Future<String> uploadFileToBunny({
    File fileToUpload,
    String storageZonePath,
  }) async {
    String storageZoneName = 'fyrework';
    String path = storageZonePath;
    String fileName = (fileToUpload.path.split('/').last) +
        DateTime.now().millisecondsSinceEpoch.toString();
    try {
      var uri = Uri.parse(
        'https://storage.bunnycdn.com/$storageZoneName/$path/$fileName',
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

      String downloadUrl = 'https://$storageZoneName.b-cdn.net/$path/$fileName';

      return downloadUrl;
    } catch (e) {
      print(e);
    }
  }
}
