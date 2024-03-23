import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/creationParcours.dart';
import 'package:provider/provider.dart';

import 'model/parcoursModel.dart';
import 'service/firestore.dart';

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
            onPressed: () {
              // code pour créer un nouveau parcours
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Ajoutez ici le code pour créer un nouveau parcours
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreationParcours()),
              );
            },
            child: Text('Créer un parcours'),
          ),
          Text('Voir tous les parcours'),
          Expanded(
            child: ListView.builder(
              itemCount: allParcours.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(allParcours[index].id),
                  title: Text(allParcours[index].titre),
                  subtitle: Text(allParcours[index].pseudo),
                  trailing: Text(allParcours[index].indexEvents.join(", ")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
