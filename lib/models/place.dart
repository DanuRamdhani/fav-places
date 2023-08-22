import 'dart:io';

class Place {
  Place({
    required this.title,
    required this.image,
    required this.date,
  });

  final String title;
  final File image;
  final DateTime date;
}
