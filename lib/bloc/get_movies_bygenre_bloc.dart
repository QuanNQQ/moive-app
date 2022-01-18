import 'package:flutter/cupertino.dart';
import 'package:mdbapp/models/movie_response.dart';
import 'package:mdbapp/repository/respository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesListByGenreBloc{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject = BehaviorSubject<MovieResponse>();

  getMoviesByGenre(int id) async {
    MovieResponse response = await _repository.getMovieByGenre(id);
    _subject.sink.add(response);
  }
  void drainStream() async {
    await _subject.drain();
  }

  @mustCallSuper
  void disposeO() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject  => _subject;
}
final moviesByGenreBloc = MoviesListByGenreBloc();