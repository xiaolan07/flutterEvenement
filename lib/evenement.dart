import 'package:flutter/material.dart';
import 'package:flutter_dev/service/firestore.dart';

import 'model/eventModel.dart';
import 'eventDetailsPage.dart';

class Evenement extends StatefulWidget {
  const Evenement({Key? key}) : super(key: key);

  @override
  _EvenementState createState() => _EvenementState();
}

class _EvenementState extends State<Evenement> {
  final firestoreService = FirestoreService();
  List<EventModel> allEvents = [];
  List<EventModel> filteredEvents = [];
  String searchQuery = "";
  final TextEditingController _controller = TextEditingController();
  DateTime? selectedDate;
  bool _isLoading = false;

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
      filteredEvents = events;
      _isLoading = false;
    });
  }

  void _getByVille(String ville) {
    if (ville.isEmpty) {
      setState(() {
        filteredEvents = allEvents;
      });
    } else {
      setState(() {
        filteredEvents = allEvents.where((event) {
          return event.adresse.toLowerCase().contains(ville.toLowerCase());
        }).toList();
      });
    }
  }

  void _filterEventsByDate(DateTime selectedDate) {
    setState(() {
      filteredEvents = allEvents.where((event) {
        // CONVERTIR string to Date
        DateTime startDate = DateTime.parse(event.dates.first);
        DateTime endDate = DateTime.parse(event.dates.last);

        return selectedDate.isAtSameMomentAs(startDate) ||
            selectedDate.isAtSameMomentAs(endDate) ||
            (selectedDate.isAfter(startDate) && selectedDate.isBefore(endDate));
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _filterEventsByDate(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evenements'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search by address',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _getByVille(_controller.text),
                ),
              ),
              onSubmitted: (value) {
                _getByVille(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            // bouton pour selectionne un date
            child: ElevatedButton(
              onPressed: () => _selectDate(context), // _selectDate
              child: Text('Select Date'),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredEvents.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          EventModel event = filteredEvents[index];
                          return ListTile(
                            title: Text(
                                '${event.titreFr} Ville: ${firestoreService.extractCityFromAddress(event.adresse)}'),
                            subtitle: Text(
                                'Date: ${event.dates.isNotEmpty ? event.dates.first : 'Date non disponible'}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventDetailsPage(event: event),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : const Center(child: Text('No events found')),
          ),
        ],
      ),
    );
  }
}
