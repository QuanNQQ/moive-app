import 'package:mdbapp/models/person_response.dart';
import 'package:mdbapp/repository/respository.dart';
import 'package:rxdart/rxdart.dart';

class PersonsListBloc{
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<PersonResponse> _subject = BehaviorSubject<PersonResponse>();


  getPerSons() async {
    PersonResponse response = await _repository.getPersons();
    _subject.sink.add(response);
  }

  dispose(){
    _subject.close();
  }

  BehaviorSubject<PersonResponse> get subject  => _subject;
}
final personsBloc = PersonsListBloc();