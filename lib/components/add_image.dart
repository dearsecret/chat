import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  const AddImage(
    this.addImageFunc, {
    super.key,
  });

  final Function(File pickedImage) addImageFunc;

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  File? pickedImage;
  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);
    setState(() {
      if (pickedImageFile != null) {
        pickedImage = File(pickedImageFile.path);
      }
    });
    widget.addImageFunc(pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width - 20,
        height: 230,
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              backgroundImage:
                  pickedImage != null ? FileImage(pickedImage!) : null,
            ),
            const SizedBox(
              height: 15,
            ),
            OutlinedButton.icon(
              onPressed: () {
                _pickImage();
              },
              icon: const Icon(Icons.image),
              label: const Text("사진 넣어라"),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
              label: const Text("취소"),
            )
          ],
        ),
      ),
    );
  }
}
