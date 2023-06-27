import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recommandationapp/secondpage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: _initialization,
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Hata çıktı"),
              );
            } else if (snapshot.hasData) {
              return const MyHomePage(
                title: 'Flutter  Home Page',
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _firestore = FirebaseFirestore.instance;
  var inputValue = '';

  @override
  Widget build(BuildContext context) {
    CollectionReference myData = _firestore.collection('MyData');
    var segmentRef = myData.doc('Segment');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Recommandation App'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 200.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 29, right: 29, bottom: 29),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your ID',
                ),
                onChanged: (value) {
                  setState(() {
                    inputValue = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () async {
                var response = await segmentRef.get();
                Map<String, dynamic> map =
                    response.data() as Map<String, dynamic>;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SecondPage(
                            data: inputValue,
                            segment: map[inputValue] is String
                                ? map[inputValue] as String
                                : 'Standart User',
                          )),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
