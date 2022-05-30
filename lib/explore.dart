import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Anime.dart';
import 'season_screen.dart';

class Explore extends StatelessWidget {
  Future<List<Anime>> getAnimes() async {
    final response =
        await http.get(Uri.parse('http://192.168.100.8:8080/animes'));

    if (response.statusCode == 200) {
      return Anime.parseAnimeJsonList(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load animes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Anime>>(
        future: getAnimes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("${snapshot.error}");
            return Center(child: Text("Something went wrong."));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            double imageWidth = MediaQuery.of(context).size.width * 0.15;
            double imageHeight = MediaQuery.of(context).size.width * 0.2;

            return ListView(
                children: snapshot.data!.map((anime) {
              return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/seasons",
                        arguments: SeasonScreenArgs(anime: anime));
                  },
                  child: Card(
                      child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.network(
                                  '${anime.coverImageUrl}',
                                  width: imageWidth,
                                  height: imageHeight,
                                  fit: BoxFit.fill,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Column(children: [
                                      Text(anime.title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16)),
                                      Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: Text(
                                              "Seasons: ${anime.totalSeasons}"))
                                    ])),
                                Column(children: [
                                  Icon(Icons.add_box),
                                  Text("Add to watchlist")
                                ])
                              ]))));
            }).toList());
          }

          return Center(child: Text('Loading...'));
        });
  }
}
