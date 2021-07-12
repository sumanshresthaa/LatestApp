import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:latest/NetworkHelper.dart';
import 'package:latest/NetworkHelper2.dart';
import 'package:latest/Screens/LoadingScreenDescription.dart';
import 'package:latest/Screens/LoadingScreenSearch.dart';
import 'package:latest/Screens/browsemovie.dart';
import 'package:latest/Screens/movie_description.dart';
import 'package:latest/Screens/search.dart';
import 'package:latest/constants.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  HomePage(this.decodedDataAll,this.decodedDataMovie,this.decodedDataTv);

  final decodedDataAll, decodedDataMovie, decodedDataTv;

 // final decodedDataMovie;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NetworkHelper networkHelper = NetworkHelper();
  var imageLink, movieLink, tvLink;
  List<String> imageCopy = [];
  List<String> mediaType = [];
  List<String> allId = [];
  List<String> movieName = [];
  List<String> movieIdList = [];
  List<String> movieImages = [];
  List<String> movieOnlyName = [];
  List<String> tvName = [];
  List<String> tvId = [];
  List<String> tvImageLink = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageList();
  }

  void imageList() async {
    int i = 0;
    int j = 0;
    int k = 0;
    var decodedDataAll = widget.decodedDataAll;
    var decodedDataMovie = widget.decodedDataMovie;
    var decodedDataTv = widget.decodedDataTv;
    imageLink = decodedDataAll['results'];
    movieLink = decodedDataMovie['results'];
    tvLink = decodedDataTv['results'];
    while(j<movieLink.length){
       int movieId = decodedDataMovie['results'][j]['id'];
       String movieIdString = movieId.toString();
       movieIdList.add(movieIdString);

    String movieImage = decodedDataMovie['results'][j]['poster_path'];
     movieImages.add(movieImage);
    String movieOnlyTitle = decodedDataMovie['results'][j]['original_title'];
    movieOnlyName.add(movieOnlyTitle);
    j++;
    }
    while (i < imageLink.length) {
      int allIds = decodedDataAll['results'][i]['id'];
      String allListId = allIds.toString();
      allId.add(allListId);
      String type = decodedDataAll['results'][i]['media_type'];
       mediaType.add(type);

      String images = decodedDataAll['results'][i]['poster_path'];
      imageCopy.add(images);
      try {
        String name = decodedDataAll['results'][i]['title'];
        if (name != null) {
          movieName.add(name);
        } else {
          String anotherName = decodedDataAll['results'][i]['original_name'];
          movieName.add(anotherName);
        }
      } catch (e) {
        print(e);
      }
      i++;
    }
    while(k<tvLink.length){
      String tvTitle = decodedDataTv['results'][k]['name'];
      tvName.add(tvTitle);
      String tvImageLinks = decodedDataTv['results'][k]['poster_path'];
      tvImageLink.add(tvImageLinks);
      int tvIds = decodedDataTv['results'][k]['id'];
      String stringTvId = tvIds.toString();
      tvId.add(stringTvId);

      k++;
    }
  }

  @override
  Widget build(BuildContext context) {

    void fetchData(var id, int index,  var mediaType) async{
      String movieUrlKey = '?api_key=27fe8aa285e6d11c8b3cf5fa638758e9&language=en-US';
      String youtubeUrlKey = '/videos?api_key=27fe8aa285e6d11c8b3cf5fa638758e9&language=en-US';
      NetworkHelper2 networkHelper2 = NetworkHelper2();
      var decodedData = await networkHelper2.getData(id[index], mediaType, movieUrlKey);
      var youtubeDecodedData = await networkHelper2.getData(id[index], mediaType, youtubeUrlKey);

      Navigator.push(context, MaterialPageRoute(builder: (context){
        return MovieDescription(decodedData: decodedData, type: mediaType, youtubeDecodedData: youtubeDecodedData);
      }));
    }

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Center(child: Text('Watch Movies & TV Series', style: kStyleName)),
            ),
            ListTile(
              title: Text('Browse Movies'),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) {
                 return BrowseMovies();
               }));
              },
            ),
            ListTile(
              title: Text('Search'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Search();
                }));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Home'),
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
            image: AssetImage("assets/theme.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter:  ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),

          child: ListView(
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('Top Trending', style: kStyleHeadingOne),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 12),
                              height:  MediaQuery.of(context).size.height*0.7,
                              child: Swiper(
                                autoplay: true,
                                autoplayDelay: 2500,
                                curve: Curves.easeIn,
                                itemCount: imageLink.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TextButton(
                                    onPressed: () {
                                     fetchData(allId, index , mediaType[index]);
                                      // Navigator.push(context, MaterialPageRoute(builder: (context){
                                      //   return LoadingScreen2(id: allId[index], type: mediaType[index]);
                                      //
                                      // }));
                                      // print(allId[index]);
                                      // print(mediaType[index]);
                                    },
                                    child: Container(
                                     // height: MediaQuery.of(context).size.height*2,

                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image(
                                                  image: NetworkImage(
                                                      'https://image.tmdb.org/t/p/w500' +
                                                          imageCopy[index]),
                                                  semanticLabel: 'Top Trending',
                                                  //height: 200,
                                                  width: 400.0,
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                          SizedBox(height: 30.0),
                                          Container(
                                            width: 80,
                                            height: 60,
                                            child: Text(movieName[index],
                                                textAlign: TextAlign.center,
                                                style: kStyleName.copyWith(color: Colors.white)),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                viewportFraction: 0.8,
                                scale: 0.9,
                                //pagination: SwiperPagination(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('Trending Movies', style: kStyleHeadingOne),
                      ),
                      Container(
                        height: 260.0,
                        color: Colors.white.withOpacity(0.1),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: movieIdList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: TextButton(
                                  onPressed: () {
                                    fetchData(movieIdList, index , 'movie');
                                    // Navigator.push(context,
                                    //     MaterialPageRoute(builder: (context) {
                                    //   return LoadingScreen2(id: movieIdList[index], type: 'movie');
                                    // }));
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image(
                                              image: NetworkImage(
                                                  'https://image.tmdb.org/t/p/w500' +
                                                      movieImages[index]),
                                              height: 170),
                                        ),
                                      ),
                                      Container(
                                        width: 72,
                                        height: 50,
                                        child: Text(movieOnlyName[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white)),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 15.0, left: 15.0),
                        child: Text('Trending TV Series', style: kStyleHeadingOne),
                      ),
                      Container(
                        height: 260.0,

                        color: Colors.white.withOpacity(0.1),
                        child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: tvLink.length,
                                itemBuilder: (BuildContext context, int index){
                                  return TextButton(
                                    onPressed: (){
                                      fetchData(tvId ,index , 'tv');
                                      // Navigator.push(context, MaterialPageRoute(
                                      //     builder: (context){
                                      //       return LoadingScreen2(id: tvId[index], type: 'tv');
                                      //     }));
                                    },
                                    child: Column(
                                      children:[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image(
                                              image: NetworkImage('https://image.tmdb.org/t/p/w500' + tvImageLink[index]),
                                              height: 170.0,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 72,
                                          height: 50,
                                          child: Text(tvName[index],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),),
                                        )
                                      ]
                                    ),
                                  );
                            }),
                      )

                    ],
                  ),

              ],
            ),
        ),
      ),

    );
  }
}
