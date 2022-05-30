import 'package:flutter/material.dart';

import 'Anime.dart';

class SeasonScreenArgs {
  final Anime anime;

  SeasonScreenArgs({required this.anime});
}

class SeasonScreen extends StatelessWidget {
  const SeasonScreen({Key? key}) : super(key: key);

  static const routeName = "/seasons";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SeasonScreenArgs;

    return Scaffold(
      appBar: AppBar(title: Text("${args.anime.title} Seasons")),
      body: ListView(
        children: List.generate(args.anime.totalSeasons, (index) {
          return Card(
              margin: EdgeInsets.only(top: 10, left: 5, right: 5),
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Season ${index + 1}",
                    style: TextStyle(fontSize: 18),
                  )));
        }),
      ),
    );
  }
}
