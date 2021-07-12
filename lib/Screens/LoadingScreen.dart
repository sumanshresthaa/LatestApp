import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latest/NetworkHelper.dart';
import 'package:latest/Screens/homepage.dart';



class LoadingScreen extends StatefulWidget {

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getData() async{

    NetworkHelper networkHelper = NetworkHelper();
    var decodedDataAll = await networkHelper.getData('https://api.themoviedb.org/3/trending/all/day?api_key=27fe8aa285e6d11c8b3cf5fa638758e9');

    var decodedDataMovie = await networkHelper.getData('https://api.themoviedb.org/3/movie/popular?api_key=27fe8aa285e6d11c8b3cf5fa638758e9&language=en-US&page=1');
    var decodedDataTv = await networkHelper.getData('https://api.themoviedb.org/3/trending/tv/day?api_key=27fe8aa285e6d11c8b3cf5fa638758e9');


    Navigator.push(context, MaterialPageRoute(builder: (context){
      return HomePage(decodedDataAll, decodedDataMovie, decodedDataTv);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: Colors.teal,
      size: 100.0,
    );
  }
}
