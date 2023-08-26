import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.documentSnapshot});

  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 430,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: FileImage(File(documentSnapshot['image'])),
                    fit: BoxFit.cover),
              ),
            ),
            Text(
              documentSnapshot['title'],
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 32,
                  ),
            ),
            Text(
              DateFormat.yMMMMEEEEd()
                  .format((documentSnapshot['date'] as Timestamp).toDate()),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(),
            )
          ],
        ),
      ),
    );
  }
}
