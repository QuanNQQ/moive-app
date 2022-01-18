import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mdbapp/bloc/get_movies_bloc.dart';
import 'package:mdbapp/models/movie.dart';
import 'package:mdbapp/models/movie_response.dart';
import 'package:mdbapp/screens/detail_screen.dart';
import 'package:mdbapp/style/theme.dart' as Style;

class BestMovies extends StatefulWidget {
  const BestMovies({Key? key}) : super(key: key);

  @override
  _BestMoviesState createState() => _BestMoviesState();
}
class _BestMoviesState extends State<BestMovies> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moviesBloc .. getMovies();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            "BEST POPULAR MOVIES",
            style: TextStyle(
              color: Style.Colors.titleColor,
              fontSize: 12,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        StreamBuilder<MovieResponse>(
          stream: moviesBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieResponse> snapshot){
            if(snapshot.hasData){
              if(snapshot.data!.error != null && snapshot.data!.error!.length>0){
                return _buildErrorWidget(snapshot.data!.error!);
              }
              return _buildHomeWidget(snapshot.data!);
            } else if(snapshot.hasError){
              return _buildErrorWidget(snapshot.error.toString());
            } else{
              return _buildLoadingWidget();
            }
          },
        )
      ],
    );
  }

  Widget _buildLoadingWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
        children: [
          Text("Error Occured: $error"),
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No More Movies",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ],

            )
          ],
        ),
      );
    } else{
      return Container(
        height: 300,
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
            itemCount: movies.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              return Padding(
                padding: EdgeInsets.only(top: 10,bottom: 10, right: 15),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 120,
                        height: 180,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w200/"+ movies[index].poster.toString())
                          )

                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 100,
                        child: Text(
                          movies[index].title.toString(),
                          maxLines: 2,
                          style: TextStyle(
                            height: 1.4,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            movies[index].rating.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RatingBar(
                              ratingWidget: RatingWidget(
                                empty: Icon(
                                  EvaIcons.star,
                                  color: Style.Colors.titleColor,
                                ),
                                full: Icon(
                                  EvaIcons.star,
                                  color: Style.Colors.secondColor,
                                ),
                                half: Icon(
                                  EvaIcons.star,
                                  color: Style.Colors.titleColor,
                                )
                              ),
                              itemSize: 8,
                              initialRating: movies[index].rating! / 2,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 2),
                              onRatingUpdate: (rating){
                                print(rating);
                              })
                        ],
                      )


                    ],
                  ),
                ),
              );
            })
      );
    }
  }
}
