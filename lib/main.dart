import 'package:flutter/material.dart';
import 'package:latest/Screens/LoadingScreen.dart';
import 'package:latest/Screens/homepage.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  runApp(LatestMovies());
}

class LatestMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: LoadingScreen(),
    );
  }
}


