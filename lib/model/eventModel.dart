class EventModel {
  final String adresse;
  final List<String> dates;
  final String titreFr;
  final String descriptionFr;
  final String imageUrl;
  final List<String> thematiques;
  final List<String> keywords;
  final List<double> geolocalisation;
  final String id;
  final String ville;
  final String descriptionLongue;
  final String lien;
  final String telephone;
  final int note;
  final int indexEvent;
  final double tauxRemplissage;

  EventModel(
      {required this.adresse,
      required this.dates,
      required this.titreFr,
      required this.descriptionFr,
      required this.imageUrl,
      required this.thematiques,
      required this.keywords,
      required this.geolocalisation,
      required this.id,
      required this.ville,
      required this.descriptionLongue,
      required this.lien,
      required this.telephone,
      required this.note,
      required this.indexEvent,
      required this.tauxRemplissage});

  // Convertit une Map en une instance d'Event
  factory EventModel.fromJson(Map<dynamic, dynamic> json, int index) {
    return EventModel(
      adresse: json['adresse'] as String? ?? 'Adresse non trouvée',
      dates: List<String>.from(json['dates'] ?? []),
      titreFr: json['titre_fr'] as String? ?? 'Titre non trouvé',
      descriptionFr:
          json['description_fr'] as String? ?? 'Description non trouvée',
      imageUrl: json['image'] as String? ?? 'Image non trouvée',
      thematiques:
          List<String>.from(json['thematiques'] ?? ['Thématique non trouvée']),
      keywords: List<String>.from(json['mots_cles_fr'] ?? []),
      //geolocalisation: json['geolocalisation'] is String ? json['geolocalisation'] : 'Geolocalisation non trouvée',
      // geolocalisation : List<double>.from(json['geolocalisation'] ?? []),
      geolocalisation: (json['geolocalisation'] as Map<dynamic, dynamic>? ?? {})
          .entries
          .map((entry) => double.tryParse(entry.value.toString()) ?? 0.0)
          .toList(),
      id: json["identifiant"] as String? ?? 'Pas de id',
      ville: json["ville"] as String? ?? 'Ville non trouvée ',
      descriptionLongue: json['description_longue_fr'] as String? ?? '',
      lien: json['lien'] as String? ?? '',
      telephone: json["telephone_du_lieu"] as String? ??
          ' Pas de numero de téléphone 😢',
      note: json["note"] as int? ?? 0,
      indexEvent: index,
      tauxRemplissage: json["tauxRemplissage"] as double? ?? 0.0,
    );
  }
}
