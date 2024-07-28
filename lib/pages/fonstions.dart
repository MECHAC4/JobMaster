import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:open_file/open_file.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'cv_marker.dart';
import 'mo_letter_creater.dart';
import 'de_letter_creator.dart';
import 'dowload.dart';

double pourcent(double value, double pourcentage) {
  return value * pourcentage / 100;
}

void cvMarkerFunction(BuildContext context, int index) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CvMarker(index: index),
      ));
}

void moLetterCreatorFunction(BuildContext context, int indexi) {
  Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeftJoined,
          child:  MoLetterCreator(index: indexi,))
      );
}

void deLetterCreatorFunction(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DeLetterCreator(),
      ));
}

void dowloadFunction(BuildContext context, int initialIndex) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Dowload(initialIndex: initialIndex),
      ));
}

void infoPersoFunction(BuildContext context, int index) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) =>
        PersonnalInformation(index: index),
  );
}

void objectifProFunction(BuildContext context, int index) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProObjectif(index: index),));
}

void experienceProFunction(BuildContext context, int index) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProExperience(index: index),));
}

void educationFunction(BuildContext context, int index) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Education(index: index),));
}

void certificationFunction(BuildContext context, int index) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Certification(index: index),));
}

void expCompetenceFunction(BuildContext context, int index) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpCompetence(index: index),));
}

void langueMaitFunction(BuildContext context, int index) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LangueMait(index: index),));
}

void centreInteretFunction(BuildContext context, int index) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CentreInteret(index: index),));
}

void referenceProFunction(BuildContext context, int index) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProReference(
    index: index,
  ),));
}

void uploaderImageFunction() {}

void validateFormulaireFunction(BuildContext context, int index) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => CvMarker(index: index),
  ));
}

Future<void> saveAsFile(final BuildContext context, final LayoutCallback build,
    final PdfPageFormat pageFormat) async {
   await showRatingDialog(context);
  final bytes = await build(pageFormat);
  final appDocDir = await getDownloadsDirectory();
  final appDocDirPath = appDocDir?.path;
  final file = File('$appDocDirPath/cv.pdf');
  await file.writeAsBytes(bytes);
  await OpenFile.open('$appDocDirPath/cv.pdf');
}


Future<void> saveAsLFile(final BuildContext context, final LayoutCallback build,
    final PdfPageFormat pageFormat) async {
  await showRatingDialog(context);
  final bytes = await build(pageFormat);
  final appDocDir = await getDownloadsDirectory();
  final appDocDirPath = appDocDir?.path;
  final file = File('$appDocDirPath/lettre.pdf');
  await file.writeAsBytes(bytes);
  await OpenFile.open('$appDocDirPath/lettre.pdf');
}


void showPrinted(final BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Impression du CV")));
}

void showShared(final BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Partage du CV")));
}


void showLPrinted(final BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Impression de la lettre")));
}

void showLShared(final BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Partage de la lettre")));
}

String splitString(String text, int tailleMax, int startSpace) {
  String textFormate = '';
  int counter = 0;
  for (int i = 0; i < text.length; i++) {
    textFormate = textFormate + text[i];
    counter = counter + 1;
    if (counter == tailleMax) {
      textFormate = '$textFormate\n${(' ') * startSpace}';
      counter = 0;
    }
  }
  return textFormate;
}


double lengthName( String name){
  double height = 100;
  height = 100 + 20*name.length% 16;
  return height;
}


Future<void> showRatingDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) =>
        RatingDialog(
          force: true,
          starSize: MediaQuery
              .of(context)
              .size
              .width / 17,
          title: const Text(
            'Évaluez-nous',
            textAlign: TextAlign.center,
          ),
          message: const Text(
            'Notez notre application',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          image: const Image(
            image: AssetImage("lib/Assets/Images/ic_launcher.png"),
            // Remplacez par le chemin de votre logo
            height: 100,
          ),
          submitButtonText: 'Soumettre',
          onSubmitted: (response) async {
            if (response.rating >= 3) {
              const url =
                  'https://play.google.com/store/apps/details?id=com.jline.job_master';
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url);
              } else {
                throw 'Impossible d\'ouvrir $url';
              }
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
  );
}


void loadInterAd() {
  const adUnitInterId = 'ca-app-pub-7533781313698535/3962797675';
  InterstitialAd.load(
      adUnitId: adUnitInterId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ));
}


