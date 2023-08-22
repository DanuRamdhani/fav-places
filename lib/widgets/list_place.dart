import 'package:fav_places/models/place.dart';
import 'package:fav_places/screen/place_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ListPlace extends ConsumerStatefulWidget {
  const ListPlace({super.key, required this.userPlaces});

  final List<Place> userPlaces;

  @override
  ConsumerState<ListPlace> createState() => _ListPlaceState();
}

class _ListPlaceState extends ConsumerState<ListPlace> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: widget.userPlaces.isNotEmpty
          ? ListView.builder(
              itemCount: widget.userPlaces.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      widget.userPlaces.remove(widget.userPlaces[index]);
                    });
                  },
                  child: Card(
                    color: Theme.of(context).colorScheme.onSurface,
                    elevation: 8,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PlaceDetailScreen(
                            userPlaces: widget.userPlaces[index],
                          ),
                        ));
                      },
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage:
                            FileImage(widget.userPlaces[index].image),
                      ),
                      title: Text(
                        widget.userPlaces[index].title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMMEEEEd()
                            .format(widget.userPlaces[index].date),
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
            )
          : Center(
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
            ),
    );
  }
}
