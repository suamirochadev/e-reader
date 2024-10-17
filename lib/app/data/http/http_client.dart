import 'dart:io';

import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future get({required String url});
}

class HttpClient implements IHttpClient {
  final client = http.Client();
  @override
  Future get({required String url}) async{
    return await client.get(Uri.parse(url));
  }

  downloadFile({required String url, required String destination, required bool deleteOnError, required Null Function(dynamic receivedBytes, dynamic totalBytes) onReceiveProgress}) {
    return client.get(Uri.parse(url)).then((response) {
      return response.bodyBytes;
    }).then((bytes) {
      return File(destination).writeAsBytes(bytes);
    });
  }
}
