//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_dev/service/firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/eventModel.dart';
import 'eventDetailsPage.dart';

class Evenement1 extends StatefulWidget {
  const Evenement1({Key? key}) : super(key: key);

  @override
  _Evenement1State createState() => _Evenement1State();
}

class _Evenement1State extends State<Evenement1> {
  final firestoreService = FirestoreService();
  List<EventModel> allEvents = [];
  List<EventModel> filteredEvents = [];
  String searchQuery = "";
  final TextEditingController _textEditingController = TextEditingController();
  DateTime? selectedDate;
  bool _isLoading = false;
  bool _showList = true;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    //fetchAllEventsTaux();
  }

  void _toggleView() {
    setState(() {
      _showList = !_showList;
    });
  }

  void _loadEvents() async {
    setState(() => _isLoading = true);
    var events = await firestoreService.getAllEvents();
    setState(() {
      allEvents = events;
      filteredEvents = events;
      _isLoading = false;
    });
  }

  var _currentTaux;

  final FirestoreService _firestoreService = FirestoreService();

  Future<void> fetchAllEventsTaux() async {
    Map<int, double?> fetchedTauxMap =
        await _firestoreService.getAllEventsTaux();
    setState(() {
      for (var event in allEvents) {
        event.tauxRemplissage =
            fetchedTauxMap[event.indexEvent] ?? event.tauxRemplissage;
      }
    });
  }

  void goToEventPage(EventModel event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailsPage(event: event)),
    );

    if (result == true) {
      _loadEvents();
      fetchAllEventsTaux();
    }
  }

  /*void fetchEventTaux() async {
    double? fetchedTaux =
        await _firestoreService.getTauxRemplissage(widget.event.indexEvent);
    if (fetchedTaux != null) {
      setState(() {
        _tauxPresent = fetchedTaux;
      });
    }
  }*/

  void _getByVilleAndKeywordsAndThematique(String query) {
    setState(() {
      filteredEvents = allEvents.where((event) {
        return event.adresse.toLowerCase().contains(query.toLowerCase()) ||
            event.thematiques.any((thematique) =>
                thematique.toLowerCase().contains(query.toLowerCase())) ||
            event.keywords.any((keyword) =>
                keyword.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  void _filterEventsByDate(DateTime? selectedDate) {
    if (selectedDate != null) {
      setState(() {
        filteredEvents = allEvents.where((event) {
          DateTime startDate = DateTime.parse(event.dates.first);
          DateTime endDate = DateTime.parse(event.dates.last);
          return selectedDate.isAtSameMomentAs(startDate) ||
              selectedDate.isAtSameMomentAs(endDate) ||
              (selectedDate.isAfter(startDate) &&
                  selectedDate.isBefore(endDate));
        }).toList();
      });
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Filtrer par :',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Afficher un sélecteur de date pour filtrer par date
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2010),
                      lastDate: DateTime(2025),
                    );
                    _filterEventsByDate(picked);
                    Navigator.pop(context);
                  },
                  child: Text('Date'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Afficher un dialogue pour filtrer par lieu
                    _showFilterByLocationDialog();
                  },
                  child: Text('Lieu'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Afficher un dialogue pour filtrer par thèmes
                    _showFilterByThemesDialog();
                  },
                  child: Text('Thèmes'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Afficher un dialogue pour filtrer par mots-clés
                    _showFilterByKeywordsDialog();
                  },
                  child: Text('Mots-clés'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterByLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtrer par Lieu'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                filteredEvents = allEvents.where((event) {
                  return event.adresse
                      .toLowerCase()
                      .contains(value.toLowerCase());
                }).toList();
              });
            },
            decoration: InputDecoration(
              labelText: 'Entrez le lieu',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Fermer la vue de filtrage
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterByThemesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtrer par Thème'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                filteredEvents = allEvents.where((event) {
                  return event.thematiques.any((thematique) =>
                      thematique.toLowerCase().contains(value.toLowerCase()));
                }).toList();
              });
            },
            decoration: InputDecoration(
              labelText: 'Entrez le thème',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Fermer la vue de filtrage
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterByKeywordsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtrer par Mots-clés'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                filteredEvents = allEvents.where((event) {
                  return event.keywords.any((keyword) =>
                      keyword.toLowerCase().contains(value.toLowerCase()));
                }).toList();
              });
            },
            decoration: InputDecoration(
              labelText: 'Entrez le mot-clé',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Fermer la vue de filtrage
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evenements'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      labelText: 'Rechercher par adresse',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () => _getByVilleAndKeywordsAndThematique(
                            _textEditingController.text),
                      ),
                    ),
                    onSubmitted: (value) {
                      _getByVilleAndKeywordsAndThematique(value);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterOptions();
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _toggleView,
                child: Text(_showList ? 'Voir carte' : 'Voir liste'),
              ),
            ],
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _showList
                    ? ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          EventModel event = filteredEvents[index];
                          return ListTile(
                            title: Text(
                              //'${event.titreFr} Ville: ${firestoreService.extractCityFromAddress(event.adresse)}',
                              '${event.titreFr} Ville: ${event.ville}', // Geolocalisation: ${event.geolocalisation.join(',')}
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Date: ${event.dates.isNotEmpty ? event.dates.first : "Date non disponible"}'),
                                Expanded(
                                  child: Text(
                                    event.tauxRemplissage != null &&
                                            event.tauxRemplissage > 0
                                        ? 'Taux de remplissement: ${event.tauxRemplissage}%'
                                        : 'Taux de remplissement à saisir',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              goToEventPage(event);
                            },
                          );
                        },
                      )
                    : _buildMapView(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(49.163128, -0.34709599999999996),
        zoom: 5,
      ),
      onMapCreated: (controller) {
        setState(() {
          _mapController = controller; // Initialisation du contrôleur de carte
        });
      },
      markers: _createMarkers(), // Ajouter les marqueurs à la carte
    );
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {}; // Ensemble de marqueurs à retourner

    for (EventModel event in filteredEvents) {
      // Extraire les coordonnées de géolocalisation de l'événement
      List<double> coordinates = event.geolocalisation;
      if (coordinates.length >= 2) {
        double latitude = coordinates[0];
        double longitude = coordinates[1];

        // Créer un marqueur pour chaque événement
        Marker marker = Marker(
            markerId: MarkerId(event.id
                .toString()), // Utilisation de l'ID de l'événement comme ID de marqueur
            position: LatLng(longitude, latitude),
            infoWindow: InfoWindow(
              title: event.titreFr,
              snippet: 'Date: ${event.dates.first}\nVille: ${event.ville}',
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsPage(event: event),
                  ));
            });

        markers.add(marker); // Ajouter le marqueur à l'ensemble
      }
    }

    return markers; // Retourner l'ensemble de marqueurs
  }
}
