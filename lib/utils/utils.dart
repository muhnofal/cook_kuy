import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("No image seleted");
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<void> startLoading(BuildContext context) async {
  return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          children: [
            Center(
              child: CircularProgressIndicator(
                color: ijoSkripsi,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              "Uploading Recipe...",
              style: TextStyle(color: Colors.white),
            ))
          ],
        );
      });
}

Future<void> editProfileLoading(BuildContext context) async {
  return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          children: [
            Center(
              child: CircularProgressIndicator(
                color: ijoSkripsi,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
                  "Edit your profile...",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        );
      });
}

Future<void> stopLoading(BuildContext context) async {
  Navigator.of(context, rootNavigator: true).pop();
}
