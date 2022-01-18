import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mdbapp/bloc/search_bloc.dart';
import 'package:mdbapp/models/movie.dart';
import 'package:mdbapp/models/movie_response.dart';
import 'package:mdbapp/screens/detail_screen.dart';
import 'package:mdbapp/style/theme.dart'as Style;


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchBloc..search("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        title: Text("MOVIE APP"),
        centerTitle: true,
        backgroundColor: Style.Colors.mainColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: TextFormField(
              style: TextStyle(fontSize: 14.0, color: Colors.black),
              controller: _searchController,
              onChanged: (changed) {
                searchBloc..search(_searchController.text);
              },
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: Colors.grey[100],
                suffixIcon: _searchController.text.length > 0
                    ? IconButton(
                    icon: Icon(
                      EvaIcons.backspaceOutline,
                      color: Colors.grey[500],
                      size: 16.0,
                    ),
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _searchController.clear();
                        searchBloc..search(_searchController.text);
                      });
                    })
                    : Icon(
                  EvaIcons.searchOutline,
                  color: Colors.grey[500],
                  size: 16.0,
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                    new BorderSide(color: Colors.grey[100]!.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(30.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                    new BorderSide(color: Colors.grey[100]!.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(30.0)),
                contentPadding: EdgeInsets.only(left: 15.0, right: 10.0),
                labelText: "Search...",
                hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
                labelStyle: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
            ),
          ),
          Expanded(
            child: StreamBuilder<MovieResponse>(
              stream: searchBloc.subject.stream,
              builder: (context, AsyncSnapshot<MovieResponse> snapshot){
                if(snapshot.hasData){
                  if(snapshot.data!.error != null && snapshot.data!.error!.length>0){
                    return _buildErrorWidget(snapshot.data!.error!);
                  }
                  return _buildMovieWidget(snapshot.data!);
                }else if(snapshot.hasError){
                  return _buildErrorWidget(snapshot.error.toString());
                }
                else{
                  return _buildLoadingWidget();
                }

              },
            ),
          )

        ],
      ),
    );
  }
  Widget _buildLoadingWidget(){
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //Text("Error occured: $error"),
        ],
      ),
    );
  }

  Widget _buildMovieWidget(MovieResponse data){
    List<Movie>? movies = data.movies;
    if(movies!.length == 0){
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "No More Movie",
              style: TextStyle(
                color: Colors.black45
              ),
            )

          ],
        ),

      );
    }else{
      return Container(
        height: 270,
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: movies.length,
            itemBuilder: (context, index){
              return Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, right: 15),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailScreen(movie: movies[index]),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Hero(
                        tag: movies[index].id!,
                        child: Container(
                          width: 120,
                          height: 180,
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              shape: BoxShape.rectangle,
                              image: new DecorationImage(
                                image: NetworkImage(
                                  "https://image.tmdb.org/t/p/w200" + movies[index].poster.toString(),
                                ),
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 20, width: 20,),
                      Column(
                        children: [
                         Container(
                          width: 200,
                          child: Text(
                            movies[index].title!,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                          SizedBox(height: 10,),
                          Container(
                            width: 200,
                            child: Text(
                              movies[index].overview!,
                              maxLines: 5,
                              style: TextStyle(
                                fontSize: 12,
                                color: Style.Colors.titleColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
}