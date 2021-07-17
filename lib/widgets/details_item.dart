import 'package:flutter/material.dart';
import 'package:spotify_search/Providers/Album.dart';

class DetailsItem extends StatelessWidget {
  final Album album;
  DetailsItem(this.album);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: GridTile(
        child: Image.network(album.imageURL),
        footer: Container(
          child: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(album.albumName),
            subtitle: Text(album.artistsToString()),
          ),
        ),
      ),
    );
  }
}
