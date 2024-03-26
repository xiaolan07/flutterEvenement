import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dev/model/parcoursModel.dart';
import 'package:flutter_dev/service/firestore.dart';

class ParcoursDetailsPage extends StatefulWidget {
  final ParcoursModel parcours;

  const ParcoursDetailsPage({Key? key, required this.parcours}) : super(key: key);

  @override
  _ParcoursDetailsPageState createState() => _ParcoursDetailsPageState();
}

class _ParcoursDetailsPageState extends State<ParcoursDetailsPage> {
  bool _isLiked = false; // État initial, le bouton n'a pas encore été cliqué
  final FirestoreService _firestoreService = FirestoreService();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parcours.titre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(widget.parcours.description),
              const SizedBox(height: 16),
              const Text(
                'Créé par: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(widget.parcours.pseudo),
              const SizedBox(height: 16),
              const Text(
                'Événements :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8.0, // Espace horizontal entre les chips
                runSpacing: 4.0, // Espace vertical entre les chips
                children: widget.parcours.titreEvents.map((titreEvent) => Chip(
                  label: Text(titreEvent),
                  backgroundColor: Colors.lightGreenAccent,
                )).toList(),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isLiked = !_isLiked; // Change l'état de _isLiked à chaque clic
                    });
                    // Ajoutez ici votre logique pour le bouton J'aime
                        _firestoreService.incrementNbJaime(widget.parcours.id).then((_) {
                          // Ici, vous pouvez mettre à jour l'état local si nécessaire,
                          // par exemple pour refléter immédiatement l'incrémentation du nombre de "J'aime" dans l'UI.
                          print("Nombre de 'J'aime' incrémenté avec succès");
                        }).catchError((error) {
                          print("Erreur lors de l'incrémentation du nombre de 'J'aime': $error");
                        });
                  },
                  icon: const Icon(Icons.thumb_up), // Icone de pouce levé
                  label: const Text("J'aime ce parcours"), // Texte du bouton
                  style: ElevatedButton.styleFrom(
                    foregroundColor: _isLiked ? Colors.white : Colors.black, backgroundColor: _isLiked ? Colors.blue : Colors.white, // Assure que le texte reste lisible
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
