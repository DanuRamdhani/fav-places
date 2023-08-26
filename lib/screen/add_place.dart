import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fav_places/screen/auth.dart';
import 'package:fav_places/widgets/image_input.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  TextEditingController titleControler = TextEditingController();
  DateTime? selectedDate;
  File? image;

  final CollectionReference _place = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('places');

  void selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 3000)),
      lastDate: DateTime.now(),
    ).then((value) {
      setState(() {
        selectedDate = value;
      });
    });
  }

  void savePlace() {
    if (titleControler.text.isEmpty || selectedDate == null || image == null) {
      return;
    }

    _place.add({
      'title': titleControler.text,
      'date': selectedDate,
      'image': image!.path,
    });

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    titleControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add New Place'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                alignLabelWithHint: true,
                labelText: 'Title...',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                  fontSize: 24,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(fontSize: 24),
              cursorColor: Theme.of(context).colorScheme.onPrimary,
              controller: titleControler,
            ),
            const SizedBox(height: 8),
            ImagesInput(
              onPickImage: (file) {
                image = file;
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: selectDate,
                  icon: const FaIcon(FontAwesomeIcons.calendar),
                  label: const Text('Select date'),
                ),
                Text(
                  selectedDate == null
                      ? 'No date selected'
                      : DateFormat.yMMMMEEEEd().format(selectedDate!),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: savePlace,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
