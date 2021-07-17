import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Artist {
  final String id;
  final String name;
  final String imageURL;
  final int nbOfFollowers;
  final int rating;

  Artist(
      {required this.id,
      required this.name,
      required this.imageURL,
      required this.nbOfFollowers,
      required this.rating});
}

class ArtistProvider with ChangeNotifier {
  String _token;
  List<Artist> _artists;
  ArtistProvider(this._token, this._artists);

  List<Artist> get getArtists {
    return [..._artists];
  }

  void searchForArtist(String artist) async {
    final url =
        Uri.parse("https://api.spotify.com/v1/search?q=$artist&type=artist");

    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token'
    });

    final results =
        json.decode(response.body)['artists']['items'] as List<dynamic>;
    List<Artist> artistsData = [];
    results.forEach((item) {
      final name = item['name'];
      final followers = item['followers']['total'];
      final popularity = item['popularity'];
      final imageURL = item['images'][0]['url'];
      final artistId = item['id'];
      artistsData.add(Artist(
        id: artistId,
        name: name,
        imageURL: imageURL,
        nbOfFollowers: followers,
        rating: popularity,
      ));
    });

    _artists = artistsData;
    notifyListeners();
  }
}
