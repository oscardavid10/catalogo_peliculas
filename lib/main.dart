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
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
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
            onPressed: (){
              final name = controller.text;

              createMovie(name: name);
            },
          )
        ],
      ),
    );
  }

  Future createMovie({required String name}) async {
    final docUser = FirebaseFirestore.instance.collection('catalogo').doc(
        'my-id');

    final json = {
      'name': name,
      'age': 21,
      'birthday': DateTime(2001, 7, 28),
    };

    await docUser.set(json);
  }
}
