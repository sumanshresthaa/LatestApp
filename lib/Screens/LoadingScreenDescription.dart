import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latest/NetworkHelper2.dart';
import 'package:latest/Screens/movie_description.dart';



class LoadingScreen2 extends StatefulWidget {
LoadingScreen2({this.id, this.type });
final String id;
   final String type;


  @override
  _LoadingScreen2State createState() => _LoadingScreen2State();
}

class _LoadingScreen2State extends State<LoadingScreen2> {


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getMovieData();

  }


void getMovieData() async{
    String movieUrlKey = '?api_key=27fe8aa285e6d11c8b3cf5fa638758e9&language=en-US';
    String tvUrl = '';
    String youtubeUrlKey = '/videos?api_key=27fe8aa285e6d11c8b3cf5fa638758e9&language=en-US';
  NetworkHelper2 networkHelper2 = NetworkHelper2();
  print(widget.id);
  var decodedData = await networkHelper2.getData(widget.id, widget.type, movieUrlKey);
  var youtubeDecodedData = await networkHelper2.getData(widget.id, widget.type, youtubeUrlKey);
  //print(widget.id);
 // print(widget.type);

    Navigator.push(context, MaterialPageRoute(builder: (context){
    return MovieDescription(decodedData: decodedData, type: widget.type, youtubeDecodedData: youtubeDecodedData);
  }));
}

 getPop(){
  return Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SpinKitChasingDots(
        color: Colors.white,
        size: 100.0,
      )
    ) ;
  }
}
