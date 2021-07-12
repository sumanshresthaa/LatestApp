import 'package:flutter/material.dart';
import 'package:latest/NetworkHelper.dart';
import 'package:latest/Screens/LoadingScreenSearch.dart';
import 'package:latest/Screens/homepage.dart';
import 'package:latest/Screens/searchresults.dart';
import 'dart:ui';


class Search extends StatefulWidget {

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final myController = TextEditingController();
  String currentType = 'all';


  var types = ['all','movie', 'tv'];

  DropdownButton getAndroid(){
  List<DropdownMenuItem<String>> dropDownItems = [];

  for(String type in types){
    var newItem = DropdownMenuItem(
        child: Text('${type[0].toUpperCase()}${type.substring(1)}', style: TextStyle(color: Colors.grey)),
    value: type);
    dropDownItems.add(newItem);
      }
  return DropdownButton(
      value: currentType,
      items: dropDownItems,
      onChanged: (value){
        setState(() {
          currentType = value;

        });
      },
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        leading: IconButton(
          icon: Icon( Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },

        ),
        title: Text('Search'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/list.jpg'),
              fit: BoxFit.fitHeight,
          )
        ),
        child: BackdropFilter(
          filter:  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.black.withOpacity(0.9),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal:15.0, vertical: 10.0),
                  child: getAndroid(),
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding:  EdgeInsets.only(left:8.0),
                          child: TextField(
                           controller: myController,
                            autofocus: true,
                            decoration: InputDecoration(
                             hintText: 'Search Movie/Tv Series',
                             // hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade700,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),


                           ),


                          ),
                        ),
                      ),


                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () async{
                            // Navigator.push(context, MaterialPageRoute(
                            //     builder: (context){
                            //       return LoadingScreenSearch(myController.text, currentType );
                            //     }));
                            NetworkHelper networkHelper = NetworkHelper();
                            if(currentType == 'all'){
                              var decodedDataAll = await networkHelper.getData('https://api.themoviedb.org/3/search/multi?api_key=27fe8aa285e6d11c8b3cf5fa638758e9&language=en-US&page=1&include_adult=true&query=' + myController.text);
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return SearchResults(decodedDataAll, 'all');
                              }));

                            }
                            else{
                              var decodedDataAll = await networkHelper.getData('https://api.themoviedb.org/3/search/'+ currentType + '?api_key=27fe8aa285e6d11c8b3cf5fa638758e9&language=en-US&page=1&include_adult=true&query=' + myController.text);

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return SearchResults(decodedDataAll, currentType);
                              }));
                            }

                          })
                    ],
                  ),
                ),

              ),
            ],
          ),
        ),
      ),

    );
  }
}
