import 'package:dio/dio.dart';
import 'package:mdbapp/models/cast_response.dart';
import 'package:mdbapp/models/genre_response.dart';
import 'package:mdbapp/models/movie_details_response.dart';
import 'package:mdbapp/models/movie_response.dart';
import 'package:mdbapp/models/person_response.dart';
import 'package:mdbapp/models/video_response.dart';

class MovieRepository{
  final String apiKey = "26763d7bf2e94098192e629eb975dab0";
    static String mainUrl = "https://api.themoviedb.org/3";

  final Dio _dio = Dio();
  var getPopularUrl = '$mainUrl/movie/top_rated';
  var getMoviesUrl = '$mainUrl/discover/movie';
  var getPlayingUrl = '$mainUrl/movie/now_playing';
  var getGenresUrl = '$mainUrl/genre/movie/list';
  var getPersonsUrl = '$mainUrl/trending/person/week';
  var movieUrl = '$mainUrl/movie';
  var searchUrl = '$mainUrl/search/movie';

  Future<MovieResponse> getMovies() async{
    var params = {
      "api_key" : apiKey,
      "language": "en-US",
      "page":1
    };
    try {
      Response response = await _dio.get(getPopularUrl, queryParameters:params );
      return MovieResponse.fromJson(response.data);
    }catch(error, stacktrace){
      print("Exception occured: $error stackTrace: $stacktrace ");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getPlayingMovies() async{
    var params = {
      "api_key" : apiKey,
      "language": "en-US",
      "page":1
    };
    try {
      Response response = await _dio.get(getPlayingUrl, queryParameters:params );
      return MovieResponse.fromJson(response.data);
    }catch(error, stacktrace){
      print("Exception occured: $error stackTrace: $stacktrace ");
      return MovieResponse.withError("$error");
    }
  }

  Future<GenreResponse> getGenres() async{
    var params = {
      "api_key" : apiKey,
      "language": "en-US",
    };
    try {
      Response response = await _dio.get(getGenresUrl, queryParameters:params );
      return GenreResponse.fromJson(response.data);
    }catch(error, stacktrace){
      print("Exception occured: $error stackTrace: $stacktrace ");
      return GenreResponse.withError("$error");
    }
  }

  Future<PersonResponse> getPersons() async{
    var params = {
      "api_key" : apiKey,
    };
    try {
      Response response = await _dio.get(getPersonsUrl, queryParameters:params );
      return PersonResponse.fromJson(response.data);
    }catch(error, stacktrace){
      print("Exception occured: $error stackTrace: $stacktrace ");
      return PersonResponse.withError("$error");
    }
  }

  Future<MovieResponse> getMovieByGenre(int id) async{
    var params = {
      "api_key" : apiKey,
      "language": "en-US",
      "page":1,
      "with_genres": id
    };
    try {
      Response response = await _dio.get(getMoviesUrl, queryParameters:params );
      return MovieResponse.fromJson(response.data);
    }catch(error, stacktrace){
      print("Exception occured: $error stackTrace: $stacktrace ");
      return MovieResponse.withError("$error");
    }
  }

  Future<CastResponse> getCasts(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-US"
    };
    try{
      Response response = await _dio.get(movieUrl + "/$id" + "/credits", queryParameters: params);
      return CastResponse.fromJson(response.data);
    }catch(error , stacktrace){
      print("Exception occured: $error stackTrace: $stacktrace");
      return CastResponse.withError("$error");
    }
  }

  Future<MovieDetailResponse> getMovieDetail(int id) async {
    var params ={
      "api_key" : apiKey,
      "language" : "en-US",
    };
    try{
      Response response = await _dio.get(movieUrl + "/$id" , queryParameters: params);
      return MovieDetailResponse.fromJson(response.data);
    }catch(error, stacktrace){
      print("Exception occured: $error stacktrace : $stacktrace");
      return MovieDetailResponse.withError("$error");
    }
  }

  Future<VideoResponse> getMovieVideos(int id) async {
    var params= {
      "api_key": apiKey,
      "language": "en-US"
    };
    try {
      Response response = await _dio.get(movieUrl + "/$id" + "/videos", queryParameters: params);
      return VideoResponse.fromJson(response.data);
    } catch (error, stacktrace){
      print("Error Occured: $error stacktrace: $stacktrace");
      return VideoResponse.withError("$error");
    }
  }

  Future<MovieResponse> getSimilarMovies(int id) async{
    var params = {
      "api_key" : apiKey,
      "language" : "en-US",
    };
    try{
      Response response = await _dio.get(movieUrl + "/$id" +"/similar", queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch(error, stacktrace){
      print ("Error Occured: $error  stacktrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future <MovieResponse> search(String value) async {
    var params = {
      "api_key" : apiKey,
      "query" : value,
      "language" : "en-US",
    };
    try{
      Response response = await _dio.get( searchUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    }catch(error , stacktrace){
      print("Error Ocurred : $error stacktrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }
}
