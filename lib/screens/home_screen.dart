import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_search/Providers/Artist.dart';
import 'package:spotify_search/Providers/auth_provider.dart';
import 'package:spotify_search/widgets/result_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formkey = GlobalKey();
  var _isFocused = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        print("focused");
        setState(() {
          _isFocused = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  void _submit(ArtistProvider artistProv, String nameOfArtist) {
    artistProv.searchForArtist(nameOfArtist);
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    ArtistProvider artistProvider = Provider.of<ArtistProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Artist Search'),
        actions: [
          IconButton(
              onPressed: () {
                auth.logout();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment:
              _isFocused ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.all(12.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                    key: _formkey,
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "Search for an artist ..."),
                      focusNode: _focusNode,
                      onFieldSubmitted: (input) {
                        _submit(artistProvider, input);
                      },
                    )),
              ),
            ),
            Container(
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top) *
                    0.75,
                child: ResultView()),
          ],
        ),
      ),
    );
  }
}
