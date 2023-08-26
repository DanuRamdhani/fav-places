import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fav_places/providers/user_places.dart';
import 'package:fav_places/screen/account.dart';
import 'package:fav_places/widgets/list_place.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
late Future<void> _placesFuture;

@override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }


  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 32,
                ),
                const SizedBox(width: 8),
                const Text('Fav Places'),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              unselectedLabelColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              tabs: const [
                Tab(
                  icon: FaIcon(FontAwesomeIcons.solidImages),
                  height: 54,
                ),
                Tab(
                  icon: FaIcon(FontAwesomeIcons.solidCircleUser),
                  height: 54,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ListPlace(userPlaces: userPlaces),
            const AccountScreen(),
          ],
        ),
      ),
<<<<<<< HEAD
=======
      body: FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListPlace(userPlaces: userPlaces),
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
>>>>>>> 37c5772577c783bc7e13c656e1535b6cdb474596
    );
  }
}
