import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mdbapp/style/theme.dart' as Style;
import 'package:mdbapp/widgets/best_movie.dart';
import 'package:mdbapp/widgets/genres.dart';
import 'package:mdbapp/widgets/genres_list.dart';
import 'package:mdbapp/widgets/now_playing.dart';
import 'package:mdbapp/widgets/persons.dart';
import 'package:mdbapp/widgets/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        leading: Icon(
          EvaIcons.menu2Outline,
          color: Colors.white,),
        title: Text("MOVIE APP"),
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchScreen(),
                  ),
                );
              },
              icon: Icon(
                EvaIcons.searchOutline,
                color: Colors.white,))
        ],
      ),
      body: ListView(
        children: <Widget>[
          NowPlaying(),
          GenresScreen(),
          PersonsList(),
          BestMovies(),

        ],
      ),
    );
  }
}
