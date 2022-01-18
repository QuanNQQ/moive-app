import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mdbapp/bloc/get_now_playing_bloc.dart';
import 'package:mdbapp/models/movie.dart';
import 'package:mdbapp/models/movie_response.dart';
import 'package:mdbapp/screens/detail_screen.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:mdbapp/style/theme.dart' as Style;



class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  PageController pageController = PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState(){
    super.initState();
    nowPlayingMoviesBloc .. getMovies();
  }


  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
        stream: nowPlayingMoviesBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieResponse> snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.error != null && snapshot.data!.error!.length > 0){
              return _buildErrorWidget(snapshot.data!.error.toString());
            }
            return _buildNowPlayingWidget(snapshot.data!);
          } else if(snapshot.hasError){
            return _buildErrorWidget(snapshot.error!.toString());
          } else{
            return _buildLoadingWidget();
          }
        }
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
              strokeWidth: 4.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error occured: $error"),
          ],
        ));
  }



  Widget _buildNowPlayingWidget(MovieResponse data){
    List<Movie>? movies = data.movies;
    if(movies!.length == 0){
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("No Genre"),
          ],
        ),
      );
    }else {
      return Container(
      height: 220,
      child:  PageIndicatorContainer(
        align: IndicatorAlign.bottom,
        indicatorSpace: 8,
        padding: EdgeInsets.all(5),
        indicatorColor: Style.Colors.titleColor,
        indicatorSelectorColor: Style.Colors.secondColor,
        length: movies.take(8).length,
        shape: IndicatorShape.circle(size: 8),
        child:  PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(8).length,
            itemBuilder: (context, index){
              return Stack(
                children:<Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(image: NetworkImage("https://image.tmdb.org/t/p/original/"+ movies[index].backPoster.toString()),
                      fit: BoxFit.cover),

                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Style.Colors.mainColor.withOpacity(1.0),
                        Style.Colors.mainColor.withOpacity(0.0),

                      ],
                        begin: Alignment.bottomCenter,  // hiệu ứng
                        end: Alignment.topCenter,
                      )
                    ),
                  ),
                  Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      right: 0,
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
                        child: Icon(
                          FontAwesomeIcons.playCircle,
                          color: Style.Colors.secondColor,
                          size: 60,
                        ),
                      )),
                  Positioned(
                    bottom: 30,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: 400,
                      child: Column(
                        children: <Widget>[
                          Text(
                            movies[index].title.toString(),
                            style: TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),

                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            })
      ),
    );
    }

  }




}
