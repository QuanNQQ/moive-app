import 'package:flutter/material.dart';
import 'package:mdbapp/bloc/get_movie_similar_bloc.dart';
import 'package:mdbapp/models/movie.dart';
import 'package:mdbapp/models/movie_response.dart';
import 'package:mdbapp/screens/detail_screen.dart';
import 'package:mdbapp/style/theme.dart' as Style;


class SimilarMovies extends StatefulWidget {
  final int id;
  const SimilarMovies({Key? key, required this.id}) : super(key: key);

  @override
  _SimilarMoviesState createState() => _SimilarMoviesState(id);
}

class _SimilarMoviesState extends State<SimilarMovies> {
  final int id;
  _SimilarMoviesState(this.id);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    similarMoviesBloc .. getSimilarMovies(id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    similarMoviesBloc.drainStream();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            "SIMILAR MOVIES",
            style: TextStyle(
              fontSize:12,
              fontWeight: FontWeight.bold,
              color: Style.Colors.titleColor,
            ),
          ),
        ),
        SizedBox(height: 5,),

        StreamBuilder(
            stream: similarMoviesBloc.subject.stream,
            builder: (context, AsyncSnapshot<MovieResponse> snapshot){
              if(snapshot.hasData){
                if(snapshot.data!.error != null && snapshot.data!.error!.length > 0){
                  return _buildErrorWidget(snapshot.data!.error!);
                }
                return _buildHomeWidget(snapshot.data!);
              } else if(snapshot.hasError){
                  return _buildErrorWidget(snapshot.error.toString());
              } else{
                return _buildLoadingWidget();
              }
            })
      ],
    );
  }

  Widget _buildLoadingWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 4,
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Error Occured : $error"),
        ],
      ),
    );
  }

  Widget _buildHomeWidget(MovieResponse data){
    List<Movie>? movies = data.movies;
    if(movies!.length == 0){
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "NO MORE MOVIE",
              style: TextStyle(
                color: Colors.black45
              ),
            )
          ],
        ),
      );
    }
    else{
      return Container(
        height: 270,
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index){
            return Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, right: 15),
              child: GestureDetector(
                onTap: (){Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MovieDetailScreen(movie: movies[index]),
                  ),
                );},
                child: Column(
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
                    SizedBox(height: 10,),
                    Container(
                      width: 100,
                      child: Text(
                        movies[index].title!,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
