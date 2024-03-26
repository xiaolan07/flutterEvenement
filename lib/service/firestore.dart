import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dev/main.dart';

import '../model/eventModel.dart';
import '../model/parcoursModel.dart';

class FirestoreService {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  // TEST:  recuperer les premières 10 évenements
  Future<List<EventModel>> getAllEvents() async {
    Query allEvents = ref.limitToFirst(30);
    DatabaseEvent eventSnapshot = await allEvents.once();

    List<EventModel> events = [];
    if (eventSnapshot.snapshot.exists && eventSnapshot.snapshot.value is List) {
      List<dynamic> eventList = eventSnapshot.snapshot.value as List<dynamic>;
      for (var i = 0; i < eventList.length; i++) {
        if (eventList[i] is Map) {
          Map<dynamic, dynamic> eventMap =
              eventList[i] as Map<dynamic, dynamic>;
          EventModel eventModel = EventModel.fromJson(
              eventMap, i); // i est utilisé comme index ici.
          events.add(eventModel);
        }
      }
    }
    return events;
  }

  Future<List<ParcoursModel>> getAllParcours() async {
    DatabaseReference ref = parcoursBD.ref();
    DatabaseEvent event = await ref.limitToFirst(30).once();
    List<ParcoursModel> parcoursList = [];

    if (event.snapshot.exists) {
      final data = event.snapshot.value;
      if (data is List) {
        for (int i = 0; i < data.length; i++) {
          var value = data[i];
          if (value is Map) {
            String id = i.toString();
            ParcoursModel parcours =
                ParcoursModel.fromJson(Map<String, dynamic>.from(value), id);
            parcoursList.add(parcours);
          }
        }
      } else {
        print("Unexpected data format. Expected a list.");
      }
    }
    return parcoursList;
  }

  Future<Map<int, double?>> getAllEventsTaux() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseEvent eventSnapshot = await ref.limitToFirst(30).once();

    Map<int, double?> eventsTaux = {};
    if (eventSnapshot.snapshot.exists && eventSnapshot.snapshot.value is Map) {
      Map<dynamic, dynamic> eventsMap =
          eventSnapshot.snapshot.value as Map<dynamic, dynamic>;
      eventsMap.forEach((key, value) {
        if (value is Map && value['tauxRemplissage'] is double) {
          int indexEvent = int.tryParse(key) ?? -1;
          double tauxRemplissage = value['tauxRemplissage'];
          eventsTaux[indexEvent] = tauxRemplissage;
        }
      });
    }
    return eventsTaux;
  }

  Future<void> incrementNbJaime(String id) async {
    final DatabaseReference parcours = parcoursBD.ref().child(id);
    // DatabaseReference parcours = ref.child(id);
    DatabaseEvent parcoursSnapshot = await parcours.child("nbJaime").once();

    if (parcoursSnapshot.snapshot.exists &&
        parcoursSnapshot.snapshot.value != null) {
      int currentLikes = parcoursSnapshot.snapshot.value as int;
      await parcours.update({
        "nbJaime": currentLikes + 1,
      });
    } else {
      await parcours.update({
        "nbJaime": 1,
      });
    }
  }

  Future<int> getNbLike(String id) async {
    final DatabaseReference parcours = parcoursBD.ref().child(id);
    // DatabaseReference parcours = ref.child(id);
    DatabaseEvent parcoursSnapshot = await parcours.child("nbJaime").once();

    if (parcoursSnapshot.snapshot.exists &&
        parcoursSnapshot.snapshot.value != null) {
      return parcoursSnapshot.snapshot.value as int;
    } else {
      return 0;
    }
  }

  Future<void> setNbLike(String id, int nbJaime) async {
    final DatabaseReference parcours = parcoursBD.ref().child(id);
    await parcours.update({
      "nbJaime": nbJaime,
    });
  }

  Future<void> setNote(int idEvent, int note) async {
    String eventId = "${idEvent}";
    DatabaseReference eventRef = FirebaseDatabase.instance.ref("/$eventId");
    print("idEvent" + eventId);
    print(note);
    // Mise à jour de la propriété 'note' pour l'événement spécifique
    await eventRef.update({
      "note": note,
    }).then((_) {
      print("Note mise à jour avec succès.");
    }).catchError((error) {
      print("Erreur lors de la mise à jour de la note: $error");
    });
  }

  Future<void> setTauxRemplissage(int idEvent, double taux) async {
    String eventId = "${idEvent}";
    DatabaseReference eventRef = FirebaseDatabase.instance.ref("/$eventId");
    // Mise à jour de la propriété 'note' pour l'événement spécifique
    await eventRef.update({
      "tauxRemplissage": taux,
    }).then((_) {
      print("Note mise à jour avec succès.");
    }).catchError((error) {
      print("Erreur lors de la mise à jour de la note: $error");
    });
  }

  Future<double> getTauxRemplissage(int idEvent) async {
    String eventId = "$idEvent";
    DatabaseReference eventRef = FirebaseDatabase.instance.ref("/$eventId");
    try {
      DatabaseEvent eventSnapshot =
          await eventRef.child("tauxRemplissage").once();
      if (eventSnapshot.snapshot.exists) {
        num? value = eventSnapshot.snapshot.value as num?;
        if (value != null) {
          double tauxRemplissage = value.toDouble();
          print("tauxRemplissage avec succès: $tauxRemplissage");
          return tauxRemplissage;
        } else {
          print("Aucune tauxRemplissage trouvée pour l'événement $eventId");
          return 0.0;
        }
      } else {
        print("Aucune tauxRemplissage trouvée pour l'événement $eventId");
        return 0.0;
      }
    } catch (error) {
      print("Erreur lors de la récupération de la tauxRemplissage: $error");
      throw Exception(
          "Erreur lors de la récupération de la tauxRemplissage: $error");
    }
  }

  Future<int> getNote(int idEvent) async {
    String eventId = "$idEvent";
    DatabaseReference eventRef = FirebaseDatabase.instance.ref("/$eventId");
    try {
      DatabaseEvent eventSnapshot = await eventRef.child("note").once();
      if (eventSnapshot.snapshot.exists) {
        int note = eventSnapshot.snapshot.value as int;
        print("Note récupérée avec succès: $note");
        return note;
      } else {
        print("Aucune note trouvée pour l'événement $eventId");
        return 0; // ou throw Exception("Aucune note trouvée pour l'événement $eventId");
      }
    } catch (error) {
      print("Erreur lors de la récupération de la note: $error");
      throw Exception("Erreur lors de la récupération de la note: $error");
    }
  }

  String extractCityFromAddress(String address) {
    // Trouver un code postal de 5 chiffres en utilisant une expression régulière
    RegExp exp = RegExp(r'(\d{5})\s*([^\d]+)$');
    RegExpMatch? match = exp.firstMatch(address);
    if (match != null && match.groupCount >= 2) {
      // Retourner la partie de la chaîne après le code postal
      // qui correspond à la ville.
      return match.group(2) ?? '';
    } else {
      return 'Ville non trouvée';
    }
  }

  Future<void> saveParcours(String titre, String description,
      List<String> selectedEvents, String pseudo, int nbJaime) async {
    final DatabaseReference parcours = parcoursBD.ref();

    // Obtenir le nombre actuel de parcours pour générer la prochaine clé
    DataSnapshot snapshot = await parcours.get();
    int nextKey = snapshot.exists ? snapshot.children.length : 0;

    // Créez un objet ParcoursModel à partir des paramètres
    final ParcoursModel parcoursMdl = ParcoursModel(
      id: nextKey.toString(),
      titre: titre,
      description: description,
      pseudo: pseudo,
      titreEvents: selectedEvents,
      nbJaime: nbJaime,
    );

    // Convertir l'objet ParcoursModel en Map
    final Map<String, dynamic> parcoursData = parcoursMdl.toMap();

    try {
      // Générer un nouvel ID pour le parcours ou utiliser un existant si vous mettez à jour un parcours
      // final newParcoursRef = database.child("parcours").push();

      // Sauvegarder les données dans votre base de données
      await parcours.child(nextKey.toString()).set(parcoursData);

      print("Parcours ajouté");
    } catch (e) {
      print("Erreur lors de l'ajout du parcours : $e");
    }
  }
}
