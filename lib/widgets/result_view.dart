import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_search/Providers/Artist.dart';
import 'package:spotify_search/widgets/result_item.dart';

class ResultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Artist> listOfResults =
        Provider.of<ArtistProvider>(context).getArtists;
    return 
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 3 / 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        itemBuilder: (ctx, index) => ResultItem(
          listOfResults[index],
        ),
        itemCount: listOfResults.length,
      ),
    );
  }
}
