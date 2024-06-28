import 'dart:io';

import 'package:flutter/material.dart';
import 'package:warranty_tracker/service/image_picker.dart';

class PickImageBottomSheet {
  Future<dynamic> showBottomSheet(
    BuildContext context,
    void Function(File?) onImageSelected,
  ) {
    return showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const Text(
                  'Choose Photo',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                const Divider(
                  indent: 12,
                  endIndent: 12,
                ),
                InkWell(
                  onTap: () async {
                    final returnedImage =
                        await PickImage().pickImageFromGalllery();
                    if (returnedImage != null) {
                      onImageSelected(File(returnedImage.path));
                    }
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.photo_library,
                        size: 24,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Pick image from gallery',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    final returnedImage =
                        await PickImage().pickImageFromCamera();
                    if (returnedImage != null) {
                      onImageSelected(File(returnedImage.path));
                    }

                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 24,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Pick image from Camera',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
