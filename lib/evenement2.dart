import 'package:flutter/material.dart';
import 'package:flutter_dev/service/firestore.dart';
import 'model/eventModel.dart';
import 'eventDetailsPage.dart';

class Evenement2 extends StatefulWidget {
  const Evenement2({Key? key}) : super(key: key);

  @override
  _Evenement2State createState() => _Evenement2State();
}

class _Evenement2State extends State<Evenement2> {
  final firestoreService = FirestoreService();
  List<EventModel> allEvents = [];
  List<EventModel> filteredEvents = [];
  String searchQuery = "";
  final TextEditingController _controller = TextEditingController();
  DateTime? selectedDate;
  String? selectedLocation;
  List<String> selectedThemes = [];
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

  void _filterEventsByTheme(String theme) {
    setState(() {
      if (selectedThemes.contains(theme)) {
        selectedThemes.remove(theme);
      } else {
        selectedThemes.add(theme);
      }
      filteredEvents = allEvents.where((event) {
        return selectedThemes.isEmpty
            ? true
            :event.adresse.toLowerCase().contains(theme.toLowerCase()); //event.descriptionFr.any((t) => selectedThemes.contains(t));
      }).toList();
    });
  }

  void _showLocationDialog() async {
    String? newLocation = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter location'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Location'),
            onChanged: (value) {
              selectedLocation = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(selectedLocation);
              },
            ),
          ],
        );
      },
    );
    if (newLocation != null) {
      setState(() {
        selectedLocation = newLocation;
        filteredEvents = allEvents.where((event) =>
            event.adresse.toLowerCase().contains(selectedLocation!.toLowerCase())
        ).toList();
      });
    }
  }

  void _showThemeDialog() async {
    List<String> themes = ["Art", "Music", "Sport", "Food"];
    List<Widget> themeWidgets = [];
    for (String theme in themes) {
      themeWidgets.add(
        ListTile(
          title: Text(theme),
          trailing: Checkbox(
            value: selectedThemes.contains(theme),
            onChanged: (value) {
              _filterEventsByTheme(theme);
            },
          ),
        ),
      );
    }
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select themes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: themeWidgets,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            child: Row(
              children: [
                Expanded(
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
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Location') {
                      _showLocationDialog();
                    } else if (value == 'Themes') {
                      _showThemeDialog();
                    } else if (value == 'Date') {
                      _selectDate(context);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Location',
                      child: Text('Location'),
                    ),
                    PopupMenuItem<String>(
                      value: 'Themes',
                      child: Text('Themes'),
                    ),
                    PopupMenuItem<String>(
                      value: 'Date',
                      child: Text('Date'),
                    ),
                  ],
                ),
              ],
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
