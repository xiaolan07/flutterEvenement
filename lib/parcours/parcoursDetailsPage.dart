
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dev/model/parcoursModel.dart';

class ParcoursDetailsPage extends StatelessWidget {

   final ParcoursModel parcours;

  const ParcoursDetailsPage({Key? key, required this.parcours}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(
        title: Text(parcours.titre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(parcours.description),
            const SizedBox(height: 16),
            const Text(
              'Créé par: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text( parcours.pseudo),
            const SizedBox(height: 16),
            const Text(
              'Événements :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
             Wrap(
              spacing: 8.0, // Espace horizontal entre les chips
              runSpacing: 4.0, // Espace vertical entre les chips
              children: parcours.titreEvents.map((titreEvent) => Chip(
                label: Text(titreEvent),
                backgroundColor: Colors.lightGreenAccent,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}