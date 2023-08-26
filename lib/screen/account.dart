import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:fav_places/screen/auth.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure want to delete your account?'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(firebase.currentUser!.uid)
                    .delete();

                QuerySnapshot todoSnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(firebase.currentUser!.uid)
                    .collection('places')
                    .get();

                for (QueryDocumentSnapshot postSnapshot in todoSnapshot.docs) {
                  await postSnapshot.reference.delete();
                }

                await firebase.currentUser!.delete();
              } catch (e) {
                // print("Error deleting user");
              }

              GoogleSignIn().signOut();
              firebase.signOut();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
              firebase.currentUser!.photoURL.toString(),
            ),
          ),
          const SizedBox(height: 8),
          Text(firebase.currentUser!.email.toString()),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            onTap: () {
              firebase.signOut();
              GoogleSignIn().signOut();
            },
            title: const Text('Log out'),
            leading: const FaIcon(
              FontAwesomeIcons.arrowRightFromBracket,
              color: Colors.white70,
            ),
          ),
          ListTile(
            onTap: _showDeleteDialog,
            leading: const FaIcon(
              FontAwesomeIcons.userXmark,
              color: Colors.white70,
            ),
            title: const Text(
              'Delete account',
            ),
            subtitle: const Text(
              'Begin Permanent Account Deletion: All Data Will Be Lost Permanently',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
