import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future get({required String url});
}

class HttpClient implements IHttpClient {
  final client = http.Client();
  final Dio dio = Dio();

  @override
  Future get({required String url}) async {
    return await client.get(Uri.parse('https://escribo.com/books.json'));
  }

  Future<void> downloadEbook(String url, String savePath,
      {required bool deleteOnError,
      required void Function(int receivedBytes, int totalBytes)
          onReceiveProgress}) async {
    try {
      await dio.download(
        url,
        savePath,
        deleteOnError: deleteOnError,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      print("Error during ebook download: $e");
      rethrow;
    }
  }

  void dispose() {
    client.close();
  }
}
