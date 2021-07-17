import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_search/Providers/Album.dart';
import 'package:spotify_search/widgets/details_item.dart';

class DetailsGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Album> albums = Provider.of<AlbumsProvider>(context).getAlbums;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 3 / 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        children: albums
            .map(
              (e) => DetailsItem(e),
            )
            .toList(),
      ),
    );
  }
}
