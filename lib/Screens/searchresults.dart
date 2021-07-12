import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:latest/Screens/LoadingScreenDescription.dart';
import 'package:latest/Screens/movie_description.dart';
import 'package:latest/Screens/search.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../NetworkHelper2.dart';


class SearchResults extends StatefulWidget {
  SearchResults(this.decodedData, this.type);
  final decodedData;
  final String type;
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {

  List<String> imageLink = [];
  List<String> movieTitle = [];
  List<String> id = [];
  List<String> rating = [];
  List<dynamic> listLength = [];
  List<String> type = [];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValues(widget.decodedData);
  }

  void getValues(dynamic decodedData){
    try{
      print(widget.type);
      listLength = decodedData['results'];
      print(listLength.length);
      int i = 0;
      while(i<listLength.length){

        String typeOfSearch = decodedData['results'][i]['media_type'];
        type.add(typeOfSearch);

        String imagePath = decodedData['results'][i]['poster_path'];
        imageLink.add(imagePath);

        int movieId = decodedData['results'][i]['id'];
        String Id = movieId.toString();
        id.add(Id);

        // double movieRating = decodedData['results'][i]['vote_average'];
        // String ratingString = movieRating.toString();
        // rating.add(ratingString);
        // print(movieRating);

        String movieName = decodedData['results'][i]['original_title'];
        if(movieName != null){
          movieTitle.add(movieName);
        }
        else{
          String anotherName = decodedData['results'][i]['original_name'];
          movieTitle.add(anotherName);
        }
        i++;


      }
   }
   catch(e){
      print('Exception fck is $e');
      movieTitle.add('No data');
      imageLink.add('No more image');
   }


  }


  @override
  Widget build(BuildContext context) {
    if(widget.decodedData == null){
      return Scaffold(
        body: Center(
          child: Text('Loading'),
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },

          ),
          title: Text('Search Results'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Search();
                }));
              },
              icon: Icon(Icons.search),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/theme.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter:  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ListView.builder(
              shrinkWrap: true,
                scrollDirection: Axis.vertical,

                itemCount: listLength.length ,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextButton(
                      onPressed: () async{
                        String movieUrlKey = '?api_key=27fe8aa285e6d11c8b3cf5fa638758e9&language=en-US';
                        String youtubeUrlKey = '/videos?api_key=27fe8aa285e6d11c8b3cf5fa638758e9&language=en-US';
                        NetworkHelper2 networkHelper2 = NetworkHelper2();
                        if(type[index] == null){
                          var decodedData = await networkHelper2.getData(id[index], widget.type, movieUrlKey);
                          var youtubeDecodedData = await networkHelper2.getData(id[index], widget.type, youtubeUrlKey);
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                          return MovieDescription(decodedData: decodedData, type: widget.type, youtubeDecodedData: youtubeDecodedData);
                        }));
                        }
                        else{
                          var decodedData = await networkHelper2.getData(id[index], type[index], movieUrlKey);
                          var youtubeDecodedData = await networkHelper2.getData(id[index], type[index], youtubeUrlKey);

                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return MovieDescription(decodedData: decodedData, type: type[index], youtubeDecodedData: youtubeDecodedData);
                          }));
                        }

                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //       return LoadingScreen2(
                        //           id: id[index], type: widget.type);
                        //     }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8.0)
                        ),

                        child: IntrinsicHeight(
                          child: Row(
                            children: [

                              imageLink[index] == null ? Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  color: Colors.grey.withOpacity(0.3),
                                  child: Center(child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:5.0, vertical: 0.0),
                                    child: Text('Image Unavailable', style: TextStyle(color: Colors.white)),
                                  )),
                                  height: 170,
                                )

                              ) :
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Image(

                                    image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500' +
                                            imageLink[index]),
                                    height: 170,
                                  width: MediaQuery.of(context).size.width*0.3),
                              ),
                              VerticalDivider(
                                color: Colors.grey.withOpacity(0.3),
                                thickness: 1.0,
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * .5,
                                // height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    movieTitle[index] == null ?
                                    Text('Title unavailable',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white)) :
                                    Text(movieTitle[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white)),
                                    // Padding(
                                    //   padding: EdgeInsets.all(10.0),
                                    //   child:  Text('TMDB: ${rating[index]} ⭐', style: TextStyle(color: Colors.white))
                                    // ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),

        ),
      );
    }
  }
}
