import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mdbapp/bloc/get_movie_videos_bloc.dart';
import 'package:mdbapp/models/cast.dart';
import 'package:mdbapp/models/movie.dart';
import 'package:mdbapp/models/video.dart';
import 'package:mdbapp/models/video_response.dart';
import 'package:mdbapp/screens/video_player.dart';
import 'package:mdbapp/style/theme.dart' as Style;
import 'package:mdbapp/widgets/cast.dart';
import 'package:mdbapp/widgets/movie_info.dart';
import 'package:mdbapp/widgets/similar_movie.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState(movie);
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final Movie movie;
  _MovieDetailScreenState(this.movie);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movieVideoBloc ..getMovieVideos(movie.id!);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    movieVideoBloc .. drainStream();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: new Builder(
          builder: (context){
            return new SliverFab(
              floatingPosition: FloatingPosition(right: 20),
              floatingWidget: StreamBuilder<VideoResponse>(
                stream: movieVideoBloc.subject.stream,
                builder: (context, AsyncSnapshot<VideoResponse> snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data!.error != null && snapshot.data!.error!.length>0){
                      return _buildErrorWidget(snapshot.data!.error!);
                    }
                    return _buildVideoWidget(snapshot.data!);
                  } else if(snapshot.hasError){
                    return _buildErrorWidget(snapshot.error.toString());
                  } else {
                    return _buildLoadingWidget();
                  }
                },
              ),
              expandedHeight: 200,
              slivers: <Widget>[
                new SliverAppBar(
                  backgroundColor: Style.Colors.mainColor,
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: new FlexibleSpaceBar(
                    title: Text(
                      movie.title!.length > 40
                        ? movie.title!.substring(0, 37) + "..."
                        : movie.title!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                    background: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original" +movie.backPoster!,
                                )
                            )
                          ),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.black.withOpacity(0.5)
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [
                                0.1,
                                0.9
                              ],
                              colors:[
                                Colors.black.withOpacity(0.9),
                                Colors.black.withOpacity(0.0)
                              ])
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding:EdgeInsets.all(0.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              movie.rating.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 5,),
                            
                            RatingBar(
                              itemSize: 10,
                                initialRating: movie.rating! / 2,
                                ratingWidget: RatingWidget(
                                  empty: Icon(
                                    EvaIcons.star,
                                    color: Style.Colors.titleColor ,
                                  ),
                                  full: Icon(
                                    EvaIcons.star,
                                    color: Style.Colors.secondColor,
                                  ),
                                  half: Icon(
                                    EvaIcons.star,
                                    color: Style.Colors.titleColor,
                                  ),
                                ),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 2),
                                onRatingUpdate: (rating){
                                  print(rating);
                                }),
                          ],
                      )),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20),
                        child: Text(
                          "OVERVIEW",
                          style: TextStyle(
                            color: Style.Colors.titleColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          movie.overview.toString(),
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MovieInfo(id: movie.id!),

                      Casts(id: movie.id!),
                      
                      SimilarMovies(id: movie.id!)

                    ]),
                  ),
                )
              ],

            );
      }),
    );
  }
 Widget _buildLoadingWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
        children: <Widget>[
          Text("Error Occured: $error"),
        ],
      ),
    );
 }

 Widget _buildVideoWidget(VideoResponse data){
  List<Video>? videos = data.videos;
  return FloatingActionButton(
    child: Icon(FontAwesomeIcons.play),
      backgroundColor: Style.Colors.secondColor,
      onPressed: (){
        Navigator.push(
          context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                controller: YoutubePlayerController(
                  initialVideoId: videos![0].key.toString(),
                  flags: YoutubePlayerFlags(
                    autoPlay:true,
                    mute: true,
                  )
                )
              )
          )
        );
      });
 }

}
