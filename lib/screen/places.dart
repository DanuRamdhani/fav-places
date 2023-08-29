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
              unselectedLabelColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
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
    );
  }
}
