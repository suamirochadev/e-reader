import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:e_reader/app/models/ebooks_model.dart';
import 'package:e_reader/app/stores/ebooks_store.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class EbookDetailPage extends StatefulWidget {
  const EbookDetailPage({super.key, required this.ebook, required this.store});

  final EbooksModel ebook;
  final EbooksStore store;

  @override
  State<EbookDetailPage> createState() => _EbookDetailPageState();
}

class _EbookDetailPageState extends State<EbookDetailPage> {
  EbooksStore ebooks = EbooksStore();
  final Dio dio = Dio();
  String filePath = '';

  Future<void> startDownload(String downloadUrl, String id) async {
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationCacheDirectory();

    if (appDocDir != null) {
      final ebookDir = Directory('${appDocDir.path}/ebooks');
      if (!await ebookDir.exists()) {
        await ebookDir.create();
      }
    }

    String path = '${appDocDir!.path}/${widget.ebook.id}.epub';
    File file = File(path);

    if (!await file.exists()) {
      await file.create();
      await dio.download(
        downloadUrl,
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          double progress = (receivedBytes / totalBytes * 100);
          widget.store.isLoading.value = true;
          // Atualiza a UI com a porcentagem de progresso
          setState(() {
            widget.store.downloadProgress.value = progress;
          });
        },
      ).whenComplete(() {
        setState(() {
          widget.store.isLoading.value = false;
          filePath = path;
          // ignore: avoid_print
          print('File downloaded at: $path');
        });
      });
    } else {
      setState(() {
        widget.store.isLoading.value = false;
        filePath = path;
      });
    }
    openEpub(filePath);
  }

  void openEpub(String filePath) {
    VocsyEpub.setConfig(
      themeColor: Colors.blue,
      identifier: 'book',
      scrollDirection: EpubScrollDirection.VERTICAL,
      allowSharing: true,
      enableTts: true,
      nightMode: true,
    );
    VocsyEpub.locatorStream.listen(
      (locator) {
        print('LOCATOR: $locator');
      },
    );
    VocsyEpub.open(
      filePath,
    );
  }

  Future<void> downloadEbook(String downloadUrl, String id) async {
    if (Platform.isAndroid) {
      try {
        String firstPart;
        final deviceInfoPlugin = DeviceInfoPlugin();
        final deviceInfo = await deviceInfoPlugin.androidInfo;
        final allInfo = deviceInfo.data;
        firstPart = allInfo['version']["release"].toString().split('.').first;

        int intValue = int.parse(firstPart);
        if (intValue >= 13 && await Permission.storage.isGranted) {
          await startDownload(
            downloadUrl,
            id,
          );
        } else {
          if (!await Permission.storage.isGranted) {
            await Permission.storage.request();
            await startDownload(
              downloadUrl,
              id,
            );
          } else {
            setState(() {
              widget.store.isLoading.value = false;
            });
          }
        }
      } catch (e) {
        print(e);
        setState(() {
          widget.store.isLoading.value = false;
        });
      }
    } else {
      setState(() {
        widget.store.isLoading.value = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ebook Detail'),
      ),
      body: Center(
        child: ValueListenableBuilder<bool>(
          valueListenable: widget.store.isLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Downloading...'),
                  CircularProgressIndicator(
                    value: widget.store.downloadProgress.value / 100,
                  ),
                  Text(
                    '${widget.store.downloadProgress.value.toStringAsFixed(0)}%',
                  ),
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (filePath.isNotEmpty) {
                      openEpub(filePath);
                    }
                    setState(() {
                      openEpub(filePath);
                    });
                  },
                  child: const Text('Open E-book'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (filePath.isEmpty) {
                      await downloadEbook(
                        widget.ebook.downloadUrl,
                        widget.ebook.id.toString(),
                      );
                    }
                  },
                  child: const Text('Download E-book'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
