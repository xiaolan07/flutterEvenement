import 'package:flutter/material.dart';
import 'package:flutter_dev/service/firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'model/eventModel.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasMultipleDates = event.dates.length > 1;
    final String datesDisplay = hasMultipleDates
        ? "De: ${event.dates.first} à: ${event.dates.last}"
        : "Date: ${event.dates.first}";

    return Scaffold(
      appBar: AppBar(
        title: Text(event.titreFr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                event.titreFr,
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
                    child: Text(
                      "Address: ${event.adresse}",
                      style: TextStyle(color: Colors.grey),
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
                  if (event.telephone != 'Pas de numéro de téléphone 😢')
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.grey),
                        SizedBox(width: 8.0),
                        InkWell(
                          onTap: () => launch('tel:${event.telephone}'),
                          child: Text(
                            event.telephone,
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
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
                  event.imageUrl,
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
                event.descriptionFr,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                event.descriptionLongue,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              const Text(
                'Partagez le lien de l article sur vos réseaux sociaux 🔥 ! ',
                style: 
                TextStyle(
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
                      onPressed: () => _shareOnFacebook(event.lien),
                  ),
                  IconButton(
                   icon: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset('images/x.png'),
                    ),
                    onPressed: () => _shareOnTwitter(event.lien),
                  ),
                  IconButton(
                    icon: SizedBox(
                      width: 32,
                      height: 32,
                      child: Image.asset('images/lkdin.png'),
                    ),
                    onPressed: () => _shareOnLinkedIn(event.lien),
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
                        initialRating: 3,
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
                              return Text("");
                          }
                        },
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Note moyenne : 3/5",
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

void _shareOnTwitter(String url) async {
  final String tweetText = "Check this out!";
  final Uri twitterUrl = Uri.parse('https://twitter.com/intent/tweet?text=$tweetText&url=$url');

  if (await canLaunchUrl(twitterUrl)) {
    await launchUrl(twitterUrl);
  } else {
    print('Could not launch $twitterUrl');
  }
}



void _shareOnFacebook(String url) async {
  // URL for sharing content on Facebook
  final Uri facebookUrl = Uri.parse('https://www.facebook.com/sharer/sharer.php?u=$url');

  // Check if this URL can be launched
  if (await canLaunchUrl(facebookUrl)) {
    await launchUrl(facebookUrl);
  } else {
    // If the URL can't be launched, you might want to show an error or a message
    print('Could not launch $facebookUrl');
  }
}


void _shareOnLinkedIn(String url) async {
  final Uri linkedInUrl = Uri.parse('https://www.linkedin.com/sharing/share-offsite/?url=$url');

  if (await canLaunchUrl(linkedInUrl)) {
    await launchUrl(linkedInUrl);
  } else {
    print('Could not launch $linkedInUrl');
  }
}


}
