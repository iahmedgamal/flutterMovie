import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/movie_model.dart';

Future<MovieModel> fetchMovies() async {
  var queryParameters = {'api_key': '0a3f901db2f54b74f1e8aae6e7be9d33'};
  final response = await http.get(
      Uri.https('api.themoviedb.org', '/3/movie/popular', queryParameters));
  print(response.body);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return MovieModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load  Movies');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<MovieModel> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Musala Soft Movies'),
        ),
        body: Center(
          child: FutureBuilder<MovieModel>(
            future: futureMovies,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return getListView(snapshot.data.results);

                return Text(snapshot.data.results[0].toString());
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

Widget getListView(List<Results> moviesList) {
  return ListView.builder(
    itemCount: moviesList.length,
    itemBuilder: (BuildContext context, int index) {
      final movie = moviesList[index];
      //Change `addressViewCard` to accept an `NewAddressModel` object
      return movieViewCard(movie);
    },
  );
}

Widget movieViewCard(Results movie) {
  //implement based on address instead of index
  var x = movie.posterPath.toString();
  return Center(
    child: Image(
      image: NetworkImage("https://image.tmdb.org/t/p/original/$x"),
      width: double.infinity,
      fit: BoxFit.cover,
    ),
  );
}
