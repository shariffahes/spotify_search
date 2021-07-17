import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_search/Providers/Album.dart';
import 'package:spotify_search/Providers/Artist.dart';
import 'package:spotify_search/Providers/auth_provider.dart';
import 'package:spotify_search/screens/Album_screen.dart';
import 'package:spotify_search/screens/Auth_screen.dart';
import 'package:spotify_search/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => AuthProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, ArtistProvider>(
            create: (ctx) => ArtistProvider("", []),
            update: (ctx, auth, prevArtist) => ArtistProvider(
              auth.getToken,
              prevArtist != null ? prevArtist.getArtists : [],
            ),
          ),
          ChangeNotifierProxyProvider<AuthProvider, AlbumsProvider>(
            create: (ctx) => AlbumsProvider("", []),
            update: (ctx, auth, prevAlbum) => AlbumsProvider(
                auth.getToken, prevAlbum == null ? [] : prevAlbum.getAlbums),
          ),
        ],
        child: MaterialApp(
          routes: {AlbumScreen.routePath: (ctx) => AlbumScreen()},
          title: 'Flutter Spotify',
          theme: ThemeData(
              primarySwatch: Colors.green, backgroundColor: Colors.black),
          home: Consumer<AuthProvider>(
            builder: (ctx, auth, _) {
              return auth.isAuthenticated() ? HomeScreen() : AuthScreen();
            },
          ),
        ));
  }
}
