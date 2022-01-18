
import 'package:flutter/cupertino.dart';
import 'package:mdbapp/models/cast_response.dart';
import 'package:mdbapp/repository/respository.dart';
import 'package:rxdart/rxdart.dart';


class CastsBloc{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<CastResponse> _subject = BehaviorSubject<CastResponse>(); 
  //Khởi tạo  1 Behavior có trách nhiệm thêm dữ liệu mà nó nhận được từ Repository dưới dạng CastResponse
  // và chuyển dữ liệu tới UI dưới dạng 1 stream(line 27)

  getCasts(int id) async {
    CastResponse response = await _repository.getCasts(id);
    _subject.sink.add(response); // push value in stream
  }

  void drainStream() async {
    await _subject.drain();
  }
  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }
  BehaviorSubject<CastResponse> get subject => _subject; // Lắng nghe sự thay đổi của  _subject(stream)
}
  final castsBloc = CastsBloc();
// tạo 1 biến để có thể truy cập vào CastBloc



/* BehaviorSubject tương tự như PublishSubject.
  Nó cũng cho phép gửi dữ liệu, lỗi và các sự kiện đã thực hiện đến listener,
  nhưng giá trị sau cùng đã được thêm vào subject sẽ được gửi đến các listener được thêm vào sau này.
  Nhưng sau đó, mọi sự kiện mới sẽ được gửi đến listener một cách bình thường
  */

// Cơ chế hoạt động BehaviorSubject: Lấy event cuối cùng phát ra trước đó(Sự kiện listen  trước đó)
// Kể từ lức nó listen lần thứ 2 nó sẽ lấy những event cuối cùng của những lần hoạt động trước đó.