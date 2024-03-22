class Parcours {
  String id; // Un identifiant unique pour le parcours, utile si vous utilisez une base de données
  String titre;
  String description;
  String pseudo;
  List<String> evenementsTitres; // Stocke les identifiants (ou titres) des événements sélectionnés

  Parcours({
    this.id = '',
    required this.titre,
    required this.description,
    required this.pseudo,
    required this.evenementsTitres,
  });

  // Convertir un objet Parcours en Map pour faciliter l'enregistrement dans une base de données
  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'pseudo': pseudo,
      'evenementsIds': evenementsTitres,
    };
  }

  // Créer un objet Parcours à partir d'une Map, utile pour la lecture depuis une base de données
  factory Parcours.fromMap(Map<String, dynamic> map, String documentId) {
    return Parcours(
      id: documentId, // Utiliser l'ID du document Firestore comme ID du parcours
      titre: map['titre'] as String? ?? '',
      description: map['description'] as String? ?? '',
      evenementsTitres: List<String>.from(map['evenementsTitres'] as List? ?? []),
      pseudo: map['pseudo'] as String? ?? '',
    );
  }
}
