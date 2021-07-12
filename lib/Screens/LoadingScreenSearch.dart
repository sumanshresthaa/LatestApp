import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latest/NetworkHelper.dart';
import 'package:latest/Screens/homepage.dart';
import 'package:latest/Screens/search.dart';
import 'package:latest/Screens/searchresults.dart';



class LoadingScreenSearch extends StatefulWidget {
  LoadingScreenSearch(this.query, this.type);
  final String query, type;

  @override
  _LoadingScreenSearchState createState() => _LoadingScreenSearchState();
}

class _LoadingScreenSearchState extends State<LoadingScreenSearch> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(widget.query, widget.type);
  }

  Future getData(String query, String type) async{

    NetworkHelper networkHelper = NetworkHelper();
    var decodedDataAll = await networkHelper.getData('https://api.themoviedb.org/3/search/'+ type + '?api_key=27fe8aa285e6d11c8b3cf5fa638758e9&language=en-US&page=1&include_adult=true&query=' + query);

    Navigator.push(context, MaterialPageRoute(builder: (context){
      return SearchResults(decodedDataAll, type);
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
