import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/parcours/creationParcours.dart';
import 'package:flutter_dev/parcours/parcoursDetailsPage.dart';
import 'package:provider/provider.dart';

import '../model/parcoursModel.dart';
import '../service/firestore.dart';

class Parcours extends StatefulWidget {
  //const Parcours({super.key});
  const Parcours({Key? key}) : super(key: key);

  @override
  State<Parcours> createState() => _ParcoursState();
}

class _ParcoursState extends State<Parcours> {
  final firestoreService = FirestoreService();
  List<ParcoursModel> allParcours = [];

  @override
  void initState() {
    super.initState();
    _loadParcours();
  }

  void _loadParcours() async {
    var parcours = await firestoreService.getAllParcours();
    setState(() {
      allParcours = parcours;
    });
    print(allParcours.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parcours'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // code pour créer un nouveau parcours
               final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreationParcours()),
              );

              // Si 'result' est 'true', rechargez la liste des parcours
              if (result == true) {
                _loadParcours(); // Recharge les données
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreationParcours()),
              );

              // Si 'result' est 'true', rechargez la liste des parcours
              if (result == true) {
                _loadParcours(); // Recharge les données
              }
            },
            child: Text('Créer un parcours'),
          ),
          Text(
            'Voir tout les parcours',
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: allParcours.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Ajoutez ici la logique pour afficher les détails du parcours
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => ParcoursDetailsPage(parcours: allParcours[index]),
                      )
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(allParcours[index].titre),
                      subtitle: Text(allParcours[index].description),
                      // trailing: IconButton(
                      //   icon: Icon(Icons.favorite_border),
                      //   onPressed: () {
                      //     // Ajoutez ici la logique pour gérer le bouton "J'aime"
                      //     Color c1 = Colors.red;
                      //   },
                      // ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
