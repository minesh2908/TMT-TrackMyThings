import 'package:image_picker/image_picker.dart';

/// A class for picking images using the ImagePicker plugin.
class PickImage {
  /// Picks an image from the device's gallery.
  ///
  /// Returns the selected image as an [XFile], or `null` if no image was selected.
  Future<XFile?>? pickImageFromGalllery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    return returnedImage;
  }

  /// Picks an image using the device's camera.
  ///
  /// Returns the selected image as an [XFile], or `null` if no image was captured.
  Future<XFile?>? pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    return returnedImage;
  }
}