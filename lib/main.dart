import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
/*
void main() {
  runApp(const MyApp());
}
 */

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        //primaryColor: Colors.grey,

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
      ),
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: MainPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: Drawer(
      child: Container(
        color: Colors.black12,
        child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.only(top: 50, bottom: 20),
              child: Image.asset("images/Fondo.png"),
            ),
            const Text("Menú", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage(),));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.black38,
                child: const Text("Inicio"),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage(),));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.black38,
                child: const Text("Catalago Peliculas"),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoviePage(),));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.black38,
                child: const Text("Agregar Pelicula"),
              ),
            ),
            Expanded(child: Container()),
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              color: Colors.black,
              alignment: Alignment.center,
              child: const Text("Salir", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      )
    ),
    appBar: AppBar(
      title: Text('Todas las peliculas'),
    ),
    body: StreamBuilder<List<Movie>>(
      stream: readMovies(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Text('Algo salio mal! ${snapshot.error}');
        }else if(snapshot.hasData){
          final movies = snapshot.data!;

          return ListView(
            children: movies.map(buildMovie).toList(),
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      }),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoviePage(),));
      },
    ),
  );

  Widget buildMovie(Movie movie) => ListTile(
    //leading: CircleAvatar(child: Text('${movie.year}')),
    leading: ConstrainedBox(
        constraints:
        BoxConstraints(minWidth: 100, minHeight: 100),
        child: Image.network(
          '${movie.imagen}',
          width: 100,
          height: 100,
        )),
    title: Text(movie.titulo),
    subtitle: Text(movie.descripcion),
  );


  Stream<List<Movie>> readMovies() => FirebaseFirestore.instance.collection('catalogo')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList());
}

class MoviePage extends StatefulWidget {
  //const MoviePage({Key? key}) : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage>{
  final controllerTitulo = TextEditingController();
  final controllerYear = TextEditingController();
  final controllerDescripcion = TextEditingController();
  final controllerGenero = TextEditingController();
  final controllerDirector = TextEditingController();
  final controllerImagen = TextEditingController();
@override
Widget build (BuildContext context) => Scaffold(
appBar: AppBar(
title: Text('Agregar Pelicula'),
) ,
body: ListView(
padding: EdgeInsets.all(16),
children: <Widget>[
TextField(
controller: controllerTitulo,
decoration: decoration('Titulo'),
),
const SizedBox(height: 24),
TextField(
  controller: controllerYear,
decoration: decoration('Año'),
keyboardType: TextInputType.number,
),
const SizedBox(height: 24),
TextField(
  controller: controllerDescripcion,
decoration: decoration('Descripcion'),
),
const SizedBox(height: 24),
TextField(
  controller: controllerGenero,
decoration: decoration('Genero'),
),
const SizedBox(height: 24),
TextField(
  controller: controllerDirector,
decoration: decoration('Director'),
),
const SizedBox(height: 24),
TextField(
  controller: controllerImagen,
decoration: decoration('Imagen URL'),
),
  const SizedBox(height: 32),
  ElevatedButton(
    child: Text('Agregar'),
    onPressed: (){
      final movie = Movie(
        titulo: controllerTitulo.text,
        year: int.parse(controllerYear.text),
        descripcion: controllerDescripcion.text,
        genero: controllerGenero.text,
        director: controllerDirector.text,
        imagen: controllerImagen.text,
      );

      createMovie(movie);

      Navigator.pop(context);
    },
  )
],
),
);

InputDecoration decoration(String label) => InputDecoration(
labelText: label,
border: OutlineInputBorder(),
);

  Future createMovie(Movie movie) async {
    final docMovie = FirebaseFirestore.instance.collection('catalogo').doc();
    movie.id = docMovie.id;

    final json = movie.toJson();

    await docMovie.set(json);
  }

}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(controller: controller),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              final name = controller.text;

              //createMovie(name: name);
            },
          )
        ],
      ),
    );
  }


}

class Movie {
  String id;
  final String titulo;
  final int year;
  final String descripcion;
  final String director;
  final String genero;
  final String imagen;

  Movie({
    this.id = '',
    required this.titulo,
    required this.year,
    required this.descripcion,
    required this.genero,
    required this.director,
    required this.imagen,
  });

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'titulo': titulo,
        'year': year,
        'descripcion': descripcion,
        'genero': genero,
        'director': director,
        'imagen': imagen,
      };

      static Movie fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'],
        titulo: json['titulo'],
        year: json['year'],
        descripcion: json['descripcion'],
        genero: json['genero'],
        director: json['director'],
        imagen: json['imagen'],
      );
}