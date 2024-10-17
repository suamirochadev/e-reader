import 'dart:io';
import 'package:e_reader/app/data/http/http_client.dart';
import 'package:e_reader/app/repositories/ebooks_repository.dart';
import 'package:e_reader/app/stores/ebooks_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class EbookDetailPage extends StatefulWidget {
  const EbookDetailPage({super.key, required this.ebook, required this.store});

  final EbooksStore store;
  final String ebook;

  @override
  State<EbookDetailPage> createState() => _EbookDetailPageState();
}

class _EbookDetailPageState extends State<EbookDetailPage> {
  final platform = const MethodChannel('my_channel');
  final HttpClient httpClient = HttpClient();
  final EbooksStore store = EbooksStore(
    repository: EbooksRepository(
      client: HttpClient(),
    ),
  );
  String filePath = '';

  @override
  void initState() {
    super.initState();
    store.getEbook(widget.ebook);
    downloadEbook();
  }

  // ANDROID VERSION
  Future<void> fetchAndroidVersion() async {
    final String? version = await getAndroidVersion();
    if (version != null) {
      String? fisrtPart;
      if (version.contains(".")) {
        fisrtPart = version.substring(0, version.indexOf('.'));
      } else {
        fisrtPart = version;
      }
      int intValue = int.parse(fisrtPart);
      if (intValue >= 13) {
        await startDownload();
      } else {
        final PermissionStatus status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          await startDownload();
        } else {
          await Permission.storage.request();
        }
      }
      print('ANDROID VERSION $intValue');
    }
  }

  Future<String?> getAndroidVersion() async {
    try {
      final String version = await platform.invokeMethod('getAndroidVersion');
      return version;
    } on PlatformException catch (e) {
      print('Failed to get android version: ${e.message}');
    }
  }

  startDownload() async {
    setState(() {
      store.isLoading.value = true;
    });

    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = '${appDocDir!.path}/${widget.ebook}.epub';
    File file = File(path);

    if (!file.existsSync()) {
      await file.create();
      await httpClient
          .downloadFile(
              url: 'https://escribo.com/books/${widget.ebook}.epub',
              destination: path,
              deleteOnError: true,
              onReceiveProgress: (receivedBytes, totalBytes) {
                print('Download --- ${receivedBytes / totalBytes * 100}%');
                setState(() {
                  store.isLoading.value = true;
                });
              })
          .whenComplete(() {
        setState(() {
          store.isLoading.value = false;
          filePath = path;
        });
      });
    } else {
      setState(() {
        store.isLoading.value = false;
        filePath = path;
      });
    }
  }

  downloadEbook() async {
    if (Platform.isIOS) {
      final PermissionStatus status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        await startDownload();
      } else {
        await Permission.storage.request();
      }
    } else if (Platform.isAndroid) {
      await fetchAndroidVersion();
    } else {
      PlatformException(code: '500');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ebook Detail'),
      ),
      body: Center(
        child: store.isLoading.value
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Downloading...'),
                  CircularProgressIndicator(),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (filePath.isNotEmpty) {
                        VocsyEpub.setConfig(
                          themeColor: Colors.blue,
                          identifier: 'book',
                          scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                          allowSharing: true,
                          enableTts: true,
                          nightMode: false,
                        );
                        VocsyEpub.locatorStream.listen(
                          (locator) {
                            print('LOCATOR: $locator');
                          },
                        );
                        VocsyEpub.open(
                          filePath,
                          lastLocation: EpubLocator.fromJson(
                            {
                              'bookId': 'book',
                              'href': 'OEBPS/Text/Section0001.xhtml',
                              'created': DateTime.now().toString(),
                              'locations': {
                                'cfi': 'epubcfi(/0!/4/4[simple_book]/2/2/6)'
                              }
                            },
                          ),
                        );
                      } else {
                        await downloadEbook();
                      }
                    },
                    child: const Text('Open online E-book'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      VocsyEpub.setConfig(
                        themeColor: Colors.blue,
                        identifier: 'book',
                        scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                        allowSharing: true,
                        enableTts: true,
                        nightMode: false,
                      );
                      VocsyEpub.locatorStream.listen(
                        (locator) {
                          print('LOCATOR: $locator');
                        },
                      );
                      await VocsyEpub.openAsset(
                        'assets/books/${widget.ebook}.epub',
                        lastLocation: EpubLocator.fromJson(
                          {
                            'bookId': 'book',
                            'href': 'OEBPS/Text/Section0001.xhtml',
                            'created': DateTime.now().toString(),
                            'locations': {
                              'cfi': 'epubcfi(/0!/4/4[simple_book]/2/2/6)'
                            }
                          },
                        ),
                      );
                    },
                    child: const Text('Open local E-book'),
                  ),
                ],
              ),
      ),
    );
  }
}
