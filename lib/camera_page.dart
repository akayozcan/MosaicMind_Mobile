import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? image;

  Future<void> pickImageAndSave(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) {
        return;
      }

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });

      // Save image to gallery
      final bool? isSaved = await GallerySaver.saveImage(imageTemporary.path);
      if (isSaved == true) {
        print('Image saved to gallery');
      } else {
        print('Failed to save image to gallery');
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(
              'Pick Image from Camera',
              Icons.camera,
              () {
                pickImageAndSave(ImageSource.camera);
              },
            ),
            const SizedBox(height: 16),
            buildButton(
              'Pick Image from Gallery',
              Icons.photo_library,
              () {
                pickImageAndSave(ImageSource.gallery);
              },
            ),
            if (image != null) Image.file(image!),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String title, IconData icon, VoidCallback onClicked) {
    return ElevatedButton(
      onPressed: onClicked,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        minimumSize: const Size(double.infinity, 50), // Make it responsive
        padding: const EdgeInsets.symmetric(horizontal: 16),
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }
}
