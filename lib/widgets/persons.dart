import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mdbapp/bloc/get_person_bloc.dart';
import 'package:mdbapp/models/person.dart';
import 'package:mdbapp/models/person_response.dart';
import 'package:mdbapp/style/theme.dart' as Style;

class PersonsList extends StatefulWidget {
  const PersonsList({Key? key}) : super(key: key);

  @override
  _PersonsListState createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    personsBloc .. getPerSons();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:  const EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text(
            "TRENDING PERSON ON THIS WEEK",
            style: TextStyle(
              color: Style.Colors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        StreamBuilder<PersonResponse>(
            stream: personsBloc.subject.stream,
            builder: (context, AsyncSnapshot<PersonResponse> snapshot){
              if(snapshot.hasData){
                if(snapshot.data!.error != null && snapshot.data!.error!.length > 0){
                  return _buildErrorWidget(snapshot.data!.error!);
                }
                return _buildHomeWidget(snapshot.data!);
              }else if(snapshot.hasError){
                return _buildErrorWidget(snapshot.error.toString());
              }
              else {
                return _buildLoading();
              }
            })
      ],
    );
  }

  Widget _buildLoading(){
    return Center(
      child: Column(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Error occured: $error"),
        ],
      ),
    );
  }


  Widget _buildHomeWidget(PersonResponse data){
    List<Person>? persons = data.persons;
    if(persons!.length == 0){
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Text(
              "No More Persons",
              style: TextStyle(color: Colors.black45),
            )
          ],
        ),
      );
    } else {
      return Container(
        height: 150,
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: persons.length,
          itemBuilder: (context, index){
            return Container(
              padding: EdgeInsets.only(top: 10, right: 8),
              width: 100,
                child: GestureDetector(
                  onTap: (){},
                  child: Column(
                    children: <Widget>[
                      persons[index].profileImg == null
                      ? Hero(
                          tag: persons[index].id.toString(),
                          child:Container(
                            width: 70,
                            height: 70,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: Style.Colors.secondColor),
                          child: Icon(
                            FontAwesomeIcons.userAlt,
                            color: Colors.white,
                          ),
                          )
                      )
                      : Hero(
                          tag: persons[index].id.toString(),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "https://image.tmdb.org/t/p/w300" + persons[index].profileImg.toString(),
                                  )
                              )
                            ),
                          )
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        persons[index].name.toString(),
                        maxLines: 1,
                        style: TextStyle(
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Trending for " + persons[index].known.toString(),
                        maxLines: 2,
                        style: TextStyle(
                          height: 1.4,
                          color: Style.Colors.titleColor,
                          fontSize: 7,
                        ),
                      ),
                    ],
                  ),
                ),
            );
          }),
      );

    }
  }
}
