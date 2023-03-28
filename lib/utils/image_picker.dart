import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source, imageQuality: 70);

  if (file != null) {
    return File(file.path);
  }
  if (kDebugMode) {
    print('No image selected');
  }
}
