import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper2{


  Future<dynamic> getData(String id, String type, String url)async{
    if(type == 'movie'){
      http.Response response = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/' + id + url));
      if(response.statusCode == 200){
        var data = response.body;

        return jsonDecode(data);
      }
      else{
        print(response.statusCode);
      }

    }
    else if(type == 'tv'){
      http.Response response = await http.get(Uri.parse('https://api.themoviedb.org/3/tv/' + id + url));
      if(response.statusCode == 200){
        var data = response.body;

        return jsonDecode(data);
      }
      else{
        print(response.statusCode);
      }

    }

  }
}