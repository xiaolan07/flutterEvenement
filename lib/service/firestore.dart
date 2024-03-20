import 'package:firebase_database/firebase_database.dart';

import '../model/eventModel.dart';

class FirestoreService {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  // TEST:  recuperer les premières 10 évenements
  Future<List<EventModel>> getAllEvents() async {
    Query allEvents = ref.limitToFirst(30);
    DatabaseEvent event = await allEvents.once();

    if (event.snapshot.exists && event.snapshot.value is List) {
      List<EventModel> events = [];
      List<dynamic> values = event.snapshot.value as List<dynamic>;
      for (var json in values.take(30)) {
        // Take the first 10 events
        events.add(EventModel.fromJson(json));
      }
      return events;
    } else {
      return [];
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
