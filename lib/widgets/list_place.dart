import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fav_places/screen/place_detail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:fav_places/screen/auth.dart';
import 'package:fav_places/models/place.dart';
import 'package:fav_places/screen/add_place.dart';

class ListPlace extends StatefulWidget {
  const ListPlace({super.key, required this.userPlaces});

  final List<Place> userPlaces;

  @override
  State<ListPlace> createState() => _ListPlaceState();
}

class _ListPlaceState extends State<ListPlace> {
  final CollectionReference _place = FirebaseFirestore.instance
      .collection('users')
      .doc(firebase.currentUser!.uid)
      .collection('places');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: _place.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No place added yet',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 24,
                          ),
                    ),
                    const Text('Try add new places by press button below'),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    snapshot.data!.docs[index];

                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _place.doc(documentSnapshot.id).delete();
                  },
                  background: Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.only(right: 16),
                    alignment: Alignment.centerRight,
                    child: const FaIcon(
                      FontAwesomeIcons.trash,
                      color: Colors.white70,
                    ),
                  ),
                  child: Card(
                    color: Theme.of(context).colorScheme.onSurface,
                    elevation: 8,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PlaceDetailScreen(
                            documentSnapshot: documentSnapshot,
                          ),
                        ));
                      },
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage:
                            FileImage(File(documentSnapshot['image'])),
                      ),
                      title: Text(
                        documentSnapshot['title'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMMEEEEd().format(
                            (documentSnapshot['date'] as Timestamp).toDate()),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 11,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.7),
                            ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPlace(),
            ),
          );
        },
        shape: const CircleBorder(),
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
