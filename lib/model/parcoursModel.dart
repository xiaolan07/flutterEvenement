class ParcoursModel {
  String
      id; // Un identifiant unique pour le parcours, utile si vous utilisez une base de données
  String titre;
  String description;
  String pseudo;
  List<int>
      indexEvents; // Stocke les identifiants (ou titres) des événements sélectionnés

  ParcoursModel({
    this.id = '',
    required this.titre,
    required this.description,
    required this.pseudo,
    required this.indexEvents,
  });

  // Convertir un objet Parcours en Map pour faciliter l'enregistrement dans une base de données
  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'pseudo': pseudo,
      'evenementsIds': indexEvents,
    };
  }

  // Créer un objet Parcours à partir d'une Map, utile pour la lecture depuis une base de données
  factory ParcoursModel.fromJson(Map<String, dynamic> json, String id) {
    return ParcoursModel(
      id: id,
      titre: json['titre'] as String,
      description: json['description'] as String,
      pseudo: json['pseudo'] as String,
      indexEvents: List<int>.from(json['indexEvents']),
    );
  }
}
