import 'package:flutter/material.dart';

import 'app_storage.dart';
import 'harvest_tracker_app.dart';
import 'place.dart';
import 'place_details.dart';

class PlaceList extends StatefulWidget {
  const PlaceList({Key key}) : super(key: key);

  @override
  PlaceListState createState() => PlaceListState();
}

class PlaceListState extends State<PlaceList> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _onPlaceChanged(Place value) async {
    // Replace the place with the modified version.
    final newPlaces = List<Place>.from(await AppStorage.getFromStorage());
    final index = newPlaces.indexWhere((place) => place.id == value.id);
    newPlaces[index] = value;

    AppStorage.listPlaces = newPlaces;
    await AppStorage.saveToStorage();

    //AppState.updateWith(context, places: newPlaces);
  }

  Future<void> _onPlaceRemoved(Place value) async {
    // Replace the place with the modified version.
    final newPlaces = List<Place>.from(await AppStorage.getFromStorage());
    final index = newPlaces.indexWhere((place) => place.id == value.id);
    newPlaces.removeAt(index);

    AppStorage.listPlaces = newPlaces;
    await AppStorage.saveToStorage();

    //AppState.updateWith(context, places: newPlaces);
  }

  Widget placeListWidget() {
    return FutureBuilder(
        future: AppStorage.getFromStorage(),
        builder: (context, placeListSnap) {
          if (placeListSnap.data == null) {
            return ListView(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                controller: _scrollController,
                shrinkWrap: true,
                children: []);
          } else {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              controller: _scrollController,
              shrinkWrap: true,
              children: (placeListSnap.data as List<Place>)
                  .where((place) =>
                      place.category == AppState.of(context).selectedCategory)
                  .map((place) => _PlaceListTile(
                        place: place,
                        onPlaceChanged: (value) => _onPlaceChanged(value),
                        onPlaceRemoved: (value) => _onPlaceRemoved(value),
                      ))
                  .toList(),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        /* _ListCategoryButtonBar(
          selectedCategory: AppState.of(context).selectedCategory,
          onCategoryChanged: (value) => _onCategoryChanged(value),
        ), */
        Expanded(child: placeListWidget()),
      ],
    );
  }
}

class _PlaceListTile extends StatelessWidget {
  const _PlaceListTile({
    Key key,
    @required this.place,
    @required this.onPlaceChanged,
    @required this.onPlaceRemoved,
  })  : assert(place != null),
        assert(onPlaceChanged != null),
        assert(onPlaceRemoved != null),
        super(key: key);

  final Place place;
  final void Function(Place) onPlaceChanged;
  final void Function(Place) onPlaceRemoved;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push<void>(
        context,
        MaterialPageRoute(builder: (context) {
          return PlaceDetails(
              place: place,
              navPlaces: [],
              onChanged: (value) => onPlaceChanged(value),
              onRemoved: (value) => onPlaceRemoved(value));
        }),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              place.address,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.blue),
              maxLines: 3,
            ),
            SizedBox(height: 8.0),
            Text(
              'Last Harvest Date: ${place.lastDate ?? ''}',
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.0),
            Text(
              'Ready Date for Harvest: ${place.readyDate ?? ''}',
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.0),
            /* Row(
              children: List.generate(10, (index) {
                return Icon(
                  Icons.golf_course,
                  size: 28.0,
                  color: place.countTrees > index
                      ? Colors.amber
                      : Colors.grey[400],
                );
              }).toList(),
            ), */
            Text(
              'Count of Trees: ${place.countTrees ?? ''}',
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.0),
            Text(
              place.description ?? '',
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            /* SizedBox(height: 16.0), */
            Divider(
              height: 2.0,
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }
}
