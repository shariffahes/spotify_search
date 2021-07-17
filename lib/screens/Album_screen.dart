import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spotify_search/widgets/details_grid_view.dart';

class AlbumScreen extends StatelessWidget {
  static const routePath = "/artist-albums";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: DetailsGridView(),
    );
  }
}
