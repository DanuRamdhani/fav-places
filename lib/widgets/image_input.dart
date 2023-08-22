import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ImagesInput extends StatefulWidget {
  const ImagesInput({
    super.key,
    required this.onPickImage,
  });

  final void Function(File file) onPickImage;

  @override
  State<ImagesInput> createState() => _ImagesInputState();
}

class _ImagesInputState extends State<ImagesInput> {
  File? _selectedImage;

  void _takePictureCamera() async {
    Navigator.of(context).pop();
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);

  }

  void _takePictureGallery() async {
    Navigator.of(context).pop();
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
  }

  void addImageFrom() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Wrap(
            // spacing: 16,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: _takePictureCamera,
                icon: const FaIcon(FontAwesomeIcons.camera),
                label: const Text('Camera'),
              ),
              TextButton.icon(
                onPressed: _takePictureGallery,
                icon: const FaIcon(FontAwesomeIcons.images),
                label: const Text('Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: addImageFrom,
      icon: const FaIcon(FontAwesomeIcons.image),
      label: const Text('Add Image'),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: addImageFrom,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: FileImage(_selectedImage!), fit: BoxFit.cover),
          ),
        ),
      );
    }

    return Container(
      height: 450,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: content,
    );
  }
}
