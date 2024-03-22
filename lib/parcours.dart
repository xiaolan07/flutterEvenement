import 'package:flutter/material.dart';
import 'package:flutter_dev/creationParcours.dart';

class Parcours extends StatefulWidget {
  const Parcours({super.key});

  @override
  State<Parcours> createState() => _ParcoursState();
}

class _ParcoursState extends State<Parcours> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcours'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
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
            //  itemCount: parcours.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                 // title: Text(parcours[index].nom),
                  //subtitle: Text(parcours[index].description),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

