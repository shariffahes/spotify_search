import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class PKCE {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Map<String, String> createCryptoRandomString() {
    final codeVerifier = getRandomString(128);

    var hash = sha256.convert(ascii.encode(codeVerifier));
    final codeChallenge = base64Url
        .encode(hash.bytes)
        .replaceAll("=", "")
        .replaceAll("+", "-")
        .replaceAll("/", "_");
    return {'codeVerifier': codeVerifier, 'codeChallenge': codeChallenge};
  }
}
