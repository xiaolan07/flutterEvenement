import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/useless/evenement.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dev/events/evenement1.dart';
import 'package:flutter_dev/useless/evenement2.dart';
import 'package:flutter_dev/firebase_options.dart';
import 'package:flutter_dev/parcours/parcours.dart';
import 'package:provider/provider.dart';

// variable globale pour la bd de parcours
//( car dans la version gratuit, on ne peut pas créer 2 BD dans un projet)
late final FirebaseDatabase parcoursBD;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //eventsBD = FirebaseDatabase.instance;
  parcoursBD = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://parcours-e37c3-default-rtdb.firebaseio.com/',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Builder(
      builder: (BuildContext context) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/newBG1.png"), fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Spacer(flex: 8), // Prend 3 parts de l'espace disponible
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Evenement1()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, 
                          backgroundColor: Colors.black, 
                         minimumSize: Size(100, 60),
                         padding : EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                         textStyle: TextStyle(
                          fontSize: 20,
                         )
                        ),
                        child: const Text('Evenements'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Parcours()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, 
                          backgroundColor: Colors.black, 
                         minimumSize: Size(100, 60),
                         padding : EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                         textStyle: TextStyle(
                          fontSize: 20,
                         )
                        ),
                        child: const Text('Parcours'),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 1), // Prend 1 part de l'espace disponible, ajustez cette valeur si nécessaire
              ],
            ),
          ),
        );
      },
    ),
  );
}
}