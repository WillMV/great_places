import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageInput {
  Future<File?> takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      return _savePicture(image.path);
    } else {
      return null;
    }
  }

  Future<File?> galleryPicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return _savePicture(image.path);
    } else {
      return null;
    }
  }

  Future<File> _savePicture(String pathImage) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String pathName = path.basename(pathImage);
    final File savedImage =
        await File(pathImage).copy('${appDir.path}/$pathName');
    return savedImage;
  }
}
