import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_search/Providers/Album.dart';
import 'package:spotify_search/Providers/Artist.dart';
import 'package:spotify_search/screens/Album_screen.dart';

class ResultItem extends StatelessWidget {
  final Artist artist;
  const ResultItem(this.artist);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<AlbumsProvider>(context, listen: false).fetchAlbums(artist.id);
        Navigator.of(context).pushNamed(AlbumScreen.routePath);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: Image.network(
            artist.imageURL,
            fit: BoxFit.cover,
          ),
          footer: Container(
            height: 45,
            child: GridTileBar(
              backgroundColor: Colors.black54,
              title: Text(artist.name),
              subtitle: Text('${artist.nbOfFollowers} followers'),
            ),
          ),
        ),
      ),
    );
  }
}
