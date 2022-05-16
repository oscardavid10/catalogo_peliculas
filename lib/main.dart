import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_page.dart';
/*
void main() {
  runApp(const MyApp());
}
 */

void main() async {
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
      home: LoginPage(),
    );
  }
}


class Administracion extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  State<Administracion> createState() => _AdministracionState();
}

class EliminarPage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  State<EliminarPage> createState() => _EliminarPage();
}



class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _EliminarPage extends State<EliminarPage>{
  final controller = TextEditingController();
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Eliminar Pelicula'),
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
    trailing: IconButton(
      icon: Icon(
        Icons.delete_outline,
        size: 20.0,
        color: Colors.white,
      ),
      onPressed: () async {
        try {
          FirebaseFirestore.instance
              .collection("catalogo")
              .doc('${movie.id}')
              .delete()
              .then((_) {
            print("success!");
          });
        }
        catch (e) {
          print("ERROR DURING DELETE");
        }
        //   _onDeleteItemPressed(index);
      },
    ),
  );


  Stream<List<Movie>> readMovies() => FirebaseFirestore.instance.collection('catalogo')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList());
}

class _MainPageState extends State<MainPage>{
  final controller = TextEditingController();
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(),));
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Administracion(),));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.black38,
                child: const Text("Administración Peliculas"),
              ),
            ),
            Expanded(child: Container()),
          InkWell(
            onTap: () async {
              setState(() {
                _isSigningOut = true;
              });
              await FirebaseAuth.instance.signOut();
              setState(() {
                _isSigningOut = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            child: Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text("Salir", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
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
    onTap: () => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieDetail(
          movie: movie,
        ),
      ),
    ),
  );


  Stream<List<Movie>> readMovies() => FirebaseFirestore.instance.collection('catalogo')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList());
}

class MovieDetail extends StatelessWidget {
  final Movie movie;

  MovieDetail({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(movie.titulo),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        child: new Image.network(
                          "${movie.imagen}",
                          height: 250.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ListTile(
                        title: Text("Año"),
                        subtitle: Text("${movie.year}"),
                      ),
                      ListTile(
                        title: Text("Director"),
                        subtitle: Text("${movie.director}"),
                      ),
                      ListTile(
                        title: Text("Genero"),
                        subtitle: Text(movie.genero),
                      ),
                      ListTile(
                        title: Text("Sinopsis"),
                        subtitle: Text("${movie.descripcion}"),
                      ),
                      ListTile(
                        title: Text("Genero"),
                        subtitle: Text("${movie.genero}"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
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
decoration: decoration('Sinopsis'),
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


final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
_signOut() async {
  await _firebaseAuth.signOut();
}

class _AdministracionState extends State<Administracion> {

  @override
  Widget build (BuildContext context) => Scaffold(
      body: new Stack(
        children: [
          SizedBox(width: 24.0),
          Container(
            width: 200,
            height: 50,
            margin: const EdgeInsets.only(top: 360, left: 100),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoviePage(),));
              },
              child: Text(
                'Agregar Pelicula',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            width: 200,
            height: 50,
            margin: const EdgeInsets.only(top: 430, left: 100),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EliminarPage(),));
              },
              child: Text(
                'Eliminar Pelicula',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      )
  );
//);
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build (BuildContext context) => Scaffold(
      body: new Stack(
        children: [
          new Container(
            width: 200,
            height: 200,
            margin: const EdgeInsets.only(top: 200, left: 100),
            child: Image.asset("images/Fondo.png"),
          ),
          new Center(
            child: new Text(
                "Bienvenidos al catálogo más grande de películas"),
          ),
          SizedBox(width: 24.0),
          Container(
            width: 200,
            height: 50,
            margin: const EdgeInsets.only(top: 450, left: 100),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage(),));
              },
              child: Text(
                'Iniciar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      )
  );
  //);
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