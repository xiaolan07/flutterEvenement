# fete de la science

A new Flutter project.

# Pré requis 
Pour éviter les bugs et autres erreurs de compatibilité, il est conseillé de démarrer le projet sur un émulateur Android avec une version minimale de 21. Les différentes bibliothèques, y compris Google Maps, ont été configurées pour être compatibles avec Android 21.


## Configuration de Firebase

Ce projet utilise Firebase Realtime Database pour récupérer et mettre à jour les données en temps réel. La configuration de Firebase implique deux étapes principales : la création d'un projet dans la Console Firebase et l'intégration de ce projet avec notre application Flutter.

### Création d'un projet Firebase

- Créer un projet fete-de-la-sience dans le [firebase console](https://console.firebase.google.com/u/0/project/fete-de-la-sience/database/fete-de-la-sience-default-rtdb/data)

- Importer le fichier json dans le Realtime Database

### Intégration avec une application Flutter

- Installer Firebase CLI: npm install -g firebase-tools

- Initialiser Firebase dans ce projet: firebase init

- Configurer FlutterFire: FlutterFire configure 

- Importer le package de Firebase et initialiser Firebase dans la fonction de 'main' 

- Ajouter des dépendances FlutterFire à fichier pubspec.yaml

### Fonctionnalités réalisées

* Fonctionnalités Statiques 
    - Exploration des Événements : Les utilisateurs peuvent explorer les différents événements liés à la fête de la science à travers une liste, en effectuant des recherches selon divers critères (lieu, thème, date, mots-clés) et via l'exploration d'une carte interactive.
    - Détails des Événements : Il est possible de sélectionner un événement pour afficher des informations détaillées supplémentaires via la liste ou la map.
    - Intégration avec les Fonctionnalités du Terminal : L'application est intégrée avec des fonctionnalités natives du terminal : sur adresse -> google maps , sur le numero de telephone -> composition du numero de télephone , -> sur les reseaux sociaux -> partage de l'article sur les reseaux sociaux 
 * Fonctionnalités Dynamiques 
    - Évaluation des Événements : Les utilisateurs ont la capacité d'évaluer la qualité des événements sur une échelle de 1 à 5. 
    - Création de Parcours Personnalisés : Chaque utilisateur peut créer son propre parcours, qui est un enchaînement d'événements personnalisé. Ces parcours peuvent ensuite être publiés et deviennent accessibles aux autres utilisateurs. 
    - Taux de Remplissage : Les utilisateurs ont la capacité  de définir le taux de remplissage d'un évènement
* Fonctionnalité supplémentaire 
    - Appréciation des Parcours : Une fonctionnalité a été ajoutée pour permettre aux utilisateurs de "liker" les parcours.