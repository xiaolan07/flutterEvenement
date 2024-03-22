import 'package:firebase_database/firebase_database.dart';

import '../model/eventModel.dart';

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
}
