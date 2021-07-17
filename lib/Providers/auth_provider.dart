import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:spotify_search/Models/HTTPException.dart';
import 'package:spotify_search/Models/PKCE.dart';
import 'dart:convert';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:uni_links/uni_links.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  late final String codeChallenge;
  late final String codeVerifier;
  String? _token;
  int? _expirationTime;
  String? _refreshToken;
  Timer? timeToExpire;

  void launchAuthorization() async {
    final url =
        "https://accounts.spotify.com/authorize?response_type=code&client_id=23253146d37740ec8327c2abb1bc40bd&redirect_uri=spotifySearch://authorize/&scope=user-follow-modify&state=e21392da45dbf4&code_challenge=$codeChallenge&code_challenge_method=S256";
    if (await canLaunch(url)) {
      launch(url);
    } else {
      print("URL can't be launched");
    }
  }

  StreamSubscription? _sub;

  Future<void> initUniLinks() async {
    //generate set the code key and code challenge
    final authKeys = PKCE().createCryptoRandomString();
    codeChallenge = authKeys['codeChallenge']!;
    codeVerifier = authKeys['codeVerifier']!;

    // ... check initialUri

    // Attach a listener to the stream

    _sub = uriLinkStream.listen((Uri? uri) async {
      // Use the uri and warn the user, if it is not correct
      if (uri == null) {
        print("nul");
        return;
      }
      //Get the code and the state
      Map<String, String> authorizationResponse = uri.queryParameters;

      //Check the state in the response to the one in the authorization url
      //stop the flow if there are any mismatch
      if (authorizationResponse['state'] != 'e21392da45dbf4') {
        throw HTTPException(authorizationResponse['error']!);
      }
      //extract the recieved code from the uri
      final authCode = authorizationResponse['code'];

      //Prepare the url for the token request
      final url = Uri.parse(
          "https://accounts.spotify.com/api/token?client_id=23253146d37740ec8327c2abb1bc40bd&grant_type=authorization_code&code=$authCode&redirect_uri=spotifySearch://authorize/&code_verifier=$codeVerifier");

      //post the request
      final result = await http.post(url,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});

      //if the token request failed throw an error
      if (result.statusCode != 200) throw HTTPException(result.body);

      //decode the response and extract the data
      final extractedData = json.decode(result.body);

      _setAuthCredentials(extractedData);
      notifyListeners();
      await closeWebView();
      //print("closed");
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      print(err.toString());
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  void _setAuthCredentials(Map<String, dynamic> credentials) {
    _token = credentials['access_token'];
    _refreshToken = credentials['refresh_token'];
    _expirationTime = credentials['expires_in'];
    _expiredSessionAfter(_expirationTime!);
    print("token: $_token");
    print("refreshToken: $_refreshToken");
    print("time: $_expirationTime");
  }

  void logout() {
    _token = null;
    timeToExpire!.cancel();
    _expirationTime = null;
    _refreshToken = null;
    notifyListeners();
  }

  String get getToken {
    return _token!;
  }

  void _refreshSession() async {
    final url = Uri.parse(
        "https://accounts.spotify.com/api/token?grant_type=refresh_token&refresh_token=$_refreshToken&client_id=23253146d37740ec8327c2abb1bc40bd");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      final data = json.decode(response.body);

      _setAuthCredentials(data);
    } catch (error) {
      throw HTTPException(error.toString());
    }
  }

  bool isAuthenticated() {
    return _token != null;
  }

  void _expiredSessionAfter(int duration) {
    if (timeToExpire != null) timeToExpire!.cancel();
    timeToExpire = Timer(Duration(seconds: _expirationTime!), _refreshSession);
  }
}
