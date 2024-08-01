import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:track_my_things/util/permission.dart';

class FullImage extends StatefulWidget {
  const FullImage({required this.imageUrl, super.key});
  final String imageUrl;

  @override
  State<FullImage> createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  double _progress = 0;
  bool _isDownloading = false;

  Future<void> downloadImage(String imageUrl, BuildContext context) async {
    try {
      final hasPermission = await requestStoragePermission();
      if (hasPermission) {
        final tempDir = await getTemporaryDirectory();
        // log(tempDir.path);
        final tempPath = tempDir.path;
        final fileName = 'downloaded_image-${DateTime.now()}';
        final fullPath = '$tempPath/$fileName';
        // log(fullPath);

        final dio = Dio();
        final response = await dio.get(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                _progress = received / total;
                _isDownloading = true;
              });
            }
          },
        );

        final file = File(fullPath);
        await file.writeAsBytes(response.data as List<int>);

        final imageBytes = await file.readAsBytes();

        final success = await SaverGallery.saveImage(
          imageBytes,
          name: fileName,
          androidExistNotSave: false,
        );

        if (success.isSuccess) {
          setState(() {
            _isDownloading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image saved to gallery!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save image to gallery!')),
          );
        }
        log(success.toString());
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      log('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: const BackButton(),
          elevation: 2,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                onTap: () async {
                  // Add your download functionality here
                  await downloadImage(widget.imageUrl, context);
                },
                child: const Text(
                  'Download',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: InteractiveViewer(
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
        bottomNavigationBar: _isDownloading
            ? SizedBox(
                height: 15,
                child: LinearProgressIndicator(
                  value: _progress,
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
