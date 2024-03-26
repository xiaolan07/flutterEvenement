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

  final FirestoreService _firestoreService = FirestoreService();

  // get le nbLike modifié
  Future<void> fetchAllParcoursNbLike() async {
    Map<int, int?> fetchedNbLikeMap = await _firestoreService.getAllNbLike();
    setState(() {
      for (var parcours in allParcours) {
        parcours.nbJaime = fetchedNbLikeMap[parcours.id] ?? parcours.nbJaime;
      }
    });
  }

  // pour écouter les changements de données de nbLike, il va MAJ lors de retourner sur la page parcours
  void goToParcoursPage(ParcoursModel parcours) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ParcoursDetailsPage(parcours: parcours)),
    );
    if (result == true) {
      _loadParcours();
      fetchAllParcoursNbLike();
    }
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
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreationParcours()),
              );

              if (result == true) {
                _loadParcours(); // Recharge les données
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadParcours(); // Fonction pour recharger les données des parcours
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
          const Text(
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
                    goToParcoursPage(allParcours[index]);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(allParcours[index].titre),
                      subtitle: Text(
                        allParcours[index].description,
                        maxLines: 2, // Limite le texte à 2 lignes
                        overflow: TextOverflow
                            .ellipsis, // Ajoute des points de suspension si le texte est trop long
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Important pour s'assurer que la Row ne prend pas trop d'espace
                        children: [
                          Icon(Icons.favorite,
                              color: Colors.red), // Icône de cœur en rouge
                          SizedBox(
                              width:
                                  4), // Un petit espace entre l'icône et le nombre de "J'aime"
                          Text(
                            '${allParcours[index].nbJaime}',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ), // Le nombre de "J'aime"
                        ],
                      ),
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
