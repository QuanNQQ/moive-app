
import 'package:flutter/cupertino.dart';
import 'package:mdbapp/models/video_response.dart';
import 'package:mdbapp/repository/respository.dart';
import 'package:rxdart/rxdart.dart';

class MovieVideosBloc{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<VideoResponse> _subject = BehaviorSubject<VideoResponse>();

  getMovieVideos(int id) async {
    VideoResponse response = await _repository.getMovieVideos(id);
    _subject.sink.add(response);
}
  void drainStream() async {
    await _subject.drain();
  }
  @mustCallSuper
  void dispose() async{
    await _subject.drain();
    _subject.close();
  }
  BehaviorSubject<VideoResponse> get subject => _subject;
}
  final movieVideoBloc = MovieVideosBloc();