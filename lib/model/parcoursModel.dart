class ParcoursModel {
  String id; // Un identifiant unique pour le parcours
  String titre;
  String description;
  String pseudo;
  List<String> titreEvents; // Stocke les titres des événements sélectionnés
  int nbJaime;

  ParcoursModel({
    this.id = '',
    required this.titre,
    required this.description,
    required this.pseudo,
    required this.titreEvents,
    required this.nbJaime, 
  });

  // Convertir un objet Parcours en Map pour faciliter l'enregistrement dans une base de données
  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'titre': titre,
      'description': description,
      'pseudo': pseudo,
      'titreEvents':
          titreEvents, // Le champ doit correspondre à la structure de votre JSON
      'nbLike' : nbJaime,
    };
  }

  // Créer un objet Parcours à partir d'une Map, utile pour la lecture depuis une base de données
  factory ParcoursModel.fromJson(Map<String, dynamic> json, String id) {
    return ParcoursModel(
      id: id,
      titre: json['titre'] as String,
      description: json['description'] as String,
      pseudo: json['pseudo'] as String,
      titreEvents: List<String>.from(json['titreEvents']),
      nbJaime: json['nbJaime'] as int? ?? 0,

    );
  }
}
