import 'package:flutter/material.dart';
import 'package:flutter_dev/model/eventModel.dart';
import 'package:flutter_dev/service/firestore.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class CreationParcours extends StatefulWidget {
  const CreationParcours({super.key});

  @override
  State<CreationParcours> createState() => _CreationParcoursState();
}

class _CreationParcoursState extends State<CreationParcours> {

  final firestoreService = FirestoreService();
  List<EventModel> allEvents = [];
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pseudoController = TextEditingController();
  final List<String> _selectedEvents = [];
  bool _isLoading = false;
  bool _titreError = false;
  bool _descriptionError = false;
  bool _pseudoError = false;



    @override
  void initState() {
    super.initState();
    _loadEvents();
  }


  void _loadEvents() async {
    setState(() => _isLoading = true);
    var events = await firestoreService.getAllEvents();
    setState(() {
      allEvents = events;
      _isLoading = false;
    });
  }

  
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Créer un parcours'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _titreController,
                          decoration: InputDecoration(
                            labelText: 'Titre',
                            border: OutlineInputBorder(),
                            errorBorder: _titreError ? const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                            ) : null,
                          ),
                          // Autres propriétés
                          maxLines: null,
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            errorBorder: _descriptionError ? const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                            ) : null,
                          ),
                          maxLines: null,
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          controller: _pseudoController,
                          decoration: InputDecoration(
                            labelText: 'Votre Pseudo',
                            border: OutlineInputBorder(),
                            errorBorder: _pseudoError ? const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                            ) : null,
                          ),
                          maxLines: null,
                        ),
                        SizedBox(height: 16.0),
                        Text('Sélectionnez les événements :'),
                        SizedBox(height: 8.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: allEvents.map((evenement) {
                            final isSelected = _selectedEvents.contains(evenement.titreFr);
                            return ChoiceChip(
                              label: Text(evenement.titreFr),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedEvents.add(evenement.titreFr);
                                  } else {
                                    _selectedEvents.remove(evenement.titreFr);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Pour bien espacer les boutons
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Vérifiez si l'un des champs est vide
                          if (_titreController.text.trim().isEmpty ||
                                _descriptionController.text.trim().isEmpty ||
                                _pseudoController.text.trim().isEmpty) {
                              // Affichez une alerte ou un message à l'utilisateur
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Erreur'),
                                    content: Text('Tous les champs doivent être remplis.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Ferme la boîte de dialogue
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                            // Tous les champs sont remplis, procédez à la sauvegarde
                            // Insérez ici la logique de sauvegarde de votre parcours
                             // La description n'est pas vide, procédez à la sauvegarde
                              // Insérez ici la logique de sauvegarde de votre parcours
                              // Exemple de sauvegarde du parcours
                              // await firestoreService.saveParcours(
                              //   _titreController.text,
                              //   _descriptionController.text,
                              //   _selectedEvents,
                              // );
                            Navigator.pop(context); // Retour à l'écran précédent après la sauvegarde
                          }
                        },
                      icon: Icon(Icons.check), // Icône de vérification
                      label: Text('Sauvegarder'),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: Colors.green, // Couleur de fond du bouton
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close), // Icône de fermeture
                      label: Text('Annuler'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Couleur de fond du bouton
                        textStyle: TextStyle(
                        color: Colors.black, // Couleur du texte
                      ),
                      ),
                    ),
                  ],
                )
              ],
            ),
    ),
  );
}

}