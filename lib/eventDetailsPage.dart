import 'package:flutter/material.dart';
import 'package:flutter_dev/service/firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'model/eventModel.dart';

class EventDetailsPage extends StatefulWidget {
  final EventModel event;

  EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  int _currentRating = 0;

  @override
  void initState() {
    super.initState();
    //print(_firestoreService.getNote(0));

    // get le update note
    fetchEventNote();
  }

  final FirestoreService _firestoreService = FirestoreService();
  void fetchEventNote() async {
    int fetchedNote = await _firestoreService.getNote(widget.event.indexEvent);
    setState(() {
      _currentRating = fetchedNote;
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();
    final bool hasMultipleDates = widget.event.dates.length > 1;
    final String datesDisplay = hasMultipleDates
        ? "De: ${widget.event.dates.first} à: ${widget.event.dates.last}"
        : "Date: ${widget.event.dates.first}";
    // TEST: setNote 2 pour idEvent 0
    //_firestoreService.setNote("0", 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.titreFr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.event.titreFr,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(widget.event.adresse)}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text(
                        "Address: ${widget.event.adresse}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      datesDisplay,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  if (widget.event.telephone != 'Pas de numéro de téléphone 😢')
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.grey),
                        SizedBox(width: 8.0),
                        InkWell(
                          onTap: () => launch('tel:${widget.event.telephone}'),
                          child: Text(
                            widget.event.telephone,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 16.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.event.imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Text('Image not available');
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.event.descriptionFr,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.event.descriptionLongue,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              const Text(
                'Partagez le lien de l article sur vos réseaux sociaux 🔥 ! ',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: SizedBox(
                      width: 32,
                      height: 32,
                      child: Image.asset('images/fb.png'),
                    ),
                    onPressed: () => _shareOnFacebook(widget.event.lien),
                  ),
                  IconButton(
                    icon: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset('images/x.png'),
                    ),
                    onPressed: () => _shareOnTwitter(widget.event.lien),
                  ),
                  IconButton(
                    icon: SizedBox(
                      width: 32,
                      height: 32,
                      child: Image.asset('images/lkdin.png'),
                    ),
                    onPressed: () => _shareOnLinkedIn(widget.event.lien),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Notez cet événement",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RatingBar.builder(
                        initialRating: _currentRating.toDouble(),
                        minRating: 1,
                        maxRating: 5,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4),
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return const Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return const Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.orange,
                              );
                            case 2:
                              return const Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return const Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return const Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.blue,
                              );
                            default:
                              return Text(widget.event.note as String);
                          }
                        },
                        onRatingUpdate: (rating) {
                          _firestoreService
                              .setNote(widget.event.indexEvent, rating.toInt())
                              .then((_) {
                            setState(() {
                              _currentRating = rating
                                  as int; // Mettre à jour l'état avec la nouvelle note

                              print("Note mise à jour avec succès.");
                            });
                          }).catchError((error) {
                            print(
                                "Erreur lors de la mise à jour de la note: $error");
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Note moyenne : ${_currentRating}/5", // Affiche la note actuelle
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _shareOnTwitter(String url) async {
  final String tweetText = "Check this out!";
  final Uri twitterUrl =
      Uri.parse('https://twitter.com/intent/tweet?text=$tweetText&url=$url');

  if (await canLaunchUrl(twitterUrl)) {
    await launchUrl(twitterUrl);
  } else {
    print('Could not launch $twitterUrl');
  }
}

void _shareOnFacebook(String url) async {
  // URL for sharing content on Facebook
  final Uri facebookUrl =
      Uri.parse('https://www.facebook.com/sharer/sharer.php?u=$url');

  // Check if this URL can be launched
  if (await canLaunchUrl(facebookUrl)) {
    await launchUrl(facebookUrl);
  } else {
    // If the URL can't be launched, you might want to show an error or a message
    print('Could not launch $facebookUrl');
  }
}

void _shareOnLinkedIn(String url) async {
  final Uri linkedInUrl =
      Uri.parse('https://www.linkedin.com/sharing/share-offsite/?url=$url');

  if (await canLaunchUrl(linkedInUrl)) {
    await launchUrl(linkedInUrl);
  } else {
    print('Could not launch $linkedInUrl');
  }
}
