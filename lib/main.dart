import 'package:flutter/material.dart';
import 'package:flutter_dev/evenement.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dev/evenement1.dart';
import 'package:flutter_dev/evenement2.dart';
import 'package:flutter_dev/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/lunchbg.jpg"), fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("Welcome",
                    style: TextStyle(fontSize: 24, color: Colors.white)),
                Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Evenement1()),
                        );
                      },
                      child: const Text('Go to Second Page'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
