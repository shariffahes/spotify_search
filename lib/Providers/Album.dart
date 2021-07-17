import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:spotify_search/Providers/Artist.dart';

class Album {
  final String albumName;
  final List<String> artists;
  final String date;
  final int nbOfTracks;
  final String imageURL;
  final previewURL;

  Album({
    required this.albumName,
    required this.artists,
    required this.date,
    required this.nbOfTracks,
    required this.imageURL,
    required this.previewURL,
  });

  String artistsToString() {
    String artistsOfAlbum = "";
    artists.forEach((artist) {
      artistsOfAlbum = "$artistsOfAlbum,$artist";
    });
    return artistsOfAlbum;
  }
}

class AlbumsProvider with ChangeNotifier {
  String _token;
  List<Album> _albums;

  AlbumsProvider(this._token, this._albums);

  List<Album> get getAlbums {
    return [..._albums];
  }

  void fetchAlbums(String id) async {
    final url = Uri.parse("https://api.spotify.com/v1/artists/$id/albums");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    });

    final decodedData = json.decode(response.body);
    final data = decodedData['items'] as List<dynamic>;
    final List<Album> extractedAlbums = [];
    data.forEach((item) {
      final name = item['name'];
      final date = item['release_date'];
      final tracks = item['total_tracks'];
      final url = item['external_urls']['spotify'];
      final imageURL = item['images'][0]['url'];
      final artistsOfAlbum = item['artists'] as List<dynamic>;
      final List<String> artists =
          artistsOfAlbum.map((artist) => artist['name'] as String).toList();
      extractedAlbums.add(Album(
        albumName: name,
        artists: artists,
        date: date,
        nbOfTracks: tracks,
        imageURL: imageURL,
        previewURL: url,
      ));
    });

    _albums = extractedAlbums;

    notifyListeners();
  }
}
