import 'dart:io';
import 'dart:math';
import 'package:date_field/date_field.dart'
    show DateTimeFormField, DateTimeFieldPickerMode;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Uint8List, ByteData, rootBundle;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart'
    show ImagePicker, ImageSource, XFile;
import 'package:job_master/pages/form_tamplate.dart';
import 'package:page_transition/page_transition.dart'
    show PageTransitionType, PageTransition;
import 'package:pdf/pdf.dart' show PdfColor, PdfColors, PdfPageFormat;
import 'package:sqflite/sqflite.dart';
import 'dowload.dart';
import 'fonstions.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'
    show PdfPreview, Printing, PdfPreviewAction, PrintingInfo;

class CvMarker extends StatefulWidget {
  final int index;

  const CvMarker({required this.index, super.key});

  @override
  State<CvMarker> createState() => _CvMarkerState();
}

class _CvMarkerState extends State<CvMarker> with RouteAware {
  late int index;
  List<bool> isValidate = [];
  List<Map<String, dynamic>> infoPersoList = [];
  List<Map<String, dynamic>> proObjectif = [];
  List<Map<String, dynamic>> proExperience = [];
  List<Map<String, dynamic>> education = [];
  List<Map<String, dynamic>> certification = [];
  List<Map<String, dynamic>> compExp = [];
  List<Map<String, dynamic>> langueMait = [];
  List<Map<String, dynamic>> centreInteret = [];
  List<Map<String, dynamic>> referencePro = [];
  Map<String, dynamic> infoPerso = {};

  Future<void> loadInfo() async {
    infoPersoList = await DataManager(index: index).initInfoPersoDatabase();
    proObjectif = await DataManager(index: index).initProObjectifDatabase();
    proExperience = await DataManager(index: index).initProExperienceDatabase();
    education = await DataManager(index: index).initEducationDatabase();
    certification = await DataManager(index: index).initCertificationDatabase();
    compExp = await DataManager(index: index).initCompetenceDatabase();
    langueMait = await DataManager(index: index).initLangueDatabase();
    centreInteret = await DataManager(index: index).initDatabase();
    referencePro = await DataManager(index: index).initDatabaseref();
    infoPersoList.isNotEmpty ? infoPerso = infoPersoList.last : null;
    setState(() {
      isValidate = [
        infoPerso.isNotEmpty ? true : false,
        proObjectif.isNotEmpty ? true : false,
        proExperience.isNotEmpty ? true : false,
        education.isNotEmpty ? true : false,
        certification.isNotEmpty ? true : false,
        compExp.isNotEmpty ? true : false,
        langueMait.isNotEmpty ? true : false,
        centreInteret.isNotEmpty ? true : false,
        referencePro.isNotEmpty ? true : false,
      ];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isValidate = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ];
    index = widget.index;
    loadInfo();
    setState(() {
      loadBannerAd1();
      loadBannerAd2();
      loadBannerAd3();
    });
  }

  BannerAd? _bannerAd1;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId1 = 'ca-app-pub-7533781313698535/3078509382';

  /// Loads a banner ad.
  void loadBannerAd1() {
    _bannerAd1 = BannerAd(
      adUnitId: adUnitId1,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            isBanner1Loaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  BannerAd? _bannerAd2;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId2 = 'ca-app-pub-7533781313698535/3052926711';

  /// Loads a banner ad.
  void loadBannerAd2() {
    _bannerAd2 = BannerAd(
      adUnitId: adUnitId2,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            isBanner2Loaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  BannerAd? _bannerAd3;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId3 = 'ca-app-pub-7533781313698535/9324382092';
  bool isBanner3Loaded = false;
  bool isBanner2Loaded = false;
  bool isBanner1Loaded = false;

  /// Loads a banner ad.
  void loadBannerAd3() {
    _bannerAd3 = BannerAd(
      adUnitId: adUnitId3,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            isBanner3Loaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void didPop() {
    // TODO: implement didPop
    super.didPop();
    initState();
  }

  InterstitialAd? _interstitialAd;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitInterId = 'ca-app-pub-7533781313698535/1557439261';

  /// Loads an interstitial ad.
  void loadInterAd() {
    InterstitialAd.load(
        adUnitId: adUnitInterId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    int indexi = index;

    final width = MediaQuery.of(context).size.width;
    final titleFontSize = pourcent(width, 10);
    List<String> title = [
      "Informations Personnelles",
      "Objectifs Professionnel",
      "Expérience professionnelle",
      "Education",
      "Certifications",
      "Compétences et Expertises",
      "Langues Maîtrisées",
      "Centres d'intérêt",
      "Références Professionnelles",
    ];
    List<String> subtitle = [
      "Profil personnel",
      "Ambitions de Carrière",
      "Parcours Professionnel",
      "Historique Scolaire",
      "Cours et Certifications",
      "Compétence Clés",
      "Compétences Linguistiques",
      "Loisirs et Intérêt",
      "Contacts Professionnels",
    ];
    List<String> leadingImageUrl = [
      "lib/Assets/Images/personnalInformation.jfif",
      "lib/Assets/Images/objectif.png",
      "lib/Assets/Images/experienceIcon.png",
      "lib/Assets/Images/educationIcon.png",
      "lib/Assets/Images/certification.png",
      "lib/Assets/Images/competences.png",
      "lib/Assets/Images/langages.jfif",
      "lib/Assets/Images/interest.png",
      "lib/Assets/Images/reference.jfif",
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
            size: 28,
          ),
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: const Dowload(initialIndex: 0),
                    type: PageTransitionType.bottomToTop,
                    duration: const Duration(seconds: 1)));
          },
        ),
        centerTitle: true,
        title: Text(
          "Créer un CV",
          style: TextStyle(fontSize: titleFontSize, color: Colors.green),
        ),
        backgroundColor: Colors.black12,
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              infoPersoFunction(context, indexi);
            },
            child: Card(
              color: Colors.white54,
              elevation: 5,
              child: Container(
                padding:
                    const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    title[0],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle[0],
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(right: pourcent(width, 5)),
                    child: Image(
                        image: AssetImage(leadingImageUrl[0]),
                        width: pourcent(width, 12)),
                  ),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: isValidate[0] ? 1 : 0,
                        strokeWidth: 5,
                        color: Colors.blue,
                        backgroundColor: Colors.blueGrey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      if (isValidate[0])
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.blue,
                        ),
                      if (!isValidate[0])
                        const Icon(
                          Icons.edit_off_rounded,
                          color: Colors.blueGrey,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              objectifProFunction(context, indexi);
            },
            child: Card(
              color: Colors.white54,
              elevation: 5,
              child: Container(
                padding:
                    const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    title[1],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle[1],
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(right: pourcent(width, 5)),
                    child: Image(
                        image: AssetImage(leadingImageUrl[1]),
                        width: pourcent(width, 12)),
                  ),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: isValidate[1] ? 1 : 0,
                        strokeWidth: 5,
                        color: Colors.blue,
                        backgroundColor: Colors.blueGrey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      if (isValidate[1])
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.blue,
                        ),
                      if (!isValidate[1])
                        const Icon(
                          Icons.edit_off_rounded,
                          color: Colors.blueGrey,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              experienceProFunction(context, indexi);
            },
            child: Card(
              color: Colors.white54,
              elevation: 5,
              child: Container(
                padding:
                    const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    title[2],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle[2],
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(right: pourcent(width, 5)),
                    child: Image(
                        image: AssetImage(leadingImageUrl[2]),
                        width: pourcent(width, 12)),
                  ),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: isValidate[2] ? 1 : 0,
                        strokeWidth: 5,
                        color: Colors.blue,
                        backgroundColor: Colors.blueGrey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      if (isValidate[2])
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.blue,
                        ),
                      if (!isValidate[2])
                        const Icon(
                          Icons.edit_off_rounded,
                          color: Colors.blueGrey,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_bannerAd1 != null && isBanner1Loaded)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SizedBox(
                  width: _bannerAd1!.size.width.toDouble(),
                  height: _bannerAd1!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd1!),
                ),
              ),
            ),
          GestureDetector(
            onTap: () {
              educationFunction(context, indexi);
            },
            child: Card(
              color: Colors.white54,
              elevation: 5,
              child: Container(
                padding:
                    const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    title[3],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle[3],
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(right: pourcent(width, 5)),
                    child: Image(
                        image: AssetImage(leadingImageUrl[3]),
                        width: pourcent(width, 12)),
                  ),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: isValidate[3] ? 1 : 0,
                        strokeWidth: 5,
                        color: Colors.blue,
                        backgroundColor: Colors.blueGrey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      if (isValidate[3])
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.blue,
                        ),
                      if (!isValidate[3])
                        const Icon(
                          Icons.edit_off_rounded,
                          color: Colors.blueGrey,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              certificationFunction(context, indexi);
            },
            child: Card(
              color: Colors.white54,
              elevation: 5,
              child: Container(
                padding:
                    const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    title[4],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle[4],
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(right: pourcent(width, 5)),
                    child: Image(
                        image: AssetImage(leadingImageUrl[4]),
                        width: pourcent(width, 12)),
                  ),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: isValidate[4] ? 1 : 0,
                        strokeWidth: 5,
                        color: Colors.blue,
                        backgroundColor: Colors.blueGrey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      if (isValidate[4])
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.blue,
                        ),
                      if (!isValidate[4])
                        const Icon(
                          Icons.edit_off_rounded,
                          color: Colors.blueGrey,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              expCompetenceFunction(context, indexi);
            },
            child: Card(
              color: Colors.white54,
              elevation: 5,
              child: Container(
                padding:
                    const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    title[5],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle[5],
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(right: pourcent(width, 5)),
                    child: Image(
                        image: AssetImage(leadingImageUrl[5]),
                        width: pourcent(width, 12)),
                  ),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: isValidate[5] ? 1 : 0,
                        strokeWidth: 5,
                        color: Colors.blue,
                        backgroundColor: Colors.blueGrey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      if (isValidate[5])
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.blue,
                        ),
                      if (!isValidate[5])
                        const Icon(
                          Icons.edit_off_rounded,
                          color: Colors.blueGrey,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_bannerAd2 != null && isBanner2Loaded)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SizedBox(
                  width: _bannerAd2!.size.width.toDouble(),
                  height: _bannerAd2!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd2!),
                ),
              ),
            ),
          GestureDetector(
            onTap: () {
              langueMaitFunction(context, indexi);
            },
            child: Card(
              color: Colors.white54,
              elevation: 5,
              child: Container(
                padding:
                    const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    title[6],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle[6],
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(right: pourcent(width, 5)),
                    child: Image(
                        image: AssetImage(leadingImageUrl[6]),
                        width: pourcent(width, 12)),
                  ),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: isValidate[6] ? 1 : 0,
                        strokeWidth: 5,
                        color: Colors.blue,
                        backgroundColor: Colors.blueGrey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      if (isValidate[6])
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.blue,
                        ),
                      if (!isValidate[6])
                        const Icon(
                          Icons.edit_off_rounded,
                          color: Colors.blueGrey,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              centreInteretFunction(context, indexi);
            },
            child: Card(
              color: Colors.white54,
              elevation: 5,
              child: Container(
                padding:
                    const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    title[7],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle[7],
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(right: pourcent(width, 5)),
                    child: Image(
                        image: AssetImage(leadingImageUrl[7]),
                        width: pourcent(width, 12)),
                  ),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: isValidate[7] ? 1 : 0,
                        strokeWidth: 5,
                        color: Colors.blue,
                        backgroundColor: Colors.blueGrey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      if (isValidate[7])
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.blue,
                        ),
                      if (!isValidate[7])
                        const Icon(
                          Icons.edit_off_rounded,
                          color: Colors.blueGrey,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              referenceProFunction(context, indexi);
            },
            child: Card(
              color: Colors.white54,
              elevation: 5,
              child: Container(
                padding:
                    const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    title[8],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle[8],
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(right: pourcent(width, 5)),
                    child: Image(
                        image: AssetImage(leadingImageUrl[8]),
                        width: pourcent(width, 12)),
                  ),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: isValidate[8] ? 1 : 0,
                        strokeWidth: 5,
                        color: Colors.blue,
                        backgroundColor: Colors.blueGrey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      if (isValidate[8])
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.blue,
                        ),
                      if (!isValidate[8])
                        const Icon(
                          Icons.edit_off_rounded,
                          color: Colors.blueGrey,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_bannerAd3 != null && isBanner3Loaded)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SizedBox(
                  width: _bannerAd3!.size.width.toDouble(),
                  height: _bannerAd3!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd3!),
                ),
              ),
            ),
        ],
      ),

      /*ListView.builder(
        itemCount: title.length,
        itemBuilder: (context, index) {
          /*List<String> bannerId = [
            'ca-app-pub-7533781313698535/3078509382',
            'ca-app-pub-7533781313698535/3052926711',
            'ca-app-pub-7533781313698535/9324382092'
          ];*/

          return GestureDetector(
            onTap: () {
              switch (index) {
                case 0:
                  infoPersoFunction(context, indexi);
                  break;
                case 1:
                  objectifProFunction(context, indexi);
                  break;
                case 2:
                  experienceProFunction(context, indexi);
                  break;
                case 3:
                  educationFunction(context, indexi);
                  break;
                case 4:
                  certificationFunction(context, indexi);
                  break;
                case 5:
                  expCompetenceFunction(context, indexi);
                  break;
                case 6:
                  langueMaitFunction(context, indexi);
                  break;
                case 7:
                  centreInteretFunction(context, indexi);
                  break;
                case 8:
                  referenceProFunction(context, indexi);
                  break;
              }
            },
            child: Card(
              color: Colors.white54,
              elevation: 5,
              child: Container(
                padding:
                const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    title[index],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle[index],
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(right: pourcent(width, 5)),
                    child: Image(
                        image: AssetImage(leadingImageUrl[index]),
                        width: pourcent(width, 12)),
                  ),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: isValidate[index] ? 1 : 0,
                        strokeWidth: 5,
                        color: Colors.blue,
                        backgroundColor: Colors.blueGrey,
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      if (isValidate[index])
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.blue,
                        ),
                      if (!isValidate[index])
                        const Icon(
                          Icons.edit_off_rounded,
                          color: Colors.blueGrey,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),*/
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        elevation: 100,
        onPressed: () {
          loadInterAd();
          _interstitialAd?.show();
          showGeneralDialog(
            context: context,
            pageBuilder: (context, animation, secondaryAnimation) =>
                FormTamplateClass(
              index: index,
              utilite: 0,
            ),
          );
        },
        child: const Text("Voir votre CV",
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }
}

class PersonnalInformation extends StatefulWidget {
  final int index;

  const PersonnalInformation({required this.index, super.key});

  @override
  State<PersonnalInformation> createState() => PersonnalInformationState();
}

class PersonnalInformationState extends State<PersonnalInformation> {
  late int index;

  late DateTime dateNaissance;
  String curentSexe = "Masculin";
  XFile? image;
  Uint8List? imageFile;
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nationnaliteController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController situationMatrimonialeController =
      TextEditingController();
  final TextEditingController titreController = TextEditingController();
  final TextEditingController profilController = TextEditingController();
  List<Map<String, dynamic>> personalInfoList = [];
  final _formKey = GlobalKey<FormState>();
  late int indexi;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    indexi = index;
    setState(() {
      _initDatabase();
    });
  }

  Future<void> _initDatabase() async {
    final listInfo = await DataManager(index: indexi).initInfoPersoDatabase();
    if (listInfo.isNotEmpty) {
      personalInfoList.addAll(listInfo);
    }

    if (personalInfoList.isNotEmpty) {
      final index = personalInfoList.length - 1;
      setState(() {
        nomController.text = personalInfoList[index]['nom'] as String;
        prenomController.text = personalInfoList[index]['prenom'] as String;
        nationnaliteController.text =
            personalInfoList[index]['nationalite'] ?? ' ';
        titreController.text = personalInfoList[index]['titre'] ?? '';
        profilController.text = personalInfoList[index]['profil'] ?? '';
        adresseController.text = personalInfoList[index]['adresse'] ?? ' ';
        telephoneController.text = personalInfoList[index]['telephone'] ?? ' ';
        emailController.text = personalInfoList[index]['email'] ?? ' ';
        situationMatrimonialeController.text =
            personalInfoList[index]['situationMatrimoniale'] ?? ' ';
        curentSexe = personalInfoList[index]['sexe'] ?? ' ';
        dateNaissance =
            DateTime.parse(personalInfoList[index]['dateNaissance']);
        // Charger l'image depuis la base de données (exemple utilisant Uint8List)
        List<int>? imageBytes = personalInfoList[index]['image'] as List<int>?;
        if (imageBytes != null) {
          imageFile = Uint8List.fromList(imageBytes);
        }
      });
    } else {
      setState(() {
        nomController.text = '';
        prenomController.text = '';
        nationnaliteController.text = '';
        titreController.text = '';
        profilController.text = '';
        adresseController.text = '';
        telephoneController.text = '';
        emailController.text = '';
        situationMatrimonialeController.text = '';
        dateNaissance = DateTime.now();
      });
    }
  }

  Future<void> _savePersonalInformation() async {
    final listbyte = imageFile?.toList();
    final personalInfo = {
      'nom': nomController.text,
      'prenom': prenomController.text,
      'profil': profilController.text,
      'titre': titreController.text,
      'dateNaissance': dateNaissance.toString(),
      'nationalite': nationnaliteController.text,
      'sexe': curentSexe,
      'adresse': adresseController.text,
      'telephone': telephoneController.text,
      'email': emailController.text,
      'situationMatrimoniale': situationMatrimonialeController.text,
      'image': listbyte ?? [],
    };
    personalInfoList.add(personalInfo);
    DataManager(index: indexi).savePersonalInformation(
        nomController.text,
        prenomController.text,
        dateNaissance.toString(),
        titreController.text,
        profilController.text,
        nationnaliteController.text,
        curentSexe,
        adresseController.text,
        telephoneController.text,
        emailController.text,
        situationMatrimonialeController.text,
        listbyte);
  }

  Future<void> loadImage() async {
    const int maxSize = 1024 * 1024;
    late File iFile;
    late int imageSize;
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      iFile = File(image!.path);
      imageSize = await iFile.length();
      if (imageSize < maxSize) {
        imageFile = File(image!.path).readAsBytesSync();
        setState(() {
          isImageLoading = true;
        });
      } else {
        setState(() {
          debugPrint("Temps du false: ${DateTime.now()}");
          isImageLoading = false;
        });
      }
    } else {
      setState(() {
        isImageLoading = false;
      });
    }
  }



  void alert(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
              "Image trop volumineuse : la taille de l'image ne doit pas dépasser 1mo.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight:
                  FontWeight.bold)),
          backgroundColor: Colors.red,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop();
                },
                child: const Text("Ok",
                    textAlign:
                    TextAlign.right,
                    style: TextStyle(
                        fontSize: 20,
                        color:
                        Colors.white,
                        fontWeight:
                        FontWeight
                            .bold))),
          ],
        );
      },
    );
  }

  bool isImageLoading = false;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final titleFontSize = width * 0.1;
    final fontSizeM = width * 0.04;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(width / 25),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: height / 30)),
                Center(
                  child: Text(
                    "Information Personnelles:",
                    style: TextStyle(fontSize: titleFontSize - 10),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: height / 30)),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: width / 30),
                      width: width / 2.1,
                      height: width / 1.9,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: (imageFile != null && imageFile!.isNotEmpty)
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(120, 5),
                                            padding: const EdgeInsets.all(0)),
                                        onPressed: () async {
                                            await loadImage();
                                            debugPrint(
                                                "Temps de récupération: valeur de chargement: $isImageLoading, valeur de l'image: ${image == null} ${DateTime.now()}");

                                            if (!isImageLoading &&
                                                image != null) {
                                              alert();
                                            }
                                        },
                                        child: const Text(
                                          "Changer l'Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            imageFile = null;
                                          });
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red, size: 30),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Image.memory(
                                      imageFile!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async{
                                        await loadImage();
                                        debugPrint(
                                            "Temps de récupération: valeur de chargement: $isImageLoading, valeur de l'image: ${image == null} ${DateTime.now()}");
                                        if (!isImageLoading && image != null) {
                                          alert();
                                        }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        elevation: 8),
                                    child: const Text(
                                      "Ajouter une Image",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Image(
                                    image: const AssetImage(
                                        "lib/Assets/Images/imp.png"),
                                    height: height / 5,
                                  )
                                ],
                              ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Il faut entrer forcément un nom pour votre CV";
                              }
                              return null;
                            },
                            focusNode: _focusNode1,
                            controller: nomController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(10),
                                    left: Radius.circular(10),
                                  ),
                                ),
                                labelText: "Nom",
                                focusColor: Colors.greenAccent,
                                helperText: "Ce champ est obligatoire"),
                          ),
                          Padding(padding: EdgeInsets.only(top: height / 30)),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Il faut entrer forcément un prénom pour votre CV";
                              }
                              return null;
                            },
                            controller: prenomController,
                            focusNode: _focusNode2,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(10),
                                    left: Radius.circular(10),
                                  ),
                                ),
                                labelText: "Prénom",
                                focusColor: Colors.greenAccent,
                                helperText: "Ce champ est obligatoiee"),
                          ),
                          Padding(padding: EdgeInsets.only(top: height / 30)),
                          DateTimeFormField(
                            lastDate: DateTime.now(),
                            initialValue:
                                dateNaissance.day != DateTime.now().day
                                    ? dateNaissance
                                    : null,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.black45),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(10),
                                  left: Radius.circular(10),
                                ),
                              ),
                              labelText: 'Date de Naissance',
                            ),
                            mode: DateTimeFieldPickerMode.date,
                            onChanged: (DateTime? value) {
                              dateNaissance = value!;
                            },
                          ),
                          Padding(padding: EdgeInsets.only(top: height / 30)),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: height / 30)),
                TextFormField(
                  controller: titreController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(10),
                          left: Radius.circular(10),
                        ),
                      ),
                      labelText: "Titre Professionnel",
                      hintText: 'Ingénieur',
                      focusColor: Colors.greenAccent,
                      helperText: "Ce champ n'est pas obligatoire"),
                ),
                Padding(padding: EdgeInsets.only(top: height / 30)),
                TextFormField(
                  maxLines: null,
                  controller: profilController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(10),
                          left: Radius.circular(10),
                        ),
                      ),
                      labelText: "Description du Profil Personnel",
                      focusColor: Colors.greenAccent,
                      helperText: "Ce champ n'est pas obligatoire"),
                ),
                Padding(padding: EdgeInsets.only(top: height / 30)),
                TextFormField(
                  controller: nationnaliteController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(10),
                          left: Radius.circular(10),
                        ),
                      ),
                      labelText: "Nationnalité",
                      focusColor: Colors.greenAccent,
                      helperText: "Ce champ n'est pas obligatoire"),
                ),
                Padding(padding: EdgeInsets.only(top: height / 30)),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Votre Sexe: "),
                ),
                RadioListTile(
                  value: "Masculin",
                  groupValue: curentSexe,
                  onChanged: (value) {
                    setState(() {
                      curentSexe = value as String;
                    });
                  },
                  title: const Text("Masculin"),
                ),
                RadioListTile(
                  value: "Féminin",
                  groupValue: curentSexe,
                  onChanged: (value) {
                    setState(() {
                      curentSexe = value as String;
                    });
                  },
                  title: const Text("Féminin"),
                ),
                TextFormField(
                  controller: adresseController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(10),
                          left: Radius.circular(10),
                        ),
                      ),
                      labelText: "Adresse Postale",
                      focusColor: Colors.greenAccent,
                      helperText: "Ce champ n'est pas obligatoire"),
                ),
                Padding(padding: EdgeInsets.only(top: height / 30)),
                TextFormField(
                  controller: telephoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(10),
                          left: Radius.circular(10),
                        ),
                      ),
                      labelText: "Numéro de Téléphone",
                      focusColor: Colors.greenAccent,
                      helperText:
                          "Ce champ est recommandé: entrez votre numéro en format international"),
                ),
                Padding(padding: EdgeInsets.only(top: height / 30)),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(10),
                          left: Radius.circular(10),
                        ),
                      ),
                      labelText: "Adresse Email",
                      focusColor: Colors.greenAccent,
                      helperText: "Ce champ est recommandé"),
                ),
                Padding(padding: EdgeInsets.only(top: height / 30)),
                TextFormField(
                  controller: situationMatrimonialeController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(10),
                          left: Radius.circular(10),
                        ),
                      ),
                      labelText: "Situation Matrimoniale",
                      focusColor: Colors.greenAccent,
                      helperText: "Ce champ n'est pas obligatoire"),
                ),
                Padding(padding: EdgeInsets.only(top: height / 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _savePersonalInformation().then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Informations enregistrées avec succès!'),
                                ),
                              );
                            });
                            loadInterAd();
                            _interstitialAd?.show();
                            validateFormulaireFunction(context, index);
                          } else if (nomController.text.isEmpty) {
                            FocusScope.of(context).requestFocus(_focusNode1);
                          } else if (prenomController.text.isEmpty) {
                            FocusScope.of(context).requestFocus(_focusNode2);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: Text(
                          "Valider",
                          style: TextStyle(
                              fontSize: fontSizeM, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  InterstitialAd? _interstitialAd;
}

class ProObjectif extends StatefulWidget {
  final int index;

  const ProObjectif({required this.index, super.key});

  @override
  State<ProObjectif> createState() => _ProObjectifState();
}

class _ProObjectifState extends State<ProObjectif> {
  late int index;
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();
  late int indexi;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    index = widget.index;
    indexi = index;
    setState(() {
      _initDatabase();
    });
  }

  Future<void> _initDatabase() async {
    final objects = await DataManager(index: indexi).initProObjectifDatabase();
    setState(() {
      objects.isNotEmpty
          ? _objectifs = List<Map<String, String>>.from(objects.map((e) => {
                'titre': e['titre'] as String,
                'resume': e['resume'] as String,
              }))
          : null;
    });
  }

  Future<void> _saveObjectif(String titre, String resume) async {
    DataManager(index: indexi).saveObjectif(titre, resume);
  }

  List<Map<String, String>> _objectifs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 25)),
            Column(
              children: [
                const Center(
                  child: Text(
                    "Objectifs Professionnels",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                TextField(
                  focusNode: _focusNode,
                  controller: _titreController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Titre de l\'objectif',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _resumeController,
                  maxLines: null, // Permet un champ multiligne
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Résumé de l\'objectif',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String titre = _titreController.text;
                String resume = _resumeController.text;

                if (titre.isNotEmpty && resume.isNotEmpty) {
                  setState(() {
                    _objectifs.add({
                      'titre': titre,
                      'resume': resume,
                    });
                    _titreController.clear();
                    _resumeController.clear();
                  });

                  _saveObjectif(titre, resume); // Sauvegarder les données
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Ajouter Objectif',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ExpansionTile(
                title: const Text("Voir vos objectifs"),
                children: _objectifs.map((e) {
                  String titre = e['titre']!;
                  String resume = e['resume']!;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text('Titre: $titre'),
                      subtitle: Text('Résumé: $resume'),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert,
                            size: MediaQuery.of(context).size.height / 25),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.blue,
                                            content: Text(
                                              'Voulez-vous vraiment supprimer cet objectif ?',
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          20,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Annuler',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              20,
                                                          color:
                                                              Colors.white))),
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _objectifs.removeAt(
                                                          _objectifs
                                                              .indexOf(e));
                                                    });
                                                    DataManager(index: indexi)
                                                        .deleteObjectif(
                                                            titre, resume);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Confirmer',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            20,
                                                        color: Colors.white),
                                                  ))
                                            ],
                                          );
                                        },
                                      );
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                  )),
                            ),
                            PopupMenuItem(
                              child: IconButton(
                                  onPressed: () {
                                    _titreController.text = e['titre']!;
                                    _resumeController.text = e['resume']!;
                                    setState(() {
                                      _objectifs
                                          .removeAt(_objectifs.indexOf(e));
                                    });
                                    DataManager(index: indexi)
                                        .deleteObjectif(titre, resume);
                                    Navigator.of(context).pop();
                                    setState(() {
                                      FocusScope.of(context)
                                          .requestFocus(_focusNode);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                  )),
                            )
                          ];
                        },
                      ),
                    ),
                  );
                }).toList()),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      validateFormulaireFunction(context, index);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      "Valider",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProExperience extends StatefulWidget {
  final int index;

  const ProExperience({required this.index, super.key});

  @override
  State<ProExperience> createState() => _ProExperienceState();
}

class _ProExperienceState extends State<ProExperience> {
  late int index;
  List<Map<String, String>> _experiences = [];
  final TextEditingController _entrepriseController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _paysController = TextEditingController();
  final TextEditingController _posteController = TextEditingController();
  final TextEditingController _missionsController = TextEditingController();
  late int indexi;
  String startDate = '';
  String endDate = '';
  int startYear = 2023, endYear = 2023;
  String startMonth = 'Janvier', endMonth = 'Janvier';
  List<int> listYears = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    index = widget.index;
    indexi = index;
    int lastYear = DateTime.now().year;
    setState(() {
      listYears.add(lastYear);
      _initDatabase();
      for (int i = 1; i < 100; i++) {
        listYears.add(listYears[i - 1] - 1);
      }
    });
  }

  Future<void> _initDatabase() async {
    final objects =
        await DataManager(index: indexi).initProExperienceDatabase();
    setState(() {
      objects.isNotEmpty
          ? _experiences = List<Map<String, String>>.from(objects.map((e) => {
                'entreprise': e['entreprise'] as String,
                'ville': e['ville'] as String,
                'pays': e['pays'] as String,
                'poste': e['poste'] as String,
                'startDate': e['startDate'] as String,
                'endDate': e['endDate'] as String,
                'missions': e['missions'] as String,
              }))
          : null;
    });
  }

  Future<void> _saveExperience(String entreprise, String ville, String pays,
      String poste, String missions, String startDate, String endDate) async {
    DataManager(index: indexi).saveExperience(
        entreprise, ville, pays, poste, missions, startDate, endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 25),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 55,
                  bottom: MediaQuery.of(context).size.height / 50),
              child: const Text(
                'Expériences Professionnelles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            TextField(
              focusNode: _focusNode,
              controller: _entrepriseController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Nom de l\'Entreprise'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _villeController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Ville'),
              maxLines: null,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _paysController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Pays'),
              maxLines: null,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _posteController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Intitulé du Poste'),
              maxLines: null,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _missionsController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Missions Réalisées'),
              maxLines: null,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height / 35,
                  right: MediaQuery.of(context).size.height / 35),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 50,
                    ),
                  ),
                  const Center(
                      child: Text("Période de l'emploi",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const Center(child: Text('Date de Début:')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton(
                        items: const [
                          DropdownMenuItem(
                            value: 'Janvier',
                            child: Text("Janvier"),
                          ),
                          DropdownMenuItem(
                            value: 'Février',
                            child: Text("Février"),
                          ),
                          DropdownMenuItem(
                            value: 'Mars',
                            child: Text("Mars"),
                          ),
                          DropdownMenuItem(
                            value: 'Avril',
                            child: Text("Avril"),
                          ),
                          DropdownMenuItem(
                            value: 'Mai',
                            child: Text("Mai"),
                          ),
                          DropdownMenuItem(
                            value: 'Juin',
                            child: Text("Juin"),
                          ),
                          DropdownMenuItem(
                            value: 'Juillet',
                            child: Text("Juillet"),
                          ),
                          DropdownMenuItem(
                            value: 'Août',
                            child: Text("Août"),
                          ),
                          DropdownMenuItem(
                            value: 'Septembre',
                            child: Text("Septembre"),
                          ),
                          DropdownMenuItem(
                            value: 'Octobre',
                            child: Text("Octobre"),
                          ),
                          DropdownMenuItem(
                            value: 'Novembre',
                            child: Text("Novembre"),
                          ),
                          DropdownMenuItem(
                            value: 'Décemre',
                            child: Text("Décembre"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            startMonth = value!;
                          });
                        },
                        value: startMonth,
                      ),
                      DropdownButton(
                        items: listYears
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.toString()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            startYear = value!;
                          });
                        },
                        value: startYear,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 35),
                  ),
                  const Center(child: Text('Date de Fin')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton(
                        items: const [
                          DropdownMenuItem(
                            value: 'Janvier',
                            child: Text("Janvier"),
                          ),
                          DropdownMenuItem(
                            value: 'Février',
                            child: Text("Février"),
                          ),
                          DropdownMenuItem(
                            value: 'Mars',
                            child: Text("Mars"),
                          ),
                          DropdownMenuItem(
                            value: 'Avril',
                            child: Text("Avril"),
                          ),
                          DropdownMenuItem(
                            value: 'Mai',
                            child: Text("Mai"),
                          ),
                          DropdownMenuItem(
                            value: 'Juin',
                            child: Text("Juin"),
                          ),
                          DropdownMenuItem(
                            value: 'Juillet',
                            child: Text("Juillet"),
                          ),
                          DropdownMenuItem(
                            value: 'Août',
                            child: Text("Août"),
                          ),
                          DropdownMenuItem(
                            value: 'Septembre',
                            child: Text("Septembre"),
                          ),
                          DropdownMenuItem(
                            value: 'Octobre',
                            child: Text("Octobre"),
                          ),
                          DropdownMenuItem(
                            value: 'Novembre',
                            child: Text("Novembre"),
                          ),
                          DropdownMenuItem(
                            value: 'Décemre',
                            child: Text("Décembre"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            endMonth = value!;
                          });
                        },
                        value: endMonth,
                      ),
                      DropdownButton(
                        items: listYears
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.toString()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            endYear = value!;
                          });
                        },
                        value: endYear,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _ajouterExperience();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Ajouter Expérience',
                  style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 80),
            //const Text('Expériences Professionnelles'),
            // _buildExperienceList(),
            ExpansionTile(
              title: const Text("Voir vos expériences"),
              children: _experiences.map((e) {
                String entreprise = e['entreprise']!;
                String poste = e['poste']!;
                String debutPeriode = e['startDate']!;
                String finPeriode = e['endDate']!;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text('Poste: $poste'),
                    subtitle: Text(
                        'Entreprise: $entreprise\nPériode:  ${'$debutPeriode - $finPeriode'}'),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert,
                          size: MediaQuery.of(context).size.height / 25),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.blue,
                                          content: Text(
                                            'Voulez-vous vraiment supprimer cet expérience ?',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    20,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Annuler',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            20,
                                                        color: Colors.white))),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _experiences.removeAt(
                                                        _experiences
                                                            .indexOf(e));
                                                    _deleteExperience(
                                                        e['entreprise']!,
                                                        e['poste']!,
                                                        e['startDate']!);
                                                  });
                                                },
                                                child: Text(
                                                  'Confirmer',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              20,
                                                      color: Colors.white),
                                                ))
                                          ],
                                        );
                                      },
                                    );
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                )),
                          ),
                          PopupMenuItem(
                            child: IconButton(
                                onPressed: () {
                                  _entrepriseController.text = e['entreprise']!;
                                  _villeController.text = e['ville']!;
                                  _missionsController.text = e['missions']!;
                                  _paysController.text = e['pays']!;
                                  _posteController.text = e['poste']!;
                                  setState(() {
                                    _experiences
                                        .removeAt(_experiences.indexOf(e));
                                    _deleteExperience(
                                        entreprise, poste, debutPeriode);
                                  });
                                  Navigator.of(context).pop();
                                  setState(() {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode);
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                )),
                          )
                        ];
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 30)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loadInterAd();
                          _interstitialAd?.show();
                          validateFormulaireFunction(context, index);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text(
                        "Valider",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  InterstitialAd? _interstitialAd;

  void _ajouterExperience() {
    String entreprise = _entrepriseController.text;
    String ville = _villeController.text;
    String pays = _paysController.text;
    String poste = _posteController.text;
    String missions = _missionsController.text;
    startDate = '$startMonth $startYear';
    endDate = '$endMonth $endYear';

    if (entreprise.isNotEmpty &&
        ville.isNotEmpty &&
        pays.isNotEmpty &&
        poste.isNotEmpty &&
        missions.isNotEmpty) {
      setState(() {
        _experiences.add({
          'entreprise': entreprise,
          'ville': ville,
          'pays': pays,
          'poste': poste,
          'missions': missions,
          'startDate': startDate,
          'endDate': endDate
        });
        _entrepriseController.clear();
        _villeController.clear();
        _paysController.clear();
        _posteController.clear();
        _missionsController.clear();
      });
      _saveExperience(
          entreprise, ville, pays, poste, missions, startDate, endDate);
      startMonth = 'Janvier';
      startYear = DateTime.now().year;
      endMonth = 'Janvier';
      endYear = DateTime.now().year;
      startDate = '';
      endDate = '';
    }
  }

  Future<void> _deleteExperience(
      String entreprise, String poste, String periodeDebut) async {
    DataManager(index: indexi)
        .deleteExperience(entreprise, poste, periodeDebut);
  }
}

class Education extends StatefulWidget {
  final int index;

  const Education({required this.index, super.key});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  late int index;
  final TextEditingController _formationController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _paysController = TextEditingController();
  final TextEditingController _anneeController = TextEditingController();
  List<Map<String, dynamic>> _educations = [];
  late int indexi;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    index = widget.index;
    indexi = index;
    setState(() {
      _initDatabase();
    });
  }

  Future<void> _initDatabase() async {
    final educations = await DataManager(index: indexi).initEducationDatabase();
    setState(() {
      educations.isNotEmpty
          ? _educations = List<Map<String, dynamic>>.from(educations)
          : null;
    });
  }

  Future<void> _saveEducation(String formation, String institution,
      String ville, String pays, String annee) async {
    DataManager(index: indexi)
        .saveEducation(formation, institution, ville, pays, annee);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 25),
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: Text(
                'Éducation',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            TextField(
              focusNode: _focusNode,
              controller: _formationController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Formation ou Diplôme Obtenu'),
              maxLines: null,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _institutionController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Institution'),
              maxLines: null,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _villeController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Ville'),
              maxLines: null,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _paysController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Pays'),
              maxLines: null,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _anneeController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: "Année ou Date d'Obtention du Diplôme"),
              maxLines: null,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String formation = _formationController.text;
                String institution = _institutionController.text;
                String ville = _villeController.text;
                String pays = _paysController.text;
                String annee = _anneeController.text;

                if (formation.isNotEmpty &&
                    institution.isNotEmpty &&
                    ville.isNotEmpty &&
                    pays.isNotEmpty &&
                    annee.isNotEmpty) {
                  setState(() {
                    _educations.add({
                      'formation': formation,
                      'institution': institution,
                      'ville': ville,
                      'pays': pays,
                      'annee': annee,
                    });

                    _formationController.clear();
                    _institutionController.clear();
                    _villeController.clear();
                    _paysController.clear();
                    _anneeController.clear();
                  });
                  _saveEducation(formation, institution, ville, pays, annee);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Ajouter Éducation',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ExpansionTile(
                title: const Text("Voir vos éducations"),
                children: _educations.map((e) {
                  String formation = e['formation'] ?? '';
                  String institution = e['institution'] ?? '';
                  String annee = e['annee'] ?? '';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text('Formation: $formation'),
                      subtitle: Text(
                          'Institution: $institution\nAnnée d\'obtention: $annee'),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert,
                            size: MediaQuery.of(context).size.height / 25),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.blue,
                                            content: Text(
                                              'Voulez-vous vraiment supprimer cet éducation ?',
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          20,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Annuler',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              20,
                                                          color:
                                                              Colors.white))),
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _educations.removeAt(
                                                          _educations
                                                              .indexOf(e));
                                                    });
                                                    Navigator.of(context).pop();
                                                    DataManager(index: indexi)
                                                        .deleteEducation(
                                                            formation,
                                                            institution,
                                                            annee);
                                                  },
                                                  child: Text(
                                                    'Confirmer',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            20,
                                                        color: Colors.white),
                                                  ))
                                            ],
                                          );
                                        },
                                      );
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                  )),
                            ),
                            PopupMenuItem(
                              child: IconButton(
                                  onPressed: () {
                                    _formationController.text = e['formation'];
                                    _institutionController.text =
                                        e['institution'];
                                    _villeController.text = e['ville'];
                                    _paysController.text = e['pays'];
                                    _anneeController.text = e['annee'];
                                    setState(() {
                                      _educations
                                          .removeAt(_educations.indexOf(e));
                                    });
                                    Navigator.of(context).pop();
                                    setState(() {
                                      FocusScope.of(context)
                                          .requestFocus(_focusNode);
                                    });
                                    DataManager(index: indexi).deleteEducation(
                                        formation, institution, annee);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                  )),
                            )
                          ];
                        },
                      ),
                    ),
                  );
                }).toList()),
            //const Text('Éducation'),
            //_buildEducationList(),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        validateFormulaireFunction(context, index);
                      });
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      "Valider",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Certification extends StatefulWidget {
  final int index;

  const Certification({required this.index, super.key});

  @override
  State<Certification> createState() => _CertificationState();
}

class _CertificationState extends State<Certification> {
  late int index;
  final TextEditingController _nomCertificationController =
      TextEditingController();
  final TextEditingController _organismeCertificationController =
      TextEditingController();
  final TextEditingController _dateCertificationController =
      TextEditingController();
  List<Map<String, dynamic>> _certifications = [];
  late int indexi;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    index = widget.index;
    indexi = index;
    setState(() {
      _initDatabase();
    });
  }

  Future<void> _initDatabase() async {
    final certifications =
        await DataManager(index: indexi).initCertificationDatabase();
    setState(() {
      certifications.isNotEmpty
          ? _certifications = List<Map<String, dynamic>>.from(certifications)
          : null;
    });
  }

  Future<void> _saveCertification(String nomCertification,
      String organismeCertification, String dateCertification) async {
    await DataManager(index: indexi).saveCertification(
        nomCertification, organismeCertification, dateCertification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 25),
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: Text(
                'Certifications',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            TextField(
              focusNode: _focusNode,
              controller: _nomCertificationController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Nom de la Certification'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _organismeCertificationController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Organisme de Certification'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _dateCertificationController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Date ou Année  de la Certification'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String nomCertification = _nomCertificationController.text;
                String organismeCertification =
                    _organismeCertificationController.text;
                String dateCertification = _dateCertificationController.text;

                if (nomCertification.isNotEmpty &&
                    organismeCertification.isNotEmpty &&
                    dateCertification.isNotEmpty) {
                  setState(() {
                    _certifications.add({
                      'nomCertification': nomCertification,
                      'organismeCertification': organismeCertification,
                      'dateCertification': dateCertification,
                    });
                    _nomCertificationController.clear();
                    _organismeCertificationController.clear();
                    _dateCertificationController.clear();
                  });
                  _saveCertification(nomCertification, organismeCertification,
                      dateCertification);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Ajouter Certification',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            //const Text('Certifications'),
            //_buildCertificationList(),
            ExpansionTile(
              title: const Text("Voir vos certifications"),
              children: _certifications.map((e) {
                String nomCertification = e['nomCertification'] ?? '';
                String organismeCertification =
                    e['organismeCertification'] ?? '';
                String dateCertification = e['dateCertification'] ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text('Certification: $nomCertification'),
                    subtitle: Text(
                        'Organisme: $organismeCertification\nDate: $dateCertification'),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert,
                          size: MediaQuery.of(context).size.height / 25),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.blue,
                                          content: Text(
                                            'Voulez-vous vraiment supprimer cette certification ?',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    20,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Annuler',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            20,
                                                        color: Colors.white))),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _certifications.removeAt(
                                                        _certifications
                                                            .indexOf(e));
                                                  });
                                                  DataManager(index: indexi)
                                                      .deleteCertification(
                                                          nomCertification,
                                                          organismeCertification,
                                                          dateCertification);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Confirmer',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              20,
                                                      color: Colors.white),
                                                ))
                                          ],
                                        );
                                      },
                                    );
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                )),
                          ),
                          PopupMenuItem(
                            child: IconButton(
                                onPressed: () {
                                  _nomCertificationController.text =
                                      e['nomCertification'];
                                  _organismeCertificationController.text =
                                      e['organismeCertification'];
                                  _dateCertificationController.text =
                                      e['dateCertification'];
                                  setState(() {
                                    _certifications
                                        .removeAt(_certifications.indexOf(e));
                                  });
                                  DataManager(index: indexi)
                                      .deleteCertification(
                                          nomCertification,
                                          organismeCertification,
                                          dateCertification);
                                  Navigator.of(context).pop();
                                  setState(() {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode);
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                )),
                          )
                        ];
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loadInterAd();
                        _interstitialAd?.show();
                        validateFormulaireFunction(context, index);
                      });
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      "Valider",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  InterstitialAd? _interstitialAd;
}

class ExpCompetence extends StatefulWidget {
  final int index;

  const ExpCompetence({required this.index, super.key});

  @override
  State<ExpCompetence> createState() => _ExpCompetenceState();
}

class _ExpCompetenceState extends State<ExpCompetence> {
  late int index;
  final List<Map<String, dynamic>> _competencesGenerales = [];
  final List<Map<String, dynamic>> _competencesSpecifiques = [];
  late int indexi;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    index = widget.index;
    indexi = index;
    setState(() {
      _initDatabase();
    });
  }

  Future<void> _initDatabase() async {
    final competences =
        await DataManager(index: indexi).initCompetenceDatabase();
    setState(() {
      _competencesGenerales.clear();
      _competencesSpecifiques.clear();
      for (var competence in competences) {
        if (competence['niveau'] == 0) {
          _competencesGenerales.add({
            'competence': competence['competence'] as String,
            'outil': competence['outil'] as String,
          });
        } else {
          _competencesSpecifiques.add({
            'competence': competence['competence'] as String,
            'outil': competence['outil'] as String,
          });
        }
      }
    });
  }

  Future<void> _saveCompetence(
      bool isGenerale, String competence, String outil) async {
    DataManager(index: indexi).saveCompetence(isGenerale, competence, outil);
  }

  Future<void> _deleteCompetence(bool isGenerale, String competence) async {
    DataManager(index: indexi).deleteCompetence(isGenerale, competence);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 25),
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: Text(
                'Compétences et Expertises',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _ajouterCompetence(true, '', '');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Ajouter Compétence Générale',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _ajouterCompetence(false, '', '');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Ajouter Compétence Spécifique',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              title: const Text("Voir vos compétences générales"),
              children: _buildCompetenceList(_competencesGenerales, true),
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              title: const Text("Voir vos compétences Spécifiques"),
              children: _buildCompetenceList(_competencesGenerales, false),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        validateFormulaireFunction(context, index);
                      });
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      "Valider",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _ajouterCompetence(bool isGenerale, String comp, String out) {
    TextEditingController competenceController = TextEditingController();
    TextEditingController outilController = TextEditingController();
    competenceController.text = comp;
    outilController.text = out;
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isGenerale
              ? 'Ajouter une Compétence Générale'
              : 'Ajouter une Compétence Spécifique'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  focusNode: _focusNode,
                  controller: competenceController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'Nom de la Compétence'),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 20,
                  ),
                  child: TextField(
                    maxLines: null,
                    controller: outilController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelText: 'Description de la compétence'),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                if (comp.isNotEmpty && out.isNotEmpty) {
                  setState(() {
                    isGenerale
                        ? _competencesGenerales
                            .add({'competence': comp, 'outil': out})
                        : _competencesSpecifiques
                            .add({'competence': comp, 'outil': out});
                  });

                  _saveCompetence(isGenerale, comp, out);
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ajouter'),
              onPressed: () {
                String competence = competenceController.text;
                String outil = outilController.text;

                if (competence.isNotEmpty && outil.isNotEmpty) {
                  setState(() {
                    if (isGenerale) {
                      _competencesGenerales.add({
                        'competence': competence,
                        'outil': outil,
                      });
                    } else {
                      _competencesSpecifiques.add({
                        'competence': competence,
                        'outil': outil,
                      });
                    }
                  });
                  _saveCompetence(isGenerale, competence, outil);
                  competenceController.clear();
                  outilController.clear();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildCompetenceList(
      List<Map<String, dynamic>> competences, bool isGeneral) {
    List<Widget> competencesList = [];
    isGeneral
        ? _competencesGenerales.map((e) {
            String competence = e['competence'];
            String outil = e['outil'] ?? '';
            return competencesList.add(Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text('Compétence: $competence'),
                subtitle: Text('Outil: $outil\n'),
                trailing: PopupMenuButton(
                  icon: Icon(Icons.more_vert,
                      size: MediaQuery.of(context).size.height / 25),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.blue,
                                      content: Text(
                                        'Voulez-vous vraiment supprimer cette compétence ?',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                20,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Annuler',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            20,
                                                    color: Colors.white))),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _competencesGenerales.removeAt(
                                                    _competencesGenerales
                                                        .indexOf(e));
                                              });
                                              Navigator.of(context).pop();
                                              _deleteCompetence(
                                                  isGeneral, competence);
                                            },
                                            child: Text(
                                              'Confirmer',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          20,
                                                  color: Colors.white),
                                            ))
                                      ],
                                    );
                                  },
                                );
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                            )),
                      ),
                      PopupMenuItem(
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _ajouterCompetence(
                                  isGeneral, e['competence'], e['outil']);
                              setState(() {
                                _competencesGenerales
                                    .removeAt(_competencesGenerales.indexOf(e));
                              });
                              setState(() {
                                FocusScope.of(context).requestFocus(_focusNode);
                              });
                              _deleteCompetence(isGeneral, competence);
                            },
                            icon: const Icon(
                              Icons.edit,
                            )),
                      )
                    ];
                  },
                ),
              ),
            ));
          }).toList()
        : _competencesSpecifiques.map((e) {
            String competence = e['competence'];
            String outil = e['outil'] ?? '';
            return competencesList.add(Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text('Compétence: $competence'),
                subtitle: Text('Outil: $outil\n'),
                trailing: PopupMenuButton(
                  icon: Icon(Icons.more_vert,
                      size: MediaQuery.of(context).size.height / 25),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.blue,
                                      content: Text(
                                        'Voulez-vous vraiment supprimer cette compétence ?',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                20,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Annuler',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            20,
                                                    color: Colors.white))),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _competencesSpecifiques
                                                    .removeAt(
                                                        _competencesSpecifiques
                                                            .indexOf(e));
                                              });
                                              Navigator.of(context).pop();
                                              _deleteCompetence(
                                                  isGeneral, competence);
                                            },
                                            child: Text(
                                              'Confirmer',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          20,
                                                  color: Colors.white),
                                            ))
                                      ],
                                    );
                                  },
                                );
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                            )),
                      ),
                      PopupMenuItem(
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _ajouterCompetence(
                                  isGeneral, e['competence'], e['outil']);
                              setState(() {
                                _competencesSpecifiques.removeAt(
                                    _competencesSpecifiques.indexOf(e));
                              });
                              setState(() {
                                FocusScope.of(context).requestFocus(_focusNode);
                              });
                              _deleteCompetence(isGeneral, competence);
                            },
                            icon: const Icon(
                              Icons.edit,
                            )),
                      )
                    ];
                  },
                ),
              ),
            ));
          }).toList();
    return competencesList;
  }
}

class LangueMait extends StatefulWidget {
  final int index;

  const LangueMait({required this.index, super.key});

  @override
  State<LangueMait> createState() => _LangueMaitState();
}

class _LangueMaitState extends State<LangueMait> {
  late int index;
  final List<Map<String, dynamic>> _langues = [];
  final TextEditingController _langueController = TextEditingController();
  late var maitrise = 100;
  late int indexi;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    index = widget.index;
    indexi = index;
    setState(() {
      _initDatabase();
    });
  }

  Future<void> _initDatabase() async {
    final lan = await DataManager(index: indexi).initLangueDatabase();
    setState(() {
      lan.isNotEmpty ? _langues.addAll(lan) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 25),
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: Text(
                "Compétences Linguistiques",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            TextField(
              focusNode: _focusNode,
              controller: _langueController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Langue'),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                const Text('Maîtrise de la Langue: '),
                Expanded(
                  child: Slider(
                    value: maitrise.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 5,
                    onChanged: (value) {
                      setState(() {
                        maitrise = value.toInt();
                      });
                    },
                  ),
                ),
                Text(
                  maitrise.toString(),
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _ajouterLangue();
                setState(() {
                  maitrise = 100;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Ajouter Langue',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              title: const Text("Voir les langues ajoutées"),
              children: _langues.map((e) {
                String langue = e['langue'];
                int maitrise = e['maitrise'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text('Langue: $langue'),
                    subtitle: Text('Maîtrise: $maitrise%'),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert,
                          size: MediaQuery.of(context).size.height / 25),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.blue,
                                          content: Text(
                                            'Voulez-vous vraiment supprimer cette langue ?',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    20,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Annuler',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            20,
                                                        color: Colors.white))),
                                            TextButton(
                                                onPressed: () {
                                                  _supprimerLangue(
                                                      _langues.indexOf(e));
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Confirmer',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              20,
                                                      color: Colors.white),
                                                ))
                                          ],
                                        );
                                      },
                                    );
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                )),
                          ),
                          PopupMenuItem(
                            child: IconButton(
                                onPressed: () {
                                  _langueController.text = e['langue'];
                                  maitrise = e['maitrise'];
                                  setState(() {
                                    maitrise = maitrise.toInt();
                                  });
                                  Navigator.of(context).pop();
                                  setState(() {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode);
                                  });
                                  _supprimerLangue(_langues.indexOf(e));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                )),
                          )
                        ];
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loadInterAd();
                          _interstitialAd?.show();
                          validateFormulaireFunction(context, index);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text(
                        "Valider",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  InterstitialAd? _interstitialAd;

  void _ajouterLangue() async {
    String langue = _langueController.text;
    if (langue.isNotEmpty) {
      DataManager(index: indexi).ajouterLangue(langue, maitrise);
      setState(() {
        _langues.add({'langue': langue, 'maitrise': maitrise});
        _langueController.clear();
      });
    }
  }

  void _supprimerLangue(int index) async {
    final langue = _langues[index]["langue"];
    final maitrise = _langues[index]["maitrise"];
    DataManager(index: indexi).supprimerLangue(langue, maitrise);
    setState(() {
      _langues.removeAt(index);
      if (_langues.isEmpty) {}
    });
  }
}

class CentreInteret extends StatefulWidget {
  final int index;

  const CentreInteret({required this.index, super.key});

  @override
  State<CentreInteret> createState() => _CentreInteretState();
}

class _CentreInteretState extends State<CentreInteret> {
  late int index;
  final List<Map<String, dynamic>> _centresInteret = [];
  final TextEditingController _centreInteretController =
      TextEditingController();
  late int indexi;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    indexi = index;
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final centre = await DataManager(index: indexi).initDatabase();

    setState(() {
      centre.isNotEmpty ? _centresInteret.addAll(centre) : null;
    });
  }

  bool onCentreFocus = false;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 25),
        child: ListView(
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 15),
                child: Text(
                  "Centre d'Intérêt",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
            TextField(
              focusNode: _focusNode,
              autofocus: onCentreFocus,
              controller: _centreInteretController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Ajouter un Centre d\'Intérêt'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _ajouterCentreInteret();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Ajouter Centre d\'Intérêt',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ExpansionTile(
                title: const Text("Voir vos centres d'intérêts"),
                children: _centresInteret.map((e) {
                  String centreInteret = e['centre'];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text('Centre d\'Intérêt: $centreInteret'),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert,
                            size: MediaQuery.of(context).size.height / 25),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.blue,
                                            content: Text(
                                              'Voulez-vous vraiment supprimer ce centre d\'intérêt ?',
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          20,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Annuler',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              20,
                                                          color:
                                                              Colors.white))),
                                              TextButton(
                                                  onPressed: () {
                                                    _supprimerCentreInteret(
                                                        _centresInteret
                                                            .indexOf(e));
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Confirmer',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            20,
                                                        color: Colors.white),
                                                  ))
                                            ],
                                          );
                                        },
                                      );
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                  )),
                            ),
                            PopupMenuItem(
                              child: IconButton(
                                  onPressed: () {
                                    _centreInteretController.text = e['centre'];
                                    Navigator.of(context).pop();
                                    setState(() {
                                      FocusScope.of(context)
                                          .requestFocus(_focusNode);
                                    });
                                    _supprimerCentreInteret(
                                        _centresInteret.indexOf(e));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                  )),
                            )
                          ];
                        },
                      ),
                    ),
                  );
                }).toList()),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          validateFormulaireFunction(context, index);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text(
                        "Valider",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _ajouterCentreInteret() async {
    String centreInteret = _centreInteretController.text;

    if (centreInteret.isNotEmpty) {
      DataManager(index: indexi).ajouterCentreInteret(centreInteret);

      setState(() {
        _centresInteret.add({'centre': centreInteret});
        _centreInteretController.clear();
      });
    }
  }

  void _supprimerCentreInteret(int index) async {
    final centreInteret = _centresInteret[index]['centre'];
    DataManager(index: indexi)._supprimerCentreInteret(centreInteret);

    setState(() {
      _centresInteret.removeAt(index);
    });
  }
}

class ProReference extends StatefulWidget {
  final int index;

  const ProReference({required this.index, super.key});

  @override
  State<ProReference> createState() => _ProReferenceState();
}

class _ProReferenceState extends State<ProReference> {
  final FocusNode _focusNode = FocusNode();
  late int index;
  final List<Map<String, dynamic>> _references = [];
  final TextEditingController _nomReferenceController = TextEditingController();
  final TextEditingController _posteReferenceController =
      TextEditingController();
  final TextEditingController _entrepriseReferenceController =
      TextEditingController();
  final TextEditingController _telephoneReferenceController =
      TextEditingController();
  late int indexi;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    indexi = index;
    setState(() {
      _initDatabase();
    });
  }

  Future<void> _initDatabase() async {
    final ref = await DataManager(index: indexi).initDatabaseref();
    setState(() {
      ref.isNotEmpty ? _references.addAll(ref) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 25),
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: Text(
                "Références Professionnelles",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            TextField(
              focusNode: _focusNode,
              controller: _nomReferenceController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Nom'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _posteReferenceController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Poste'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _entrepriseReferenceController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Entreprise'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            TextField(
              controller: _telephoneReferenceController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Téléphone'),
              keyboardType: TextInputType.phone,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 50,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _ajouterReference();
                if (_nomReferenceController.text.isNotEmpty &&
                    _posteReferenceController.text.isNotEmpty &&
                    _entrepriseReferenceController.text.isNotEmpty &&
                    _telephoneReferenceController.text.isNotEmpty) {}
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Ajouter Référence',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              title: const Text("Voir vos références"),
              children: _references.map((e) {
                String nom = e['nom'] ?? '';
                String poste = e['poste'] ?? '';
                String entreprise = e['entreprise'] ?? '';
                String telephone = e['telephone'] ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text('Nom: $nom'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Poste: $poste'),
                        Text('Entreprise: $entreprise'),
                        Text('Téléphone: $telephone'),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert,
                          size: MediaQuery.of(context).size.height / 25),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.blue,
                                          content: Text(
                                            'Voulez-vous vraiment supprimer cette référence ?',
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    20,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Annuler',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            20,
                                                        color: Colors.white))),
                                            TextButton(
                                                onPressed: () {
                                                  _supprimerReference(
                                                      _references.indexOf(e));
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Confirmer',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              20,
                                                      color: Colors.white),
                                                ))
                                          ],
                                        );
                                      },
                                    );
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                )),
                          ),
                          PopupMenuItem(
                            child: IconButton(
                                onPressed: () {
                                  _nomReferenceController.text = e['nom'];
                                  _posteReferenceController.text = e['poste'];
                                  _entrepriseReferenceController.text =
                                      e['entreprise'];
                                  _telephoneReferenceController.text =
                                      e['telephone'];
                                  Navigator.of(context).pop();
                                  setState(() {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode);
                                  });
                                  _supprimerReference(_references.indexOf(e));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                )),
                          )
                        ];
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loadInterAd();
                          _interstitialAd?.show();
                          validateFormulaireFunction(context, index);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text(
                        "Valider",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  InterstitialAd? _interstitialAd;

  void _ajouterReference() async {
    String nom = _nomReferenceController.text;
    String poste = _posteReferenceController.text;
    String entreprise = _entrepriseReferenceController.text;
    String telephone = _telephoneReferenceController.text;

    if (nom.isNotEmpty &&
        poste.isNotEmpty &&
        entreprise.isNotEmpty &&
        telephone.isNotEmpty) {
      DataManager(index: indexi)
          .ajouterReference(nom, poste, entreprise, telephone);

      setState(() {
        _references.add({
          'nom': nom,
          'poste': poste,
          'entreprise': entreprise,
          'telephone': telephone
        });
        _nomReferenceController.clear();
        _posteReferenceController.clear();
        _entrepriseReferenceController.clear();
        _telephoneReferenceController.clear();
      });
    }
  }

  void _supprimerReference(int index) async {
    final nom = _references[index]["nom"];
    final poste = _references[index]["poste"];
    final entreprise = _references[index]["entreprise"];
    final telephone = _references[index]["telephone"];
    DataManager(index: indexi)
        .supprimerReference(nom, poste, entreprise, telephone);
    setState(() {
      _references.removeAt(index);
    });
  }
}

class CvMarkerClass extends StatefulWidget {
  final int index;

  const CvMarkerClass({super.key, required this.index});

  @override
  State<CvMarkerClass> createState() => _CvMarkerClassState();
}

class _CvMarkerClassState extends State<CvMarkerClass> {
  late int indexi;
  PrintingInfo? printingInfo;
  List<Map<String, dynamic>> infoPersoList = [];
  List<Map<String, dynamic>> proObjectif = [];
  List<Map<String, dynamic>> proExperience = [];
  List<Map<String, dynamic>> education = [];
  List<Map<String, dynamic>> certification = [];
  List<Map<String, dynamic>> compExp = [];
  List<Map<String, dynamic>> langueMait = [];
  List<Map<String, dynamic>> centreInteret = [];
  List<Map<String, dynamic>> referencePro = [];
  Map<String, dynamic> infoPerso = {};
  String nom = '';
  String prenom = '';
  String dateNaissance = '';
  String titre = '';
  String profil = '';
  String nationalite = '';
  String sexe = '';
  String adresse = '';
  String telephone = '';
  String email = '';
  String situationMatrimoniale = '';
  List<int>? imageBytes = [];
  List<Map<String, dynamic>> formTamplateList = [];
  int formTamplate = 5;

  Future<void> loadInfo() async {
    infoPersoList = await DataManager(index: indexi).initInfoPersoDatabase();
    proObjectif = await DataManager(index: indexi).initProObjectifDatabase();
    proExperience =
        await DataManager(index: indexi).initProExperienceDatabase();
    education = await DataManager(index: indexi).initEducationDatabase();
    certification =
        await DataManager(index: indexi).initCertificationDatabase();
    compExp = await DataManager(index: indexi).initCompetenceDatabase();
    langueMait = await DataManager(index: indexi).initLangueDatabase();
    centreInteret = await DataManager(index: indexi).initDatabase();
    referencePro = await DataManager(index: indexi).initDatabaseref();
    formTamplateList =
        await DataManager(index: indexi).initformTamplateDatabase();
    setState(() {
      Map<String, dynamic> formM = {};
      formTamplateList.isNotEmpty ? formM = formTamplateList.last : null;
      formM.isNotEmpty ? formTamplate = formM['num'] : null;
      infoPersoList.isNotEmpty ? infoPerso = infoPersoList.last : null;
      nom = infoPerso['nom'] ?? '';
      prenom = infoPerso['prenom'] ?? '';
      dateNaissance = infoPerso['dateNaissance'] ?? '';
      titre = infoPerso['titre'] ?? '';
      profil = infoPerso['profil'] ?? '';
      nationalite = infoPerso['nationalite'] ?? '';
      sexe = infoPerso['sexe'] ?? '';
      adresse = infoPerso['adresse'] ?? '';
      telephone = infoPerso['telephone'] ?? '';
      email = infoPerso['email'] ?? '';
      situationMatrimoniale = infoPerso['situationMatrimoniale'] ?? '';
      imageBytes = infoPerso['image'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indexi = widget.index;
    setState(() {
      loadInfo();
    });
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        const PdfPreviewAction(
            icon: Icon(Icons.download), onPressed: saveAsFile)
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
        title: const Text("Mon CV"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CvMarker(index: indexi),
                  ));
                },
                icon: const Icon(Icons.edit),
                color: Colors.black),
          )
        ],
      ),
      body: PdfPreview(
        build: generatePdf,
        actions: actions,
        onPrinted: showShared,
        onShared: showPrinted,
        canDebug: false,
        canChangeOrientation: false,
      ),
    );
  }

  Future<Uint8List> generatePdf(final PdfPageFormat format) async {
    await loadInfo();
    final doc = pw.Document(title: 'CV$indexi.pdf');
    nom = nom.toUpperCase();

    final ByteData fontData =
        await rootBundle.load('lib/Assets/Fonts/awesone.ttf');
    final Uint8List fontBytes =
        Uint8List.fromList(fontData.buffer.asUint8List());
    final pw.Font fontAwesome = pw.Font.ttf(fontBytes.buffer.asByteData());
    if (dateNaissance.isNotEmpty) {
      List<String> dateList1 = [];
      dateList1 = dateNaissance.split(' ');
      String dateNaissance1 = '';
      dateNaissance1 = dateList1.first;
      List<String> dateList2 = [];
      dateList2 = dateNaissance1.split('-');
      List<String> dateNaissance2 = [];
      for (int i = 0; i < dateList2.length; i++) {
        dateNaissance2.add(dateList2[dateList2.length - 1 - i]);
      }
      dateNaissance = dateNaissance2.join('/');
    }

    if (formTamplate == 0) {
      final ByteData calibrifontData =
          await rootBundle.load('lib/Assets/Fonts/calibri.ttf');
      final Uint8List fontBytes =
          Uint8List.fromList(calibrifontData.buffer.asUint8List());
      final pw.Font calibriFont = pw.Font.ttf(fontBytes.buffer.asByteData());

      doc.addPage(pw.MultiPage(
        theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: calibriFont)),
        pageFormat: PdfPageFormat.a3,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        orientation: pw.PageOrientation.portrait,
        build: (context) {
          return [
            pw.Center(
                child: pw.Text("$nom $prenom",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        fontSize: 40, fontWeight: pw.FontWeight.bold))),
            pw.Padding(padding: const pw.EdgeInsets.only(top: 12)),
            pw.Container(
              width: 1800,
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                      color: PdfColors.blue,
                      style: pw.BorderStyle.solid,
                      width: 3)),
              child: pw.Column(children: [
                pw.Container(
                    padding: const pw.EdgeInsets.only(left: 5),
                    width: 1800,
                    height: 30,
                    color: PdfColors.blue,
                    child: pw.Text("Informations Personnelles",
                        style: const pw.TextStyle(
                            color: PdfColors.white, fontSize: 18))),
                pw.Row(
                  children: [
                    pw.Table(
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 35)),
                            pw.Text("   Adresse Email:      ",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Expanded(
                              child: pw.Text(splitString(email, 80, 0)),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 35)),
                            pw.Text("   Numéro de Téléphone:      ",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text(splitString(telephone, 80, 0)),
                          ],
                        ),
                        pw.TableRow(children: [
                          pw.Padding(
                              padding: const pw.EdgeInsets.only(top: 10)),
                          pw.Text("   Adresse:      ",
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(splitString(adresse, 80, 0)),
                        ]),
                      ],
                    ),
                    (imageBytes != null)
                        ? pw.Padding(
                            padding: const pw.EdgeInsets.only(
                                top: 5, right: 5, bottom: 0),
                            child: pw.Container(
                              color: PdfColors.white,
                              width: 1120 / 6,
                              height: 200,
                              padding: const pw.EdgeInsets.only(
                                  top: 10, bottom: 8, right: 10),
                              child: pw.Center(
                                child: pw.Image(
                                  pw.MemoryImage(
                                      Uint8List.fromList(imageBytes!)),
                                ),
                              ),
                            ),
                          )
                        : pw.SizedBox(width: 200, height: 200),
                  ],
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                ),
              ]),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              width: 1800,
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                      color: PdfColors.blue,
                      style: pw.BorderStyle.solid,
                      width: 3)),
              child: pw.Column(children: [
                pw.Container(
                    padding: const pw.EdgeInsets.only(left: 5),
                    width: 1800,
                    height: 30,
                    color: PdfColors.blue,
                    child: pw.Text("Profil Professionnel",
                        style: const pw.TextStyle(
                            color: PdfColors.white, fontSize: 18))),
                pw.Paragraph(
                  padding: const pw.EdgeInsets.all(10),
                  text: profil,
                  style: const pw.TextStyle(fontSize: 14),
                  textAlign: pw.TextAlign.justify,
                ),
              ]),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              width: 1800,
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                      color: PdfColors.blue,
                      style: pw.BorderStyle.solid,
                      width: 3)),
              child: pw.Column(children: [
                pw.Container(
                    padding: const pw.EdgeInsets.only(left: 5),
                    width: 1800,
                    height: 30,
                    color: PdfColors.blue,
                    child: pw.Text("Expérience Professionnelle:",
                        style: const pw.TextStyle(
                            color: PdfColors.white, fontSize: 18))),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Column(
                    children: proExperience.map((map) {
                      String missionsM = map['missions'];
                      List<String> listMission = missionsM.split('\n');
                      return pw.Row(children: [
                        pw.Text('${map["startDate"]} - ${map["endDate"]}'),
                        pw.Padding(padding: const pw.EdgeInsets.only(left: 30)),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                                splitString(
                                    '       ${map["poste"]}\n       ${map['entreprise']}, ${map['ville']}, ${map['pays']}',
                                    60,
                                    10),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.justify),
                            for (int i = 0; i < listMission.length; i++)
                              pw.Row(children: [
                                pw.Text('          o  ',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text(listMission[i]),
                              ])
                          ],
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ]),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              width: 1800,
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                      color: PdfColors.blue,
                      style: pw.BorderStyle.solid,
                      width: 3)),
              child: pw.Column(children: [
                pw.Container(
                    padding: const pw.EdgeInsets.only(left: 5),
                    width: 1800,
                    height: 30,
                    color: PdfColors.blue,
                    child: pw.Text("Education:",
                        style: const pw.TextStyle(
                            color: PdfColors.white, fontSize: 18))),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Column(
                    children: education.map((map) {
                      String detailEduc = map['formation'] +
                          ', ' +
                          map['institution'] +
                          ', ' +
                          map['ville'] +
                          ', ' +
                          map['pays'];
                      return pw.Row(children: [
                        pw.Text('${map["annee"]}: '),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(splitString(detailEduc, 60, 10),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.justify),
                          ],
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ]),
            ),
            if (langueMait.isNotEmpty) pw.SizedBox(height: 20),
            if (langueMait.isNotEmpty)
              pw.Container(
                width: 1800,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: PdfColors.blue,
                        style: pw.BorderStyle.solid,
                        width: 3)),
                child: pw.Column(children: [
                  pw.Container(
                      padding: const pw.EdgeInsets.only(left: 5),
                      width: 1800,
                      height: 30,
                      color: PdfColors.blue,
                      child: pw.Text("Langues:",
                          style: const pw.TextStyle(
                              color: PdfColors.white, fontSize: 18))),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Table(
                      children: langueMait.map((map) {
                        int maitrise = map['maitrise'];
                        return pw.TableRow(children: [
                          pw.Text(splitString('${map["langue"]}:', 30, 0),
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Container(
                            width: 30,
                            child: pw.LinearProgressIndicator(
                                value: maitrise / 100,
                                valueColor: PdfColors.blue,
                                backgroundColor: PdfColors.white,
                                minHeight: 3),
                          ),
                          pw.Text('$maitrise%',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold))
                        ]);
                      }).toList(),
                    ),
                  ),
                ]),
              ),
            if (referencePro.isNotEmpty) pw.SizedBox(height: 20),
            if (referencePro.isNotEmpty)
              pw.Container(
                width: 1800,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: PdfColors.blue,
                        style: pw.BorderStyle.solid,
                        width: 3)),
                child: pw.Column(children: [
                  if (referencePro.isNotEmpty)
                    pw.Container(
                        padding: const pw.EdgeInsets.only(left: 5),
                        width: 1800,
                        height: 30,
                        color: PdfColors.blue,
                        child: pw.Text("Références:",
                            style: const pw.TextStyle(
                                color: PdfColors.white, fontSize: 18))),
                  if (referencePro.isNotEmpty)
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Table(
                        children: referencePro.map((map) {
                          return pw.TableRow(children: [
                            pw.Text(
                                '${map["entreprise"]}:                         ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Column(children: [
                              pw.Row(children: [
                                pw.Text('Poste occupé:      ',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text(splitString(map['poste'], 60, 0)),
                              ]),
                              pw.Row(children: [
                                pw.Text('Nom du référent:      ',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text(splitString(map['nom'], 60, 0)),
                              ]),
                              pw.Row(children: [
                                pw.Text('Numéro de téléphone:      ',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text(splitString(map['telephone'], 60, 0)),
                              ]),
                            ]),
                          ]);
                        }).toList(),
                      ),
                    ),
                ]),
              ),
          ];
        },
      ));
    } else if (formTamplate == 1) {
      final ByteData arialfontData =
          await rootBundle.load('lib/Assets/Fonts/arial.ttf');
      final Uint8List fontBytes =
          Uint8List.fromList(arialfontData.buffer.asUint8List());
      final pw.Font arialFont = pw.Font.ttf(fontBytes.buffer.asByteData());
      doc.addPage(pw.MultiPage(
        theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: arialFont)),
        margin: const pw.EdgeInsets.all(0),
        mainAxisAlignment: pw.MainAxisAlignment.start,
        pageFormat: PdfPageFormat.a3,
        build: (context) {
          return [
            pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                        padding: const pw.EdgeInsets.only(left: 5),
                        height: PdfPageFormat.a3.height,
                        width: PdfPageFormat.a3.width / 3,
                        color: PdfColors.blue700,
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 10),
                              ),
                              (imageBytes != null)
                                  ? pw.Padding(
                                      padding: const pw.EdgeInsets.only(
                                          top: 0, bottom: 0),
                                      child: pw.Container(
                                        color: PdfColors.blue700,
                                        height: 1120 / 5,
                                        width: 1120 / 5,
                                        padding: const pw.EdgeInsets.only(
                                            top: 15, bottom: 0),
                                        child: pw.Center(
                                          child: pw.Image(
                                            pw.MemoryImage(Uint8List.fromList(
                                                imageBytes!)),
                                          ),
                                        ),
                                      ),
                                    )
                                  : pw.SizedBox(width: 200, height: 200),
                              pw.SizedBox(height: 10),
                              pw.Container(
                                color: PdfColors.blue900,
                                height: 80,
                                child: pw.Center(
                                  child: pw.Text('Information Personnelle',
                                      textAlign: pw.TextAlign.justify,
                                      style: pw.TextStyle(
                                          fontSize: 20,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColors.white)),
                                ),
                              ),
                              pw.SizedBox(height: 10),
                              pw.Table(
                                children: [
                                  pw.TableRow(children: [
                                    pw.Text('Adresse:  ',
                                        style: pw.TextStyle(
                                            fontSize: 14,
                                            fontWeight: pw.FontWeight.bold,
                                            color: PdfColors.white)),
                                    pw.Text(splitString(adresse, 24, 0),
                                        style: const pw.TextStyle(
                                            color: PdfColors.white,
                                            fontSize: 15)),
                                  ]),
                                  pw.TableRow(children: [
                                    pw.Text('Téléphone:  ',
                                        style: pw.TextStyle(
                                            fontSize: 14,
                                            fontWeight: pw.FontWeight.bold,
                                            color: PdfColors.white)),
                                    pw.Text(splitString(telephone, 24, 0),
                                        style: const pw.TextStyle(
                                            color: PdfColors.white,
                                            fontSize: 15)),
                                  ]),
                                  pw.TableRow(children: [
                                    pw.Text('Email:  ',
                                        style: pw.TextStyle(
                                            fontSize: 14,
                                            fontWeight: pw.FontWeight.bold,
                                            color: PdfColors.white)),
                                    pw.Text(splitString(email, 24, 0),
                                        style: const pw.TextStyle(
                                            color: PdfColors.white,
                                            fontSize: 15)),
                                  ]),
                                ],
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 40),
                              ),
                              pw.Container(
                                color: PdfColors.blue900,
                                height: 50,
                                width: 350,
                                margin: const pw.EdgeInsets.only(top: 5),
                                child: pw.Text('Compétences',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                        fontSize: 20,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white)),
                              ),
                              pw.Table(
                                  children: compExp.map((comp) {
                                return pw.TableRow(children: [
                                  pw.Text('        o     ',
                                      style: pw.TextStyle(
                                          color: PdfColors.white,
                                          fontSize: 14,
                                          fontWeight: pw.FontWeight.bold)),
                                  pw.Text(comp['competence'],
                                      style: const pw.TextStyle(
                                        fontSize: 14,
                                        color: PdfColors.white,
                                      )),
                                  pw.Padding(
                                      padding:
                                          const pw.EdgeInsets.only(top: 10))
                                ]);
                              }).toList()),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 40),
                              ),
                              pw.Container(
                                color: PdfColors.blue900,
                                height: 50,
                                width: 350,
                                margin: const pw.EdgeInsets.only(top: 5),
                                child: pw.Text('Langues',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                        fontSize: 20,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white)),
                              ),
                              pw.Column(
                                  children: langueMait.map((langue) {
                                return pw.Row(children: [
                                  pw.Text('        o     ',
                                      style: pw.TextStyle(
                                          color: PdfColors.white,
                                          fontSize: 14,
                                          fontWeight: pw.FontWeight.bold)),
                                  pw.Text(
                                      "${langue['langue']} - ${langue['maitrise']}%",
                                      style: const pw.TextStyle(
                                        fontSize: 15,
                                        color: PdfColors.white,
                                      )),
                                  pw.Padding(
                                      padding:
                                          const pw.EdgeInsets.only(top: 10))
                                ]);
                              }).toList()),
                            ])),
                    pw.Container(
                      height: PdfPageFormat.a3.height,
                      width: PdfPageFormat.a3.width * 2 / 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            top: 30, right: 20, bottom: 0, left: 10),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    left: 10, top: 10, bottom: 20),
                                child: pw.Container(
                                    width: 500,
                                    padding:
                                        const pw.EdgeInsets.only(bottom: 15),
                                    decoration: const pw.BoxDecoration(
                                        border: pw.TableBorder(
                                            bottom: pw.BorderSide(
                                                width: 2,
                                                color: PdfColors.black))),
                                    child: pw.Text('$nom $prenom',
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 30,
                                            color: PdfColors.blue700))),
                              ),
                              pw.Paragraph(
                                  text: profil,
                                  style: const pw.TextStyle(fontSize: 14)),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    left: 10, top: 20, bottom: 20),
                                child: pw.Container(
                                    width: 500,
                                    padding:
                                        const pw.EdgeInsets.only(bottom: 15),
                                    decoration: const pw.BoxDecoration(
                                        border: pw.TableBorder(
                                            bottom: pw.BorderSide(
                                                width: 2,
                                                color: PdfColors.black))),
                                    child: pw.Text('Expérience Professionnelle',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 20,
                                            color: PdfColors.blue700))),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(10),
                                child: pw.Table(
                                  defaultVerticalAlignment:
                                      pw.TableCellVerticalAlignment.full,
                                  children: proExperience.map((map) {
                                    String missionsM = map['missions'];
                                    List<String> listMission =
                                        missionsM.split('\n');
                                    return pw.TableRow(
                                        verticalAlignment:
                                            pw.TableCellVerticalAlignment.full,
                                        children: [
                                          pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Text(
                                                  splitString(
                                                      '${map["poste"]},${map['entreprise']}, ${map['ville']}, ${map['pays']} ',
                                                      60,
                                                      10),
                                                  style: pw.TextStyle(
                                                      color: PdfColors.blue700,
                                                      fontWeight:
                                                          pw.FontWeight.bold,
                                                      fontSize: 18),
                                                  textAlign:
                                                      pw.TextAlign.justify),
                                              pw.Text('      \n\n    '),
                                              pw.Text(
                                                  '${map["startDate"]} - ${map["endDate"]}',
                                                  style: const pw.TextStyle(
                                                      fontSize: 18)),
                                              pw.Text('      \n    '),
                                              for (int i = 0;
                                                  i < listMission.length;
                                                  i++)
                                                pw.Row(children: [
                                                  pw.Text('      o    ',
                                                      style: pw.TextStyle(
                                                          fontWeight: pw
                                                              .FontWeight
                                                              .bold)),
                                                  pw.Text(
                                                      splitString(
                                                          listMission[i],
                                                          60,
                                                          10),
                                                      style: const pw.TextStyle(
                                                          fontSize: 18)),
                                                ]),
                                              pw.Text('      \n    '),
                                            ],
                                          ),
                                        ]);
                                  }).toList(),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    left: 10, top: 20, bottom: 20),
                                child: pw.Container(
                                    width: 500,
                                    padding:
                                        const pw.EdgeInsets.only(bottom: 15),
                                    decoration: const pw.BoxDecoration(
                                        border: pw.TableBorder(
                                            bottom: pw.BorderSide(
                                                width: 2,
                                                color: PdfColors.black))),
                                    child: pw.Text('Education',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 20,
                                            color: PdfColors.blue700))),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(10),
                                child: pw.Table(
                                  defaultVerticalAlignment:
                                      pw.TableCellVerticalAlignment.full,
                                  children: education.map((map) {
                                    String detailEduc = map['formation'] +
                                        ', ' +
                                        map['institution'] +
                                        ', ' +
                                        map['ville'] +
                                        ', ' +
                                        map['pays'];
                                    return pw.TableRow(
                                        verticalAlignment:
                                            pw.TableCellVerticalAlignment.full,
                                        children: [
                                          pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Text(detailEduc,
                                                  style: pw.TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          pw.FontWeight.bold),
                                                  textAlign:
                                                      pw.TextAlign.justify),
                                              pw.Text(
                                                  'Année d\'obtention:     ${map["annee"]}',
                                                  style: const pw.TextStyle(
                                                      fontSize: 16)),
                                              pw.Text('\n\n'),
                                            ],
                                          ),
                                        ]);
                                  }).toList(),
                                ),
                              )
                            ]),
                      ),
                    ),
                  ]),
            ]),
          ];
        },
      ));
    } else if (formTamplate == 2) {
      final ByteData robotofontData =
          await rootBundle.load('lib/Assets/Fonts/roboto.ttf');
      final Uint8List fontBytes =
          Uint8List.fromList(robotofontData.buffer.asUint8List());
      final pw.Font robotoFont = pw.Font.ttf(fontBytes.buffer.asByteData());
      doc.addPage(pw.MultiPage(
        maxPages: 100,
        theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: robotoFont)),
        pageFormat: PdfPageFormat.a3,
        margin: const pw.EdgeInsets.all(0),
        build: (context) {
          return [
            pw.Table(
              children: [
                pw.TableRow(children: [
                  (imageBytes != null)
                      ? pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 0, bottom: 0),
                          child: pw.Container(
                            color:
                                const PdfColor(195 / 256, 195 / 256, 195 / 256),
                            height: 1120 / 5,
                            width: 1120 / 5,
                            padding:
                                const pw.EdgeInsets.only(top: 15, bottom: 0),
                            child: pw.Center(
                              child: pw.Image(
                                pw.MemoryImage(Uint8List.fromList(imageBytes!)),
                              ),
                            ),
                          ),
                        )
                      : pw.SizedBox(width: 200, height: 200),
                  pw.Container(
                      width: 1120 * 2 / 5,
                      child: pw.Padding(
                          padding: const pw.EdgeInsets.only(
                              top: 30, right: 20, left: 40),
                          child: pw.Expanded(
                              child: pw.Column(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                pw.Container(
                                  padding: const pw.EdgeInsets.only(bottom: 10),
                                  decoration: const pw.BoxDecoration(
                                      border: pw.TableBorder(
                                          bottom: pw.BorderSide(
                                              color: PdfColors.yellow600,
                                              width: 5))),
                                  child: pw.Text('PROFIL PROFESSIONNEL',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 20,
                                      )),
                                ),
                                pw.Paragraph(
                                  text: profil,
                                  padding: const pw.EdgeInsets.only(top: 20),
                                  style: const pw.TextStyle(fontSize: 15),
                                ),
                              ]))))
                ], verticalAlignment: pw.TableCellVerticalAlignment.middle),
              ],
            ),
            pw.Table(
              children: [
                pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.yellow600),
                    children: [
                      pw.SizedBox(
                        height: max(lengthName(nom + prenom),
                            100 * titre.length.toDouble() / 16),
                        //(nom+prenom).length<16? 100: 120,
                        child: pw.Row(
                          children: [
                            pw.Container(
                              width: 1120 / 3.3,
                              height: 100 * titre.length / 16,
                              color: PdfColors.black,
                              child: pw.Center(
                                  child: pw.Text(titre,
                                      textAlign: pw.TextAlign.center,
                                      style: const pw.TextStyle(
                                          fontSize: 35,
                                          color: PdfColors.white))),
                            ),
                            pw.Text(splitString('   $nom $prenom', 25, 4),
                                textAlign: pw.TextAlign.center,
                                style: const pw.TextStyle(
                                  fontSize: 40,
                                ))
                          ],
                        ),
                      ),
                    ]),
              ],
            ),
            pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(children: [
                      pw.Container(
                          height: 200,
                          padding: const pw.EdgeInsets.all(20),
                          width: 290,
                          color:
                              const PdfColor(130 / 256, 130 / 256, 130 / 256),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('CONTACT',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                        fontSize: 20,
                                        color: PdfColors.white,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Padding(
                                    padding: const pw.EdgeInsets.only(top: 20)),
                                pw.Row(children: [
                                  pw.Icon(const pw.IconData(0xf041),
                                      font: fontAwesome,
                                      size: 15,
                                      color: PdfColors.white),
                                  pw.Text('    $adresse',
                                      style: const pw.TextStyle(
                                          fontSize: 14,
                                          color: PdfColors.white)),
                                ]),
                                pw.Text('\n'),
                                pw.Row(children: [
                                  pw.Icon(const pw.IconData(0xf095),
                                      font: fontAwesome,
                                      size: 15,
                                      color: PdfColors.white),
                                  pw.Text('    $telephone',
                                      style: const pw.TextStyle(
                                          fontSize: 14,
                                          color: PdfColors.white)),
                                ]),
                                pw.Text('\n'),
                                pw.Row(children: [
                                  pw.Icon(const pw.IconData(0xf0e0),
                                      font: fontAwesome,
                                      size: 15,
                                      color: PdfColors.white),
                                  pw.Text('    $email',
                                      style: const pw.TextStyle(
                                          fontSize: 14,
                                          color: PdfColors.white)),
                                ]),
                              ])),
                      pw.Container(
                        height: (50 * compExp.length).toDouble(),
                        padding: const pw.EdgeInsets.all(20),
                        width: 290,
                        color: const PdfColor(80 / 256, 80 / 256, 80 / 256),
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('EXPERTISE',
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(
                                      fontSize: 20,
                                      color: PdfColors.white,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.only(top: 20)),
                              pw.Table(
                                children: compExp.map((e) {
                                  return pw.TableRow(children: [
                                    pw.Text(e['competence'],
                                        style: const pw.TextStyle(
                                            fontSize: 14,
                                            color: PdfColors.white)),
                                    pw.Text('\n\n\n'),
                                  ]);
                                }).toList(),
                              ),
                            ]),
                      ),
                      pw.Container(
                        color: PdfColors.black,
                        padding: const pw.EdgeInsets.all(20),
                        width: 290,
                        height: (80 * education.length).toDouble(),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('EDUCATION',
                                textAlign: pw.TextAlign.left,
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Table(
                              children: education.map((e) {
                                return pw.TableRow(children: [
                                  pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Padding(
                                        padding:
                                            const pw.EdgeInsets.only(top: 10),
                                      ),
                                      pw.Text(e['institution'],
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 14,
                                              color: PdfColors.white)),
                                      pw.Text(e['formation'],
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 13,
                                              color: PdfColors.white)),
                                      pw.Text('${e['ville']}, ${e['pays']}',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 13,
                                              color: PdfColors.white)),
                                    ],
                                  ),
                                  pw.Padding(
                                      padding:
                                          const pw.EdgeInsets.only(top: 10),
                                      child: pw.Text(e['annee'],
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 13,
                                              color: PdfColors.white))),
                                ]);
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    pw.Container(
                      padding: const pw.EdgeInsets.only(
                          top: 20, left: 30, right: 20, bottom: 10),
                      width: 550,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            right: 20, bottom: 0, left: 10),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                padding: const pw.EdgeInsets.only(bottom: 10),
                                decoration: const pw.BoxDecoration(
                                    border: pw.TableBorder(
                                        bottom: pw.BorderSide(
                                            color: PdfColors.yellow600,
                                            width: 5))),
                                child: pw.Text('EXPERIENCE PROFESSIONNELLE',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 20,
                                    )),
                              ),
                              pw.Container(
                                width: 1800,
                                child: pw.Column(children: [
                                  pw.Text('\n\n'),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(10),
                                    child: pw.Column(
                                      children: proExperience.map((map) {
                                        String missionsM = map['missions'];
                                        List<String> listMission =
                                            missionsM.split('\n');
                                        return pw.Column(children: [
                                          pw.Row(
                                              mainAxisAlignment: pw
                                                  .MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                pw.Text('${map["poste"]}',
                                                    style: pw.TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: pw
                                                            .FontWeight.bold)),
                                                pw.Text('${map["entreprise"]}',
                                                    style: pw.TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: pw
                                                            .FontWeight.bold)),
                                                pw.Text(
                                                    '${map["startDate"]} - ${map["endDate"]}',
                                                    style: pw.TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: pw
                                                            .FontWeight.bold)),
                                              ]),
                                          pw.Text('\n'),
                                          pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              for (int i = 0;
                                                  i < listMission.length;
                                                  i++)
                                                pw.Row(children: [
                                                  pw.Text('o   ',
                                                      style: pw.TextStyle(
                                                          fontWeight: pw
                                                              .FontWeight
                                                              .bold)),
                                                  pw.Text(listMission[i]),
                                                ]),
                                              pw.Text('\n\n\n'),
                                            ],
                                          ),
                                        ]);
                                      }).toList(),
                                    ),
                                  ),
                                ]),
                              ),
                              pw.Container(
                                width: 550,
                                child: pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      top: 30, right: 20, bottom: 0, left: 10),
                                  child: pw.Column(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Container(
                                          padding: const pw.EdgeInsets.only(
                                              bottom: 10),
                                          decoration: const pw.BoxDecoration(
                                              border: pw.TableBorder(
                                                  bottom: pw.BorderSide(
                                                      color:
                                                          PdfColors.yellow600,
                                                      width: 5))),
                                          child: pw.Text('REFERENCE',
                                              style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                fontSize: 20,
                                              )),
                                        ),
                                        pw.Container(
                                          width: 1800,
                                          child: pw.Column(children: [
                                            pw.Padding(
                                              padding:
                                                  const pw.EdgeInsets.all(10),
                                              child: pw.Column(
                                                children:
                                                    referencePro.map((map) {
                                                  return pw.Column(children: [
                                                    pw.Text('\n\n'),
                                                    pw.Row(
                                                        mainAxisAlignment: pw
                                                            .MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          pw.Text(
                                                              'o  ${map["nom"]}',
                                                              style: pw.TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: pw
                                                                      .FontWeight
                                                                      .bold)),
                                                          pw.Text(
                                                              '${map["poste"]}',
                                                              style: pw.TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: pw
                                                                      .FontWeight
                                                                      .bold)),
                                                          pw.Text(
                                                              '${map["entreprise"]}',
                                                              style: pw.TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: pw
                                                                      .FontWeight
                                                                      .bold)),
                                                          pw.Text(
                                                              '${map["telephone"]}',
                                                              style: pw.TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: pw
                                                                      .FontWeight
                                                                      .bold))
                                                        ]),
                                                    pw.Text('\n'),
                                                  ]);
                                                }).toList(),
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ]),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ]),
            ]),
          ];
        },
      ));
    } else if (formTamplate == 3) {
      final ByteData verdanafontData =
          await rootBundle.load('lib/Assets/Fonts/verdana.ttf');
      final Uint8List fontBytes =
          Uint8List.fromList(verdanafontData.buffer.asUint8List());
      final pw.Font verdanaFont = pw.Font.ttf(fontBytes.buffer.asByteData());
      doc.addPage(pw.MultiPage(
        theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: verdanaFont)),
        margin: pw.EdgeInsets.zero,
        pageFormat: PdfPageFormat.a3,
        footer: (context) {
          return pw.Table(
            children: [
              pw.TableRow(
                  decoration: const pw.BoxDecoration(
                      color: PdfColor(15 / 255, 11 / 255, 96 / 255)),
                  children: [
                    pw.SizedBox(height: 20, width: 50),
                  ]),
              pw.TableRow(
                  decoration:
                      const pw.BoxDecoration(color: PdfColors.yellow600),
                  children: [
                    pw.SizedBox(height: 20, width: 50),
                  ]),
              pw.TableRow(
                  decoration: const pw.BoxDecoration(
                      color: PdfColor(15 / 255, 11 / 255, 96 / 255)),
                  children: [
                    pw.SizedBox(height: 20, width: 50),
                  ]),
            ],
          );
        },
        build: (context) {
          return [
            pw.Stack(children: [
              pw.Table(
                children: [
                  pw.TableRow(
                      decoration: const pw.BoxDecoration(
                          color: PdfColor(15 / 255, 11 / 255, 96 / 255)),
                      children: [
                        pw.Container(
                          height: (70 * '$nom $prenom'.length ~/ 27).toDouble(),
                          width: 150,
                          padding: const pw.EdgeInsets.only(left: 175),
                          child: pw.Center(
                              child: pw.Text('$prenom $nom',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      color: PdfColors.white,
                                      fontSize: 35,
                                      fontWeight: pw.FontWeight.bold))),
                        ),
                      ]),
                  pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(color: PdfColors.yellow600),
                      children: [
                        pw.SizedBox(height: 20, width: 150),
                      ]),
                ],
              ),
              pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.TableRow(
                    children: [
                      (imageBytes != null)
                          ? pw.Padding(
                              padding: const pw.EdgeInsets.only(
                                  top: 15, left: 15, right: 25),
                              child: pw.Container(
                                //height: 1120 / 3,
                                height: 200,
                                child: pw.Image(
                                  height: 200,
                                  pw.MemoryImage(
                                      Uint8List.fromList(imageBytes!)),
                                ),
                              ),
                            )
                          : pw.SizedBox(width: 200, height: 200),
                      /*(imageBytes != null)
                          ? pw.Padding(
                              padding: const pw.EdgeInsets.only(
                                  top: 45, left: 15, right: 25),
                              child: pw.Container(
                                  width: 200,
                                  child: pw.Center(
                                      child: pw.Image(
                                    alignment: pw.Alignment.topCenter,
                                    pw.MemoryImage(
                                        Uint8List.fromList(imageBytes!)),
                                  )),
                                ),

                            )
                          : pw.SizedBox(width: 100, height: 300),*/
                      pw.Paragraph(
                        padding: const pw.EdgeInsets.only(top: 150, right: 20),
                        text: profil,
                        style: const pw.TextStyle(fontSize: 16),
                        textAlign: pw.TextAlign.justify,
                      ),
                    ],
                  ),
                ],
              ),
            ]),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 35),
            ),
            pw.Table(
                border: const pw.TableBorder(
                    verticalInside: pw.BorderSide(
                        width: 3,
                        color: PdfColor(128 / 256, 128 / 256, 128 / 256))),
                children: [
                  pw.TableRow(children: [
                    pw.Container(
                      width: PdfPageFormat.a3.width / 3,
                      padding: const pw.EdgeInsets.only(left: 20, right: 20),
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Contact',
                              style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 20),
                          ),
                          pw.Row(children: [
                            pw.Icon(const pw.IconData(0xf041),
                                size: 15, font: fontAwesome),
                            pw.Text(splitString('    $adresse', 20, 4),
                                style: const pw.TextStyle(fontSize: 16)),
                          ]),
                          pw.Text('\n'),
                          pw.Row(children: [
                            pw.Icon(const pw.IconData(0xf095),
                                size: 15, font: fontAwesome),
                            pw.Text(splitString('    $telephone', 25, 4),
                                style: const pw.TextStyle(fontSize: 16)),
                          ]),
                          pw.Text('\n'),
                          pw.Row(children: [
                            pw.Icon(const pw.IconData(0xf0e0),
                                size: 15, font: fontAwesome),
                            pw.Text(splitString('    $email', 25, 4),
                                style: const pw.TextStyle(fontSize: 16)),
                          ]),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 30),
                          ),
                          pw.Text('Compétences',
                              style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 20),
                          ),
                          if (compExp.isNotEmpty)
                            pw.Column(
                              children: compExp
                                  .map((e) => pw.Row(children: [
                                        pw.Text('o    ',
                                            style: const pw.TextStyle(
                                                fontSize: 16)),
                                        pw.Text(
                                            splitString(e['competence'], 25, 4),
                                            style: const pw.TextStyle(
                                                fontSize: 16)),
                                      ]))
                                  .toList(),
                            ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 30),
                          ),
                          pw.Text("Centre d'intérêt",
                              style: pw.TextStyle(
                                  fontSize: 25,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 20),
                          ),
                          if (centreInteret.isNotEmpty)
                            pw.Column(
                              children: centreInteret
                                  .map((e) => pw.Row(children: [
                                        pw.Text('o    ',
                                            style: const pw.TextStyle(
                                                fontSize: 20)),
                                        pw.Text(e['centre'],
                                            style: const pw.TextStyle(
                                                fontSize: 16)),
                                      ]))
                                  .toList(),
                            ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 30),
                          ),
                          pw.Text("Langues",
                              style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 20),
                          ),
                          if (langueMait.isNotEmpty)
                            pw.Table(
                              children: langueMait
                                  .map((e) => pw.TableRow(children: [
                                        pw.Text('o    ${e['langue']}',
                                            style: const pw.TextStyle(
                                                fontSize: 16)),
                                        pw.Container(
                                          width: 50,
                                          decoration: pw.BoxDecoration(
                                              border: pw.Border.all(
                                                  color: const PdfColor(
                                                      15 / 255,
                                                      11 / 255,
                                                      96 / 255),
                                                  width: 5)),
                                          child: pw.LinearProgressIndicator(
                                              value: e['maitrise'] / 100,
                                              valueColor: PdfColors.yellow600,
                                              backgroundColor: PdfColors.black),
                                        ),
                                      ]))
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                    pw.Container(
                      width: PdfPageFormat.a3.width * 2 / 3,
                      padding: const pw.EdgeInsets.only(left: 30, right: 20),
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Expérience professionnelle",
                              style: pw.TextStyle(
                                  fontSize: 25,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 20),
                          ),
                          pw.Table(
                            defaultVerticalAlignment:
                                pw.TableCellVerticalAlignment.full,
                            children: proExperience.map((map) {
                              String missionsM = map['missions'];
                              List<String> listMission = missionsM.split('\n');
                              return pw.TableRow(
                                  verticalAlignment:
                                      pw.TableCellVerticalAlignment.full,
                                  children: [
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                            '${map["startDate"]} - ${map["endDate"]} | ${map["poste"]}',
                                            style: const pw.TextStyle(
                                                fontSize: 16)),
                                        pw.Text(
                                            '${map['entreprise']}, ${map['ville']}, ${map['pays']} ',
                                            style: pw.TextStyle(
                                                fontSize: 16,
                                                fontWeight: pw.FontWeight.bold),
                                            textAlign: pw.TextAlign.justify),
                                        for (int i = 0;
                                            i < listMission.length;
                                            i++)
                                          pw.Row(children: [
                                            pw.Text('       o  ',
                                                style: pw.TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        pw.FontWeight.bold)),
                                            pw.Text(listMission[i],
                                                style: pw.TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        pw.FontWeight.bold)),
                                          ]),
                                        pw.Text('\n'),
                                      ],
                                    ),
                                  ]);
                            }).toList(),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 20),
                          ),
                          pw.Text("Education",
                              style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 25),
                          ),
                          pw.Column(children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Table(
                                defaultVerticalAlignment:
                                    pw.TableCellVerticalAlignment.full,
                                children: education.map((map) {
                                  String detailEduc = map['formation'] +
                                      ', ' +
                                      map['institution'] +
                                      ', ' +
                                      map['ville'] +
                                      ', ' +
                                      map['pays'];
                                  return pw.TableRow(
                                      verticalAlignment:
                                          pw.TableCellVerticalAlignment.middle,
                                      children: [
                                        pw.Text('${map["annee"]}: $detailEduc',
                                            style: pw.TextStyle(
                                                fontSize: 16,
                                                fontWeight: pw.FontWeight.bold),
                                            textAlign: pw.TextAlign.justify),
                                        pw.Text('\n'),
                                      ]);
                                }).toList(),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ]),
                ]),
          ];
        },
      ));
    } else if (formTamplate == 4) {
      final ByteData georgiefontData =
          await rootBundle.load('lib/Assets/Fonts/georgia.ttf');
      final Uint8List fontBytes =
          Uint8List.fromList(georgiefontData.buffer.asUint8List());
      final pw.Font georgieFont = pw.Font.ttf(fontBytes.buffer.asByteData());
      doc.addPage(pw.MultiPage(
        theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: georgieFont)),
        pageFormat: PdfPageFormat.a3,
        margin: const pw.EdgeInsets.only(left: 0),
        build: (context) {
          return [
            pw.Column(children: [
              pw.Row(children: [
                pw.Container(
                  width: PdfPageFormat.a3.width * 0.06,
                  height: PdfPageFormat.a3.height,
                  color: PdfColors.blue,
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.only(left: 10, right: 20),
                  width: PdfPageFormat.a3.width * 0.28,
                  height: PdfPageFormat.a3.height,
                  decoration: const pw.BoxDecoration(
                      border: pw.TableBorder(
                          right:
                              pw.BorderSide(color: PdfColors.black, width: 3))),
                  //margin: const pw.EdgeInsets.only(top: 10),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      (imageBytes != null)
                          ? pw.Padding(
                              padding:
                                  const pw.EdgeInsets.only(top: 35, bottom: 10),
                              child: pw.Container(
                                height: 1120 / 5,
                                width: 1120 / 5,
                                child: pw.Center(
                                  child: pw.Image(
                                    pw.MemoryImage(
                                        Uint8List.fromList(imageBytes!)),
                                  ),
                                ),
                              ),
                            )
                          : pw.SizedBox(width: 400, height: 250),
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.TableBorder(
                                bottom: pw.BorderSide(
                                    color: PdfColors.blue, width: 3))),
                        padding: const pw.EdgeInsets.only(bottom: 2, top: 20),
                        child: pw.Text('PROFIL',
                            style: pw.TextStyle(
                              color: PdfColors.blue,
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            )),
                      ),
                      pw.Paragraph(
                        padding: const pw.EdgeInsets.only(top: 15),
                        text: profil,
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.TableBorder(
                                bottom: pw.BorderSide(
                                    color: PdfColors.blue, width: 3))),
                        padding: const pw.EdgeInsets.only(bottom: 2, top: 20),
                        child: pw.Text('COMPETENCES',
                            style: pw.TextStyle(
                              color: PdfColors.blue,
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            )),
                      ),
                      pw.Padding(padding: const pw.EdgeInsets.only(top: 15)),
                      if (compExp.isNotEmpty)
                        pw.Column(
                          children: compExp
                              .map((e) => pw.Row(children: [
                                    pw.Text('o    ',
                                        style:
                                            const pw.TextStyle(fontSize: 12)),
                                    pw.Text(e['competence'],
                                        style:
                                            const pw.TextStyle(fontSize: 12)),
                                  ]))
                              .toList(),
                        ),
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.TableBorder(
                                bottom: pw.BorderSide(
                                    color: PdfColors.blue, width: 3))),
                        padding: const pw.EdgeInsets.only(bottom: 2, top: 20),
                        child: pw.Text('LANGUES',
                            style: pw.TextStyle(
                              color: PdfColors.blue,
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            )),
                      ),
                      pw.Padding(padding: const pw.EdgeInsets.only(top: 15)),
                      pw.Table(
                        children: langueMait
                            .map((e) => pw.TableRow(
                                    verticalAlignment:
                                        pw.TableCellVerticalAlignment.middle,
                                    children: [
                                      pw.Text('o    ${e['langue']}',
                                          style:
                                              const pw.TextStyle(fontSize: 20)),
                                      pw.Container(
                                        width: 50,
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                                color: PdfColors.blue,
                                                width: 5)),
                                        child: pw.LinearProgressIndicator(
                                            value: e['maitrise'] / 100,
                                            valueColor: PdfColors.blue,
                                            backgroundColor: PdfColors.black),
                                      ),
                                    ]))
                            .toList(),
                      ),
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.TableBorder(
                                bottom: pw.BorderSide(
                                    color: PdfColors.blue, width: 3))),
                        padding: const pw.EdgeInsets.only(bottom: 2, top: 20),
                        child: pw.Text('COORDONNEES',
                            style: pw.TextStyle(
                              color: PdfColors.blue,
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            )),
                      ),
                      pw.Padding(padding: const pw.EdgeInsets.only(top: 15)),
                      pw.Row(children: [
                        pw.Icon(const pw.IconData(0xf041),
                            size: 15, font: fontAwesome),
                        pw.Text(splitString('    $adresse', 29, 4),
                            style: const pw.TextStyle(fontSize: 15)),
                      ]),
                      pw.Text('\n'),
                      pw.Row(children: [
                        pw.Icon(const pw.IconData(0xf095),
                            size: 15, font: fontAwesome),
                        pw.Text(splitString('    $telephone', 29, 4),
                            style: const pw.TextStyle(fontSize: 15)),
                      ]),
                      pw.Text('\n'),
                      pw.Row(children: [
                        pw.Icon(const pw.IconData(0xf0e0),
                            size: 15, font: fontAwesome),
                        pw.Text(splitString('    $email', 29, 4),
                            style: const pw.TextStyle(fontSize: 15)),
                      ]),
                      pw.Text('\n'),
                      if (dateNaissance.isNotEmpty)
                        pw.Row(children: [
                          pw.Icon(const pw.IconData(0xf1fd),
                              size: 15, font: fontAwesome),
                          pw.Text('    $dateNaissance',
                              style: const pw.TextStyle(fontSize: 15)),
                        ]),
                      pw.Text('\n'),
                      if (nationalite.isNotEmpty)
                        pw.Row(children: [
                          pw.Icon(const pw.IconData(0xf024),
                              size: 15, font: fontAwesome),
                          pw.Text(splitString('    $nationalite', 29, 4),
                              style: const pw.TextStyle(fontSize: 15)),
                        ]),
                    ],
                  ),
                ),
                pw.Container(
                  width: PdfPageFormat.a3.width * 0.66,
                  height: PdfPageFormat.a3.height,
                  padding:
                      const pw.EdgeInsets.only(left: 35, right: 10, top: 35),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(titre.toUpperCase(),
                          style: const pw.TextStyle(fontSize: 35)),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 10, bottom: 0),
                        child: pw.Container(
                            height: 1120 / 5,
                            child: pw.Text(
                              '$prenom $nom',
                              style: const pw.TextStyle(fontSize: 45),
                            )),
                      ),
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.TableBorder(
                                bottom: pw.BorderSide(
                                    color: PdfColors.blue, width: 3))),
                        padding: const pw.EdgeInsets.only(bottom: 2, top: -5),
                        child: pw.Text('EXPERIENCES',
                            style: pw.TextStyle(
                              color: PdfColors.blue,
                              fontSize: 25,
                              fontWeight: pw.FontWeight.bold,
                            )),
                      ),
                      pw.Padding(padding: const pw.EdgeInsets.only(top: 15)),
                      pw.Table(
                        children: proExperience.map((map) {
                          String missionsM = map['missions'];
                          List<String> listMission = missionsM.split('\n');
                          return pw.TableRow(
                              verticalAlignment:
                                  pw.TableCellVerticalAlignment.full,
                              children: [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Row(children: [
                                      pw.Text('${map["poste"]} ',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 16),
                                          textAlign: pw.TextAlign.justify),
                                      pw.SizedBox(width: 85),
                                      pw.Text(
                                          '${map["startDate"]} - ${map["endDate"]}',
                                          style: pw.TextStyle(
                                              fontSize: 16,
                                              fontWeight: pw.FontWeight.bold)),
                                    ]),
                                    pw.Text(
                                        '${map['entreprise'].toString().toUpperCase()}, ${map['ville'].toString().toUpperCase()}, ${map['pays'].toString().toUpperCase()} ',
                                        style: const pw.TextStyle(fontSize: 16),
                                        textAlign: pw.TextAlign.justify),
                                    pw.Text('\n'),
                                    for (int i = 0; i < listMission.length; i++)
                                      pw.Row(children: [
                                        pw.Text('o   ',
                                            style: pw.TextStyle(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                        pw.Text(listMission[i]),
                                      ]),
                                    pw.Text('\n\n\n'),
                                  ],
                                ),
                              ]);
                        }).toList(),
                      ),
                      pw.Padding(padding: const pw.EdgeInsets.only(top: 15)),
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.TableBorder(
                                bottom: pw.BorderSide(
                                    color: PdfColors.blue, width: 3))),
                        padding: const pw.EdgeInsets.only(bottom: 2, top: -5),
                        child: pw.Text('EDUCATION',
                            style: pw.TextStyle(
                              color: PdfColors.blue,
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            )),
                      ),
                      pw.Padding(padding: const pw.EdgeInsets.only(top: 15)),
                      pw.Table(
                        defaultVerticalAlignment:
                            pw.TableCellVerticalAlignment.full,
                        children: education.map((map) {
                          String detailEduc = map['formation'] +
                              '\n ' +
                              map['institution'] +
                              ', ' +
                              map['ville'] +
                              ', ' +
                              map['pays'];
                          return pw.TableRow(
                              verticalAlignment:
                                  pw.TableCellVerticalAlignment.full,
                              children: [
                                pw.Text('${map["annee"]}'),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(detailEduc,
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold),
                                        textAlign: pw.TextAlign.justify),
                                    pw.Text('\n\n'),
                                  ],
                                ),
                              ]);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ]),
            ]),
          ];
        },
      ));
    } else if (formTamplate == 5) {
      final ByteData timesFontData =
          await rootBundle.load('lib/Assets/Fonts/roboto.ttf');
      final Uint8List fontBytes =
          Uint8List.fromList(timesFontData.buffer.asUint8List());
      final pw.Font timesFont = pw.Font.ttf(fontBytes.buffer.asByteData());
      doc.addPage(pw.MultiPage(
        theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: timesFont)),
        pageFormat: PdfPageFormat.a3,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return [
            pw.Table(
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                      color: PdfColor(230 / 256, 230 / 256, 230 / 256)),
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.only(left: 25, right: 25),
                      height: PdfPageFormat.a3.height / 3,
                      width: PdfPageFormat.a3.width * 2 / 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 30),
                          pw.Text('$prenom $nom\n',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  font: timesFont,
                                  fontSize: 60,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text('- $titre -',
                              style: const pw.TextStyle(
                                  fontSize: 40, color: PdfColors.orange900)),
                          pw.Paragraph(
                            text: profil,
                            style: const pw.TextStyle(fontSize: 18),
                            padding: const pw.EdgeInsets.only(top: 25),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      height: PdfPageFormat.a3.height / 3,
                      width: PdfPageFormat.a3.width / 3,
                      child: (imageBytes != null)
                          ? pw.Padding(
                              padding: const pw.EdgeInsets.only(
                                  left: 10, top: 40, right: 10, bottom: 20),
                              child: pw.Center(
                                  child: pw.Image(
                                width: 400,
                                alignment: pw.Alignment.topCenter,
                                pw.MemoryImage(Uint8List.fromList(imageBytes!)),
                              )),
                            )
                          : pw.SizedBox(width: 400, height: 400),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.only(left: 25, right: 25),
                      height: PdfPageFormat.a3.height * 2 / 3,
                      width: PdfPageFormat.a3.width * 2 / 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 20),
                          pw.Text('EXPERIENCES PROFESSIONNELS',
                              style: const pw.TextStyle(
                                  fontSize: 20, color: PdfColors.orange900)),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(0),
                            child: pw.Table(
                              children: proExperience.map((map) {
                                String missionsM = map['missions'];
                                List<String> listMission =
                                    missionsM.split('\n');
                                return pw.TableRow(
                                    verticalAlignment:
                                        pw.TableCellVerticalAlignment.full,
                                    children: [
                                      pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                              '${map["poste"]}\n${map['entreprise']}, ${map['ville']}, ${map['pays']}\n ${map["startDate"]} - ${map["endDate"]} ',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  fontSize: 16),
                                              textAlign: pw.TextAlign.justify),
                                          pw.Text('      \n    '),
                                          for (int i = 0;
                                              i < listMission.length;
                                              i++)
                                            pw.Row(children: [
                                              pw.Text('o    ',
                                                  style: pw.TextStyle(
                                                      fontWeight:
                                                          pw.FontWeight.bold)),
                                              pw.Text(listMission[i],
                                                  style: const pw.TextStyle(
                                                      fontSize: 16)),
                                            ]),
                                          pw.Text('      \n\n   '),
                                        ],
                                      ),
                                    ]);
                              }).toList(),
                            ),
                          ),
                          pw.Text('\n\n'),
                          pw.Text('EDUCATION',
                              style: const pw.TextStyle(
                                  fontSize: 20, color: PdfColors.orange900)),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Table(
                              defaultVerticalAlignment:
                                  pw.TableCellVerticalAlignment.full,
                              children: education.map((map) {
                                String detailEduc = map['formation'] +
                                    ', ' +
                                    map['institution'] +
                                    ', ' +
                                    map['ville'] +
                                    ', ' +
                                    map['pays'];
                                return pw.TableRow(
                                    verticalAlignment:
                                        pw.TableCellVerticalAlignment.middle,
                                    children: [
                                      pw.Text('${map["annee"]}: $detailEduc',
                                          style: pw.TextStyle(
                                              fontSize: 16,
                                              fontWeight: pw.FontWeight.bold),
                                          textAlign: pw.TextAlign.justify),
                                      pw.Text('\n'),
                                    ]);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.only(left: 15, right: 15),
                      height: PdfPageFormat.a3.height * 2 / 3,
                      width: PdfPageFormat.a3.width / 3,
                      color: PdfColors.blueGrey800,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text('\n\n\n'),
                          pw.Text('CONTACT',
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                  fontSize: 20,
                                  color: PdfColors.white,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.only(top: 20)),
                          pw.Row(children: [
                            pw.Icon(const pw.IconData(0xf041),
                                size: 15,
                                color: PdfColors.white,
                                font: fontAwesome),
                            pw.Text(splitString('    $adresse', 30, 4),
                                style: const pw.TextStyle(
                                    fontSize: 16, color: PdfColors.white)),
                          ]),
                          pw.Row(children: [
                            pw.Icon(const pw.IconData(0xf095),
                                size: 15,
                                color: PdfColors.white,
                                font: fontAwesome),
                            pw.Text(splitString('    $telephone', 30, 4),
                                style: const pw.TextStyle(
                                    fontSize: 16, color: PdfColors.white)),
                          ]),
                          pw.Row(children: [
                            pw.Icon(const pw.IconData(0xf0e0),
                                size: 15,
                                color: PdfColors.white,
                                font: fontAwesome),
                            pw.Text(splitString('    $email', 30, 4),
                                style: const pw.TextStyle(
                                    fontSize: 16, color: PdfColors.white)),
                          ]),
                          pw.Text('\n\n\n'),
                          pw.Text('LANGUES',
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                  fontSize: 20,
                                  color: PdfColors.white,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text('\n\n'),
                          pw.Table(
                            children: langueMait
                                .map((e) => pw.TableRow(children: [
                                      pw.Text('o    ${e['langue']}',
                                          style: const pw.TextStyle(
                                              fontSize: 16,
                                              color: PdfColors.white)),
                                      pw.Container(
                                        width: 50,
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                                color: PdfColors.blue,
                                                width: 5)),
                                        child: pw.LinearProgressIndicator(
                                            value: e['maitrise'] / 100,
                                            valueColor: const PdfColor(
                                                230 / 256,
                                                230 / 256,
                                                230 / 256),
                                            backgroundColor: PdfColors.black),
                                      ),
                                    ]))
                                .toList(),
                          ),
                          pw.Text('\n\n'),
                          pw.Text('Compétences',
                              style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white)),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 20),
                          ),
                          if (compExp.isNotEmpty)
                            pw.Column(
                              children: compExp
                                  .map((e) => pw.Row(children: [
                                        pw.Text('o    ',
                                            style: const pw.TextStyle(
                                                fontSize: 16,
                                                color: PdfColors.white)),
                                        pw.Text(e['competence'],
                                            style: const pw.TextStyle(
                                                fontSize: 16,
                                                color: PdfColors.white)),
                                      ]))
                                  .toList(),
                            ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 30),
                          ),
                          pw.Text('\n\n'),
                          pw.Text("Centre d'intérêt",
                              style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 20),
                          ),
                          if (centreInteret.isNotEmpty)
                            pw.Column(
                              children: centreInteret
                                  .map((e) => pw.Row(children: [
                                        pw.Text('o    ',
                                            style: const pw.TextStyle(
                                                fontSize: 16,
                                                color: PdfColors.white)),
                                        pw.Text(e['centre'],
                                            style: const pw.TextStyle(
                                                fontSize: 16,
                                                color: PdfColors.white)),
                                      ]))
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ));
    }

    return doc.save();
  }
}

class DataManager {
  final int index;

  DataManager({required this.index});

  late Database formTamplateDatabase;

  Future<List<Map<String, dynamic>>> initformTamplateDatabase() async {
    formTamplateDatabase = await openDatabase(
      path.join(await getDatabasesPath(), 'formTamplate${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE formTamplate${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, num INTEGER)',
        );
      },
      version: 1,
    );
    return await _loadFormTamplate();
  }

  Future<List<Map<String, dynamic>>> _loadFormTamplate() async {
    List<Map<String, dynamic>> list =
        await formTamplateDatabase.query('formTamplate${index.toString()}');
    return list;
  }

  Future<void> saveFormTamplate(int num) async {
    formTamplateDatabase = await openDatabase(
      path.join(await getDatabasesPath(), 'formTamplate${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE formTamplate${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, num INTEGER)',
        );
      },
      version: 1,
    );
    await formTamplateDatabase.insert(
        'formTamplate${index.toString()}', {'num': num},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  late Database infoPersoDatabase;

  Future<List<Map<String, dynamic>>> initInfoPersoDatabase() async {
    infoPersoDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'personal_info_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE personal_info${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nom TEXT, prenom TEXT, dateNaissance TEXT,titre TEXT, profil TEXT, nationalite TEXT, '
          'sexe TEXT, adresse TEXT, telephone TEXT, email TEXT, '
          'situationMatrimoniale TEXT, image BLOB)',
        );
      },
      version: 1,
    );

    return await _loadPersonalInformation();
  }

  Future<List<Map<String, dynamic>>> _loadPersonalInformation() async {
    return await infoPersoDatabase.query('personal_info${index.toString()}');
  }

  Future<void> savePersonalInformation(
      String nom,
      String prenom,
      String? dateNaissance,
      String? titre,
      String? profil,
      String? nationalite,
      String? sexe,
      String? adresse,
      String? telephone,
      String? email,
      String? situationMatrimoniale,
      List<int>? image) async {
    infoPersoDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'personal_info_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE personal_info${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nom TEXT, prenom TEXT, dateNaissance TEXT,titre TEXT,profil TEXT, nationalite TEXT, '
          'sexe TEXT, adresse TEXT, telephone TEXT, email TEXT, '
          'situationMatrimoniale TEXT, image BLOB)',
        );
      },
      version: 1,
    );
    final personalInfo = {
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance,
      'titre': titre,
      'profil': profil,
      'nationalite': nationalite,
      'sexe': sexe,
      'adresse': adresse,
      'telephone': telephone,
      'email': email,
      'situationMatrimoniale': situationMatrimoniale,
      'image': image,
    };

    await infoPersoDatabase.insert(
        'personal_info${index.toString()}', personalInfo,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  late Database proObjectifDatabase;

  Future<List<Map<String, dynamic>>> initProObjectifDatabase() async {
    proObjectifDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'objectifs_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE objectifs${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, titre TEXT, resume TEXT)',
        );
      },
      version: 1,
    );
    return await _loadObjectifs();
  }

  Future<List<Map<String, dynamic>>> _loadObjectifs() async {
    return await proObjectifDatabase.query('objectifs${index.toString()}');
  }

  Future<void> saveObjectif(String titre, String resume) async {
    proObjectifDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'objectifs_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE objectifs${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, titre TEXT, resume TEXT)',
        );
      },
      version: 1,
    );
    await proObjectifDatabase.insert(
      'objectifs${index.toString()}',
      {'titre': titre, 'resume': resume},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteObjectif(String titre, String resume) async {
    proObjectifDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'objectifs_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE objectifs${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, titre TEXT, resume TEXT)',
        );
      },
      version: 1,
    );
    proObjectifDatabase.delete(
      'objectifs${index.toString()}',
      where: 'titre = ? AND resume = ?',
      whereArgs: [titre, resume],
    );
  }

  late Database proExperienceDatabase;

  Future<List<Map<String, dynamic>>> initProExperienceDatabase() async {
    proExperienceDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'experiences_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE experiences${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, entreprise TEXT, ville TEXT, pays TEXT, poste TEXT, missions TEXT, startDate TEXT, endDate TEXT)',
        );
      },
      version: 1,
    );
    return await _loadExperiences();
  }

  Future<List<Map<String, dynamic>>> _loadExperiences() async {
    return await proExperienceDatabase.query('experiences${index.toString()}');
  }

  Future<void> saveExperience(String entreprise, String ville, String pays,
      String poste, String missions, String startDate, String endDate) async {
    proExperienceDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'experiences_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE experiences${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, entreprise TEXT, ville TEXT, pays TEXT, poste TEXT, missions TEXT, startDate TEXT, endDate TEXT)',
        );
      },
      version: 1,
    );
    await proExperienceDatabase.insert(
      'experiences${index.toString()}',
      {
        'entreprise': entreprise,
        'ville': ville,
        'pays': pays,
        'poste': poste,
        'missions': missions,
        'startDate': startDate,
        'endDate': endDate
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteExperience(
      String entreprise, String poste, String startDate) async {
    proExperienceDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'experiences_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE experiences${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, entreprise TEXT, ville TEXT, pays TEXT, poste TEXT, missions TEXT, startDate TEXT, endDate TEXT)',
        );
      },
      version: 1,
    );
    await proExperienceDatabase.delete(
      'experiences${index.toString()}',
      where: 'entreprise = ? AND poste = ? AND startDate = ?',
      whereArgs: [entreprise, poste, startDate],
    );
  }

  late Database educationDatabase;

  Future<List<Map<String, dynamic>>> initEducationDatabase() async {
    educationDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'educations_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE educations${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, formation TEXT, institution TEXT, ville TEXT, pays TEXT, annee TEXT)',
        );
      },
      version: 1,
    );
    return await _loadEducations();
  }

  Future<List<Map<String, dynamic>>> _loadEducations() async {
    return await educationDatabase.query('educations${index.toString()}');
  }

  Future<void> saveEducation(String formation, String institution, String ville,
      String pays, String annee) async {
    educationDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'educations_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE educations${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, formation TEXT, institution TEXT, ville TEXT, pays TEXT, annee TEXT)',
        );
      },
      version: 1,
    );
    await educationDatabase.insert(
      'educations${index.toString()}',
      {
        'formation': formation,
        'institution': institution,
        'ville': ville,
        'pays': pays,
        'annee': annee,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteEducation(
      String formation, String institution, String annee) async {
    educationDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'educations_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE educations${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, formation TEXT, institution TEXT, ville TEXT, pays TEXT, annee TEXT)',
        );
      },
      version: 1,
    );
    educationDatabase.delete('educations${index.toString()}',
        where: 'formation = ? AND institution = ?  AND annee = ?',
        whereArgs: [formation, institution, annee]);
  }

  late Database certificationDatabase;

  Future<List<Map<String, dynamic>>> initCertificationDatabase() async {
    certificationDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'certifications_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE certifications${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, nomCertification TEXT, organismeCertification TEXT, dateCertification TEXT)',
        );
      },
      version: 1,
    );
    return await _loadCertifications();
  }

  Future<List<Map<String, dynamic>>> _loadCertifications() async {
    return await certificationDatabase
        .query('certifications${index.toString()}');
  }

  Future<void> saveCertification(String nomCertification,
      String organismeCertification, String dateCertification) async {
    certificationDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'certifications_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE certifications${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, nomCertification TEXT, organismeCertification TEXT, dateCertification TEXT)',
        );
      },
      version: 1,
    );
    await certificationDatabase.insert(
      'certifications${index.toString()}',
      {
        'nomCertification': nomCertification,
        'organismeCertification': organismeCertification,
        'dateCertification': dateCertification,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCertification(String nomCertification,
      String organismeCertification, String dateCertification) async {
    certificationDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'certifications_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE certifications${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, nomCertification TEXT, organismeCertification TEXT, dateCertification TEXT)',
        );
      },
      version: 1,
    );
    certificationDatabase.delete('certifications${index.toString()}',
        where:
            'nomCertification = ? AND organismeCertification = ? AND dateCertification = ?',
        whereArgs: [
          nomCertification,
          organismeCertification,
          dateCertification
        ]);
  }

  late Database competenceDatabase;

  Future<List<Map<String, dynamic>>> initCompetenceDatabase() async {
    competenceDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'competences_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE competences${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, competence TEXT, outil TEXT, niveau INTEGER)',
        );
      },
      version: 1,
    );
    return await _loadCompetences();
  }

  Future<List<Map<String, dynamic>>> _loadCompetences() async {
    return await competenceDatabase.query('competences${index.toString()}');
  }

  Future<void> saveCompetence(
      bool isGenerale, String competence, String outil) async {
    int niveau = isGenerale ? 0 : 1;
    competenceDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'competences_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE competences${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, competence TEXT, outil TEXT, niveau INTEGER)',
        );
      },
      version: 1,
    );
    await competenceDatabase.insert(
      'competences${index.toString()}',
      {
        'competence': competence,
        'outil': outil,
        'niveau': niveau,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCompetence(bool isGenerale, String competence) async {
    int niveau = isGenerale ? 0 : 1;
    competenceDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'competences_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE competences${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, competence TEXT, outil TEXT, niveau INTEGER)',
        );
      },
      version: 1,
    );
    await competenceDatabase.delete(
      'competences${index.toString()}',
      where: 'competence = ? AND niveau = ?',
      whereArgs: [competence, niveau],
    );
  }

  late Database langueDatabase;

  Future<List<Map<String, dynamic>>> initLangueDatabase() async {
    langueDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'langues_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE langues${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, langue TEXT, maitrise INTEGER)',
        );
      },
      version: 1,
    );
    return await _loadLangues();
  }

  Future<List<Map<String, dynamic>>> _loadLangues() async {
    final langues = await langueDatabase.query('langues${index.toString()}');
    return langues;
  }

  void ajouterLangue(String langue, int maitrise) async {
    langueDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'langues_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE langues${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, langue TEXT, maitrise INTEGER)',
        );
      },
      version: 1,
    );

    if (langue.isNotEmpty) {
      await langueDatabase.insert(
        'langues${index.toString()}',
        {'langue': langue, 'maitrise': maitrise},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  void supprimerLangue(String langue, int maitrise) async {
    langueDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'langues_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE langues${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, langue TEXT, maitrise INTEGER)',
        );
      },
      version: 1,
    );
    await langueDatabase.delete(
      'langues${index.toString()}',
      where: 'langue = ? AND maitrise = ?',
      whereArgs: [langue, maitrise],
    );
  }

  late Database centreInteretDatebase;

  Future<List<Map<String, dynamic>>> initDatabase() async {
    centreInteretDatebase = await openDatabase(
      path.join(await getDatabasesPath(),
          'centres_interet_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE centres_interet${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, centre TEXT)',
        );
      },
      version: 1,
    );
    return await _loadCentresInteret();
  }

  Future<List<Map<String, dynamic>>> _loadCentresInteret() async {
    final centresInteret =
        await centreInteretDatebase.query('centres_interet${index.toString()}');
    return centresInteret;
  }

  void ajouterCentreInteret(String centreInteret) async {
    centreInteretDatebase = await openDatabase(
      path.join(await getDatabasesPath(),
          'centres_interet_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE centres_interet${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, centre TEXT)',
        );
      },
      version: 1,
    );
    if (centreInteret.isNotEmpty) {
      await centreInteretDatebase.insert(
          'centres_interet${index.toString()}', {'centre': centreInteret},
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  void _supprimerCentreInteret(String centreInteret) async {
    centreInteretDatebase = await openDatabase(
      path.join(await getDatabasesPath(),
          'centres_interet_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE centres_interet${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, centre TEXT)',
        );
      },
      version: 1,
    );
    centreInteretDatebase.delete(
      'centres_interet${index.toString()}',
      where: 'centre = ?',
      whereArgs: [centreInteret],
    );
  }

  late Database referenceDatabase;

  Future<List<Map<String, dynamic>>> initDatabaseref() async {
    referenceDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'pro_references_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE pro_references${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT, poste TEXT, entreprise TEXT, telephone TEXT)',
        );
      },
      version: 1,
    );
    return await loadReferences();
  }

  Future<List<Map<String, dynamic>>> loadReferences() async {
    final references =
        await referenceDatabase.query('pro_references${index.toString()}');
    return references;
  }

  void ajouterReference(
      String nom, String poste, String entreprise, String telephone) async {
    referenceDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'pro_references_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE pro_references${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT, poste TEXT, entreprise TEXT, telephone TEXT)',
        );
      },
      version: 1,
    );

    if (nom.isNotEmpty &&
        poste.isNotEmpty &&
        entreprise.isNotEmpty &&
        telephone.isNotEmpty) {
      await referenceDatabase.insert(
        'pro_references${index.toString()}',
        {
          'nom': nom,
          'poste': poste,
          'entreprise': entreprise,
          'telephone': telephone
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  void supprimerReference(
      String nom, String poste, String entreprise, String telephone) async {
    referenceDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'pro_references_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE pro_references${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT, poste TEXT, entreprise TEXT, telephone TEXT)',
        );
      },
      version: 1,
    );

    await referenceDatabase.delete(
      'pro_references${index.toString()}',
      where: 'nom = ? AND poste = ? AND entreprise = ? AND telephone = ?',
      whereArgs: [nom, poste, entreprise, telephone],
    );
  }

  Future<void> deleteAllDatabase() async {
    await initDatabaseref();
    await initInfoPersoDatabase();
    await initLangueDatabase();
    await initProObjectifDatabase();
    await initProExperienceDatabase();
    await initCertificationDatabase();
    await initCompetenceDatabase();
    await initEducationDatabase();
    await initDatabase();
    List<String> dataBasePath = [];
    dataBasePath.add(path.join(await getDatabasesPath(),
        'pro_references_database${index.toString()}.db'));
    dataBasePath.add(path.join(await getDatabasesPath(),
        'centres_interet_database${index.toString()}.db'));
    dataBasePath.add(path.join(
        await getDatabasesPath(), 'langues_database${index.toString()}.db'));
    dataBasePath.add(path.join(await getDatabasesPath(),
        'competences_database${index.toString()}.db'));
    dataBasePath.add(path.join(await getDatabasesPath(),
        'certifications_database${index.toString()}.db'));
    dataBasePath.add(path.join(
        await getDatabasesPath(), 'educations_database${index.toString()}.db'));
    dataBasePath.add(
      path.join(
          await getDatabasesPath(), 'objectifs_database${index.toString()}.db'),
    );
    dataBasePath.add(path.join(await getDatabasesPath(),
        'personal_info_database${index.toString()}.db'));
    dataBasePath.add(path.join(await getDatabasesPath(),
        'experiences_database${index.toString()}.db'));
    if (referenceDatabase.isOpen) {
      await referenceDatabase.close();
    }
    if (centreInteretDatebase.isOpen) {
      await centreInteretDatebase.close();
    }
    if (langueDatabase.isOpen) {
      await langueDatabase.close();
    }
    if (competenceDatabase.isOpen) {
      await competenceDatabase.close();
    }
    if (certificationDatabase.isOpen) {
      await certificationDatabase.close();
    }
    if (educationDatabase.isOpen) {
      await educationDatabase.close();
    }
    if (proExperienceDatabase.isOpen) {
      await proExperienceDatabase.close();
    }
    if (proObjectifDatabase.isOpen) {
      await proObjectifDatabase.close();
    }
    if (infoPersoDatabase.isOpen) {
      await infoPersoDatabase.close();
    }
    for (var i = 0; i < dataBasePath.length; i++) {
      File refFile = File(dataBasePath[i]);
      if (refFile.existsSync()) {
        refFile.deleteSync();
      }
    }
  }
}
