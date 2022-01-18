import 'package:mdbapp/style/theme.dart' as Style;
import 'package:flutter/material.dart';
import 'package:mdbapp/bloc/get_movies_bygenre_bloc.dart';
import 'package:mdbapp/models/genre.dart';
import 'package:mdbapp/widgets/movies_by_genre.dart';

class GenResList extends StatefulWidget {
final List<Genre> genres;
  const GenResList({Key? key, required this.genres}) : super(key: key);

  @override
  _GenResListState createState() => _GenResListState(genres);
}

class _GenResListState extends State<GenResList> with SingleTickerProviderStateMixin{
  final List<Genre> genres;
  _GenResListState(this.genres);

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: genres.length, vsync: this);
    _tabController!.addListener(() {
      if(_tabController!.indexIsChanging){
        moviesByGenreBloc .. drainStream();
      }
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          backgroundColor: Style.Colors.mainColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              backgroundColor: Style.Colors.mainColor,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Style.Colors.secondColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3.0,
                unselectedLabelColor: Style.Colors.titleColor,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: genres.map((Genre genre){
                  return Container(
                    padding: EdgeInsets.only(bottom: 15, top: 10),
                    child: new Text(genre.name.toUpperCase(), style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )));
                  }).toList(),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: genres.map((Genre genre){
              return GenreMovies(genreId: genre.id);
            }).toList(),


          ),
        ),
      ),
    );
  }
}
