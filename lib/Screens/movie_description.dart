import 'package:flutter/material.dart';
import 'package:latest/Screens/LoadingScreen.dart';
import 'package:latest/Screens/LoadingScreenDescription.dart';
import 'package:latest/Screens/homepage.dart';
import 'package:latest/Screens/search.dart';
import 'package:latest/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:ui';


class MovieDescription extends StatefulWidget {
  MovieDescription({this.decodedData, this.type, this.youtubeDecodedData});
  final dynamic decodedData;
  final String type;
  final dynamic youtubeDecodedData;

  @override
  _MovieDescriptionState createState() => _MovieDescriptionState();
}

class _MovieDescriptionState extends State<MovieDescription> {
  String movieLink;
  String movieName;
  String releaseDate;
  String overview;
  String youtubeLink;
  String tmdbImageLink = 'https://image.tmdb.org/t/p/w500';
  String popularity = '0';
  double forWidget = 0.0;
  List<String> genre = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData(widget.type, widget.decodedData, widget.youtubeDecodedData);

  }


 void getData(String type, dynamic decodedData, dynamic youtubeDecodedData){

    if(type == 'movie'){
      try{
        movieLink = decodedData['poster_path'];
      }
      catch(e){
        tmdbImageLink = 'https://image.shutterstock.com/image-vector/';
        movieLink = 'unavailable-location-icon-trendy-flat-600w-1208852554.jpg';
      }
      try{
         youtubeLink = youtubeDecodedData['results'][0]['key'];
      }
      catch(e){
        youtubeLink = 'nyc6RJEEe0U';
      }

      movieName = decodedData['original_title'];
      releaseDate = decodedData['release_date'];
      overview = decodedData['overview'];
      double popular = decodedData['vote_average'];
      double inPercent = popular * 10;
      forWidget = inPercent/100;
      print(forWidget);
      popularity = inPercent.toString();
      dynamic genres1 = decodedData['genres'];
      String genres = genres1.toString();

    //  print(genres1.length);
      int i = 0;
      while(i<genres1.length){
        String allGenre = widget.decodedData['genres'][i]['name'];
        genre.add(allGenre);
        i++;

      }
      print(genre.length);
    }
    else if(type == 'tv'){
      movieLink = widget.decodedData['poster_path'];
      youtubeLink = youtubeDecodedData['results'][0]['key'];
      movieName = widget.decodedData['name'];
      releaseDate = widget.decodedData['first_air_date'];
      overview = widget.decodedData['overview'];
      double popular = decodedData['vote_average'];
      double inPercent = popular * 10;
      forWidget = inPercent/100;
      popularity = inPercent.toString();
      dynamic genres1 = widget.decodedData['genres'];
      String genres = genres1.toString();

     // print(genres1.length);
      int i = 0;
      while(i<genres1.length){
        String allGenre = widget.decodedData['genres'][i]['name'];
        genre.add(allGenre);
        i++;

      }
    }
    }






  @override
  Widget build(BuildContext context) {



    if(widget.decodedData == null){
      return Scaffold(
        body: Center(
          child: Text(
            'Loading'
          ),
        ),
      );
    }
   else{
      return Scaffold(

        appBar: AppBar(

          leading: IconButton(
          icon: Icon( Icons.arrow_back_ios),
            onPressed: (){
            Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(movieName),
          actions: [
            IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder:(context){
                      return Search();
                    }));

              },
              icon: Icon(
                  Icons.search
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(tmdbImageLink + movieLink),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),

          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[


                  Container(
                    height: 200.0,
                    color: Colors.black,
                    child: YoutubePlayer(
                        controller: YoutubePlayerController(

                            initialVideoId: youtubeLink,
                            flags: YoutubePlayerFlags(
                              autoPlay: false,
                              mute: false,
                            ),
                        ),
                        showVideoProgressIndicator: true,
                        progressColors: ProgressBarColors(playedColor: Colors.blue, handleColor: Colors.blueAccent),
                        progressIndicatorColor: Colors.blue,
                        // onReady: (){
                        //   _controller.addListener(listener);
                        // },
                      ),


                      // ),
                    //   onReady () {
                    // _controller.addListener(listener);
                    // },

                    ),

                  Container(

                    height: 100,
                    // width: 100,
                    child: Padding(
                      padding:  EdgeInsets.only(top:20.0, left: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(movieName,
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold
                              ),),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.grey.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Release Date: ' + releaseDate,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    //fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image(
                              height: 250,
                              image: NetworkImage(tmdbImageLink+ movieLink),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(left: 50.0),
                        child: Column(
                          children: [
                            Text('Popularity' ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child:  CircularPercentIndicator(
                                radius: 60.0,
                                lineWidth: 5.0,
                                percent: forWidget,
                                center:  Text(popularity+ "%"),
                                progressColor: Colors.yellow,
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Genre',style: kStyleHeadingOne),
                  ),
                  Container(
                    height: 50.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                        itemCount: genre.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Colors.grey.withOpacity(0.3),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(genre[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.0)
                              ],
                            ),
                          );}
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Story Line', style: kStyleHeadingOne),
                  ),
                  Container(
                    color: Colors.grey.withOpacity(0.4),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 8.0, bottom: 8.0),
                      child: Text(overview),
                    ),
                  ),
                  SizedBox(height: 10.0)



                ],
              ),
            ],
          ),
        ),
        ));
    }


  }
}
