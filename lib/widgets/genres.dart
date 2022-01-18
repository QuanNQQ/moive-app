import 'package:flutter/material.dart';
import 'package:mdbapp/bloc/get_genres_bloc.dart';
import 'package:mdbapp/models/genre.dart';
import 'package:mdbapp/models/genre_response.dart';
import 'package:mdbapp/widgets/genres_list.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);

  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genresBloc .. getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: genresBloc.subject.stream,
        builder: (context, AsyncSnapshot<GenreResponse> snapshot){
            if(snapshot.hasData){
              if(snapshot.data!.error != null && snapshot.data!.error.length > 0 ){
                return _buildErrorWidget(snapshot.data!.error);
              }
              return _buildHomeWidget(snapshot.data!);
            } else if(snapshot.hasError){
              return _buildErrorWidget(snapshot.error.toString());
            } else{
              return _buildLoadingWidget();
            }
    });
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
              strokeWidth: 4.0,
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
          Text("Error occured: $error"),
        ],
      ),
    );

  }

  Widget _buildHomeWidget(GenreResponse data){
    List<Genre>? genres = data.genres;
    print(genres);
    if(genres.length == 0){
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'No More Movie',
              style: TextStyle(
                color: Colors.black45,
              ),
            ),
          ],
        ),
      );
    }else
      return GenResList(genres: genres);
  }

}
