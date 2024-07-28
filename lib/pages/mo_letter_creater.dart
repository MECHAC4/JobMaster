import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:job_master/pages/form_tamplate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:signature/signature.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/widgets.dart' as pw;

import 'dowload.dart';
import 'fonstions.dart';

class MoLetterCreator extends StatefulWidget {
  final int index;

  const MoLetterCreator({required this.index, super.key});

  @override
  State<MoLetterCreator> createState() => _MoLetterCreatorState();
}

class _MoLetterCreatorState extends State<MoLetterCreator> {
  late int indexi;
  int selectForm = 0;
  List<Color> selectColor = [
    Colors.blue,
    Colors.white54,
    Colors.white54,
    Colors.white54,
    Colors.white54,
    Colors.white54,
  ];
  Map<String, dynamic> headerInfo = {};

  final ScrollController _scrollController = ScrollController();

  InterstitialAd? _interstitialAd;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitInterId = 'ca-app-pub-7533781313698535/3860168975';

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
  void initState() {
    // TODO: implement initState
    indexi = widget.index;
    headerLoading();
    objectLoading();
    introductionLoading();
    bodyLoading();
    conclusionLoading();
    debugPrint("*************$_dateController************");
    _signatureController.addListener(() {
      exportS();
    });
    signatureLoading();
    super.initState();
  }

  Future<void> signatureLoading() async {
    Map<String, dynamic> s =
        await MoLetterDataManager(index: widget.index).initSignatureDatabase();
    List<dynamic> bytes = s["signature"];
    setState(() {
      if (bytes.isNotEmpty) {
        signature = Uint8List.fromList(bytes as List<int>);
      }
    });
  }

  Future<void> exportS() async {
    signature = await exportImage(context);
    MoLetterDataManager(index: widget.index).saveSignature(signature?.toList());
  }

  Future<void> headerLoading() async {
    headerInfo =
        await MoLetterDataManager(index: widget.index).initHeaderDatabase();
    _lieuController.text = headerInfo['lieu'];
    _nomExpController.text = headerInfo["nomExp"];
    _prenomExpController.text = headerInfo["prenomExp"];
    _adressExpController.text = headerInfo["adresseExp"];
    _telephoneExpController.text = headerInfo["telephoneExp"];
    _emailController.text = headerInfo["emailExp"];
    _nomEntrepriseController.text = headerInfo["nomEntreprise"];
    _adressEntrepriseController.text = headerInfo["adresseEntreprise"];
    String dateInfo = headerInfo['date'];
    setState(() {
      if (dateInfo.isEmpty) {
        _dateController = DateTime.now();
      } else {
        _dateController = DateTime.parse(headerInfo['date']);
      }
    });
  }

  Future<void> objectLoading() async {
    final objectM =
        await MoLetterDataManager(index: widget.index).initObjectDatabase();
    _objectController.text = objectM["object"];
  }

  Future<void> introductionLoading() async {
    final introM = await MoLetterDataManager(index: widget.index)
        .initIntroductionDatabase();
    _salutationController.text = introM["salutation"];
    _introductionController.text = introM["introduction"];
  }

  Future<void> bodyLoading() async {
    final bodyM =
        await MoLetterDataManager(index: widget.index).initBodyDatabase();
    _bodyController.text = bodyM["body"];
  }

  Future<void> conclusionLoading() async {
    final conclusionM =
        await MoLetterDataManager(index: widget.index).initConclusionDatabase();
    _conclusionController.text = conclusionM["conclusion"];
  }

  @override
  Widget build(BuildContext context) {
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
                    child: const Dowload(initialIndex: 1),
                    type: PageTransitionType.bottomToTop,
                    duration: const Duration(seconds: 1)));
          },
        ),
        centerTitle: true,
        title: Text(
          "Créer une lettre de motivation",
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 20,
              color: Colors.blue),
        ),
        backgroundColor: Colors.black12,
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 30,
            right: MediaQuery.of(context).size.width / 30),
        child: ListView(
          shrinkWrap: false,
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectColor[0], elevation: 10),
                      onPressed: () {
                        setState(() {
                          selectForm = 0;
                          _scrollToCenter(0);
                          selectColor = [
                            Colors.blue,
                            Colors.white54,
                            Colors.white54,
                            Colors.white54,
                            Colors.white54,
                            Colors.white54,
                          ];
                        });
                      },
                      child: Text(
                        "En-tête",
                        style: TextStyle(
                            color: (selectForm == 0) ? Colors.white : null),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectColor[1], elevation: 10),
                      onPressed: () {
                        setState(() {
                          selectForm = 1;
                          _scrollToCenter(1);
                          selectColor = [
                            Colors.white54,
                            Colors.blue,
                            Colors.white54,
                            Colors.white54,
                            Colors.white54,
                            Colors.white54,
                          ];
                        });
                      },
                      child: Text("Objet",
                          style: TextStyle(
                              color: (selectForm == 1) ? Colors.white : null))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectColor[2], elevation: 10),
                      onPressed: () {
                        setState(() {
                          selectForm = 2;
                          _scrollToCenter(2);
                          selectColor = [
                            Colors.white54,
                            Colors.white54,
                            Colors.blue,
                            Colors.white54,
                            Colors.white54,
                            Colors.white54,
                          ];
                        });
                      },
                      child: Text("Introduction",
                          style: TextStyle(
                              color: (selectForm == 2) ? Colors.white : null))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectColor[3], elevation: 10),
                      onPressed: () {
                        setState(() {
                          selectForm = 3;
                          _scrollToCenter(3);
                          selectColor = [
                            Colors.white54,
                            Colors.white54,
                            Colors.white54,
                            Colors.blue,
                            Colors.white54,
                            Colors.white54,
                          ];
                        });
                      },
                      child: Text("Corps de la lettre",
                          style: TextStyle(
                              color: (selectForm == 3) ? Colors.white : null))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectColor[4], elevation: 10),
                      onPressed: () {
                        setState(() {
                          selectForm = 4;
                          _scrollToCenter(4);
                          selectColor = [
                            Colors.white54,
                            Colors.white54,
                            Colors.white54,
                            Colors.white54,
                            Colors.blue,
                            Colors.white54,
                          ];
                        });
                      },
                      child: Text("Conclusion",
                          style: TextStyle(
                              color: (selectForm == 4) ? Colors.white : null))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectColor[5], elevation: 10),
                      onPressed: () {
                        setState(() {
                          selectForm = 5;
                          _scrollToCenter(5);
                          selectColor = [
                            Colors.white54,
                            Colors.white54,
                            Colors.white54,
                            Colors.white54,
                            Colors.white54,
                            Colors.blue,
                          ];
                        });
                      },
                      child: Text("Signature et identification",
                          style: TextStyle(
                              color: (selectForm == 5) ? Colors.white : null)))
                ],
              ),
            ),
            if (selectForm == 0) headerBuilder(),
            if (selectForm == 1) objectBuilder(),
            if (selectForm == 2) introductionBuilder(),
            if (selectForm == 3) bodyBuilder(),
            if (selectForm == 4) conclusionBuilder(),
            if (selectForm == 5) signatureBuilder(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        elevation: 100,
        onPressed: () {
          loadInterAd();
          _interstitialAd?.show();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FormLetter(index: widget.index, utilite: 0),
          ));
        },
        child: const Text("Voir la lettre",
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _scrollToCenter(int index) {
    setState(() {
      double buttonWidth = 120;
      double targetScroll = (index * buttonWidth) -
          MediaQuery.of(context).size.width / 2 +
          buttonWidth / 2;
      _scrollController.animateTo(targetScroll,
          duration: const Duration(microseconds: 500), curve: Curves.easeInOut);
    });
  }

  final TextEditingController _nomExpController = TextEditingController();
  final TextEditingController _prenomExpController = TextEditingController();
  final TextEditingController _lieuController = TextEditingController();
  DateTime _dateController = DateTime.now();
  final TextEditingController _adressExpController = TextEditingController();
  final TextEditingController _telephoneExpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomEntrepriseController =
      TextEditingController();
  final TextEditingController _adressEntrepriseController =
      TextEditingController();

  Widget headerBuilder() {
    return Column(
      //shrinkWrap: false,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 20,
        ),
        Center(
          child: Text(
            " Lieu et date: ",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 30,
        ),
        TextFormField(
          controller: _lieuController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Lieu",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            setState(() {
              MoLetterDataManager(index: indexi).saveHeaderInformation(
                  _lieuController.text,
                  _dateController.toString(),
                  _nomExpController.text,
                  _prenomExpController.text,
                  _adressExpController.text,
                  _telephoneExpController.text,
                  _emailController.text,
                  _nomEntrepriseController.text,
                  _adressEntrepriseController.text);
            });
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        DateTimeFormField(
          initialValue: _dateController.toString().isEmpty
              ? DateTime.now()
              : _dateController,
          decoration: const InputDecoration(
            hintStyle: TextStyle(color: Colors.black45),
            errorStyle: TextStyle(color: Colors.redAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: 'Date',
          ),
          mode: DateTimeFieldPickerMode.date,
          onChanged: (DateTime? value) {
            setState(() {
              _dateController = value!;
              setState(() {
                MoLetterDataManager(index: indexi).saveHeaderInformation(
                    _lieuController.text,
                    value.toString(),
                    _nomExpController.text,
                    _prenomExpController.text,
                    _adressExpController.text,
                    _telephoneExpController.text,
                    _emailController.text,
                    _nomEntrepriseController.text,
                    _adressEntrepriseController.text);
              });
            });
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        Center(
          child: Text(
            " Information sur l'expéditeur: ",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 30,
        ),
        TextFormField(
          controller: _nomExpController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Nom de l'expéditeur",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            setState(() {
              MoLetterDataManager(index: indexi).saveHeaderInformation(
                  _lieuController.text,
                  _dateController.toString(),
                  _nomExpController.text,
                  _prenomExpController.text,
                  _adressExpController.text,
                  _telephoneExpController.text,
                  _emailController.text,
                  _nomEntrepriseController.text,
                  _adressEntrepriseController.text);
            });
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        TextFormField(
          controller: _prenomExpController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Prénom de l'expéditeur",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            setState(() {
              MoLetterDataManager(index: indexi).saveHeaderInformation(
                  _lieuController.text,
                  _dateController.toString(),
                  _nomExpController.text,
                  _prenomExpController.text,
                  _adressExpController.text,
                  _telephoneExpController.text,
                  _emailController.text,
                  _nomEntrepriseController.text,
                  _adressEntrepriseController.text
              );
            });
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        TextFormField(
          controller: _adressExpController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Adresse de l'expéditeur",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            setState(() {
              MoLetterDataManager(index: indexi).saveHeaderInformation(
                  _lieuController.text,
                  _dateController.toString(),
                  _nomExpController.text,
                  _prenomExpController.text,
                  _adressExpController.text,
                  _telephoneExpController.text,
                  _emailController.text,
                  _nomEntrepriseController.text,
                  _adressEntrepriseController.text);
            });
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        TextFormField(
          controller: _telephoneExpController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Numéro de téléphone de l'expéditeur",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            setState(() {
              MoLetterDataManager(index: indexi).saveHeaderInformation(
                  _lieuController.text,
                  _dateController.toString(),
                  _nomExpController.text,
                  _prenomExpController.text,
                  _adressExpController.text,
                  _telephoneExpController.text,
                  _emailController.text,
                  _nomEntrepriseController.text,
                  _adressEntrepriseController.text);
            });
          },
          keyboardType: TextInputType.phone,
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Adresse email de l'expéditeur",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            setState(() {
              MoLetterDataManager(index: indexi).saveHeaderInformation(
                  _lieuController.text,
                  _dateController.toString(),
                  _nomExpController.text,
                  _prenomExpController.text,
                  _adressExpController.text,
                  _telephoneExpController.text,
                  _emailController.text,
                  _nomEntrepriseController.text,
                  _adressEntrepriseController.text);
            });
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        Center(
          child: Text(
            " Information sur le destinataire: ",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 30,
        ),
        TextFormField(
          controller: _nomEntrepriseController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Nom de l'entreprise",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            setState(() {
              debugPrint(
                  " voici le nom saisi: $value et voici celui récupéré: ${_nomEntrepriseController.text}");
              MoLetterDataManager(index: indexi).saveHeaderInformation(
                  _lieuController.text,
                  _dateController.toString(),
                  _nomExpController.text,
                  _prenomExpController.text,
                  _adressExpController.text,
                  _telephoneExpController.text,
                  _emailController.text,
                  _nomEntrepriseController.text,
                  _adressEntrepriseController.text);
            });
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        TextFormField(
          controller: _adressEntrepriseController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Adresse  de l'entreprise",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            setState(() {
              MoLetterDataManager(index: indexi).saveHeaderInformation(
                  _lieuController.text,
                  _dateController.toString(),
                  _nomExpController.text,
                  _prenomExpController.text,
                  _adressExpController.text,
                  _telephoneExpController.text,
                  _emailController.text,
                  _nomEntrepriseController.text,
                  _adressEntrepriseController.text);
            });
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                setState(() {
                  if (selectForm != 5) {
                    selectForm = selectForm + 1;
                    _scrollToCenter(selectForm);
                    for (int i = 0; i < 6; i++) {
                      i != selectForm
                          ? selectColor[i] = Colors.white54
                          : selectColor[i] = Colors.blue;
                    }
                  }
                });
              },
              child: const Text(
                "Suivant",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        )
      ],
    );
  }

  bool isObjectSelect = false;
  List<String> objectList = [
    "Candidature pour le poste de [nom du poste] chez [nom de l'entreprise]",
    "Candidature au poste de [nom du poste] chez [nom de l'entreprise]",
    "Demande de stage au sein de [nom de l'entreprise]",
    "Postulation pour le poste de [nom du poste] chez [nom de l'entreprise]",
    "Recherche d'opportunité de collaboration enrichissante chez [nom de l'entreprise]",
    "Demande d'opportunité professionnelle au sein de [nom de l'entreprise]",
    "Candidature pour la participation à la formation chez [nom de l'entreprise]"
  ];
  final TextEditingController _objectController = TextEditingController();
  final FocusNode _objectFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    _objectController.dispose();
    _objectFocusNode.dispose();
    _signatureController.dispose();
    _adressEntrepriseController.dispose();
    _nomEntrepriseController.dispose();
    _nomExpController.dispose();
    _lieuController.dispose();
    _emailController.dispose();
    _adressEntrepriseController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Widget objectBuilder() {
    late int i = objectList.length;
    return Column(
      children: [
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        Center(
          child: Text(
            " Objet de la lettre: ",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 30,
        ),
        TextFormField(
          focusNode: _objectFocusNode,
          controller: _objectController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Objet de la lettre",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            setState(() {
              MoLetterDataManager(index: widget.index)
                  .saveObject(_objectController.text);
            });
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        ExpansionTile(
            title: const Text(
              "Sélectionnez et personnalisez un objet préconçu",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: objectList.map((e) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isObjectSelect = true;
                    });
                    setState(() {
                      i = objectList.indexOf(e);
                      _objectController.text = e;
                      FocusScope.of(context).requestFocus(_objectFocusNode);
                      MoLetterDataManager(index: widget.index)
                          .saveObject(_objectController.text);
                    });
                  },
                  child: ListTile(
                    leading: Icon(
                      i != objectList.indexOf(e)
                          ? Icons.check_box_outline_blank_sharp
                          : Icons.check_box_outlined,
                      color: Colors.blue,
                    ),
                    title: Text(e),
                    enabled: i == objectList.indexOf(e) ? true : false,
                  ),
                ),
              );
            }).toList()),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                setState(() {
                  if (selectForm != 5) {
                    selectForm = selectForm + 1;
                    _scrollToCenter(selectForm);
                    for (int i = 0; i < 6; i++) {
                      i != selectForm
                          ? selectColor[i] = Colors.white54
                          : selectColor[i] = Colors.blue;
                    }
                  }
                });
              },
              child: const Text(
                "Suivant",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        )
      ],
    );
  }

  final TextEditingController _salutationController = TextEditingController();
  final TextEditingController _introductionController = TextEditingController();
  final FocusNode _introductionFocusNode = FocusNode();
  bool isIntroductionSelect = false;

  List<String> introductionList = [
    "Étudiant(e) en [votre domaine d'études], je suis à la recherche d'un stage de [durée] dans le cadre de ma formation. Je suis particulièrement intéressé(e) par [votre domaine d'expertise] et souhaite découvrir le monde professionnel en me confrontant à des situations concrètes.",
    "Je suis [votre titre] et je souhaite développer mes compétences dans le domaine de [votre domaine d'expertise]. Je suis particulièrement intéressé(e) par votre formation [nom de la formation] et souhaite en savoir plus sur son contenu et ses modalités d'inscription.",
    "Passionné(e) par [votre domaine d'expertise], je suis à la recherche d'une opportunité pour mettre mes compétences et mon expérience au service de votre entreprise. Je suis convaincu(e) que mon profil et ma motivation pourraient correspondre à vos besoins.",
    "Étudiant(e) en [votre domaine d'études], je suis à la recherche d'un programme d'alternance en [votre domaine d'expertise]. Ce type de formation me permettra d'acquérir une expérience professionnelle concrète tout en poursuivant mes études.",
    "En tant que [votre titre], je suis toujours à la recherche de nouveaux challenges et d'opportunités pour développer mes compétences. C'est pourquoi je suis particulièrement intéressé(e) par le poste de [poste] au sein de votre entreprise, dont les missions correspondent parfaitement à mes aspirations professionnelles.",
    "Lors de mon expérience chez [entreprise], j'ai réussi à [décrivez votre réussite]. Convaincu(e) de pouvoir apporter cette même valeur ajoutée à votre équipe, je vous adresse ma candidature pour le poste de [poste] au sein de votre entreprise.",
    "Je suis profondément motivé(e) par l'idée de rejoindre votre entreprise et de contribuer à son succès. Je suis persuadé(e) que mes compétences et mon expérience feraient de moi un membre précieux de votre équipe. C'est pourquoi je vous adresse ma candidature pour le poste de [poste] avec beaucoup d'intérêt.",
    "Passionné(e) par [votre domaine d'expertise] et titulaire d'un [votre diplôme] en [votre domaine], je souhaite mettre mes compétences au service de votre entreprise.",
    "Comme le disait [auteur], [citation]. C'est cette philosophie qui me guide dans ma carrière professionnelle et qui me motive à postuler au poste de [poste] au sein de votre entreprise, dont les valeurs me rejoignent profondément.",
    "Dès mon plus jeune âge, j'ai toujours été fasciné(e) par [votre domaine d'expertise]. Cette passion m'a conduit à [décrivez votre parcours], et aujourd'hui, je souhaite mettre mes compétences et mon expérience au service de votre entreprise."
  ];

  Widget introductionBuilder() {
    late int i = introductionList.length;
    _salutationController.text.isEmpty
        ? _salutationController.text = 'Madame/Monsieur'
        : null;
    return Column(
      children: [
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        Center(
          child: Text(
            " Introduction de la lettre: ",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 30,
        ),
        TextFormField(
          controller: _salutationController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Salutation",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            MoLetterDataManager(index: widget.index).saveIntroduction(
                _salutationController.text, _introductionController.text);
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        TextFormField(
          maxLines: null,
          focusNode: _introductionFocusNode,
          controller: _introductionController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Introduction",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            MoLetterDataManager(index: widget.index).saveIntroduction(
                _salutationController.text, _introductionController.text);
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        ExpansionTile(
            title: const Text(
              "Sélectionnez et personnalisez une introduction préconçue",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: introductionList.map((e) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isIntroductionSelect = true;
                    });
                    setState(() {
                      i = introductionList.indexOf(e);
                      _introductionController.text = e;
                      FocusScope.of(context)
                          .requestFocus(_introductionFocusNode);
                      MoLetterDataManager(index: widget.index).saveIntroduction(
                          _salutationController.text,
                          _introductionController.text);
                    });
                  },
                  child: ListTile(
                    leading: Icon(
                      i != introductionList.indexOf(e)
                          ? Icons.check_box_outline_blank_sharp
                          : Icons.check_box_outlined,
                      color: Colors.blue,
                    ),
                    title: Text(e),
                    enabled: i == introductionList.indexOf(e) ? true : false,
                  ),
                ),
              );
            }).toList()),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                setState(() {
                  if (selectForm != 5) {
                    selectForm = selectForm + 1;
                    _scrollToCenter(selectForm);
                    for (int i = 0; i < 6; i++) {
                      i != selectForm
                          ? selectColor[i] = Colors.white54
                          : selectColor[i] = Colors.blue;
                    }
                  }
                });
              },
              child: const Text(
                "Suivant",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        )
      ],
    );
  }

  List<Map<String, dynamic>> bodyList = [
    {
      "type": "Commercial(e)",
      "body": "        Votre entreprise, leader dans la vente de [produits/services], se distingue par son approche innovante et son engagement envers la satisfaction client. Votre développement exponentiel sur le marché [votre marché] et votre ambition à conquérir de nouvelles parts de marché m'inspirent particulièrement.\n"
          "        Doté(e) d'un excellent sens du relationnel et d'une grande force de persuasion, j'ai acquis une solide expérience de [durée] années en tant que commercial(e) dans le secteur [votre secteur]. J'ai développé une expertise dans la négociation de contrats B2B et la fidélisation client. Ma passion pour la vente et mon aptitude à analyser les besoins des clients me permettent de dépasser les objectifs fixés et de générer une croissance tangible du chiffre d'affaires.\n"
          "        Ma connaissance approfondie du marché [votre marché] et mon dynamisme commercial me permettront de m'intégrer rapidement à votre équipe de vente. En tant que véritable ambassadeur(rice) de votre marque, je contribuerai à l'expansion de votre clientèle et à l'atteinte de vos objectifs ambitieux de développement."
    },
    {
      "type": "Ingénieure(e)",
      "body": "        Votre entreprise, pionnière dans le domaine de la recherche et du développement en [technologie], me fascine par ses projets novateurs et son impact sur le progrès technologique. Votre engagement à repousser les limites du possible et à explorer de nouveaux horizons m'inspire profondément.\n"
          "        Ingénieur(e) diplômé(e) en [spécialisation] avec [durée] années d'expérience, je suis doté(e) d'un esprit d'innovation et d'une soif d'apprendre insatiable. Ma passion pour la recherche et mon expertise dans le développement d'algorithmes complexes et de solutions d'intelligence artificielle me permettent de proposer des solutions ingénieuses et de répondre aux défis technologiques les plus pointus.\n"
          "        Mon intégration au sein de votre équipe d'experts me permettra de mettre mon expertise au service de vos projets révolutionnaires. En collaborant étroitement avec vos talents, je contribuerai à la création d'innovations disruptives qui transformeront le paysage de l'industrie [votre domaine]."
    },
    {
      "type": "Graphiste",
      "body": "        Votre entreprise se distingue par son identité visuelle forte et créative, qui reflète son dynamisme et son engagement. Votre attention particulière à la communication visuelle et votre volonté de créer une expérience utilisateur optimale me motivent et m'inspirent.\n"
          "        Graphiste passionné(e) avec [durée] années d'expérience, je maîtrise parfaitement les logiciels de création graphique et suis à l'écoute des dernières tendances du design. Je suis doté(e) d'un sens de l'esthétique aiguisé et d'une grande capacité à traduire vos idées en images percutantes et originales, tout en respectant les exigences de votre charte graphique.\n"
          "        Mon intégration à votre équipe me permettra de proposer des solutions visuelles innovantes et en parfaite adéquation avec votre image de marque. En collaborant étroitement avec vos équipes marketing et communication, je contribuerai au renforcement de votre impact visuel et à l'accroissement de votre notoriété sur le marché.\n"
    },
    {
      "type": "Assistant(e) de direction",
      "body": "        Reconnue pour son [réputation de l'entreprise], votre entreprise évolue dans un environnement dynamique et international. Votre exigence d'excellence et votre culture d'entreprise collaborative correspondent parfaitement à mes aspirations professionnelles.\n"
          "        Rigoureux(se), organisé(e) et doté(e) d'excellentes capacités de communication, je possède [durée] années d'expérience en tant qu'assistant(e) de direction. Je suis parfaitement à l'aise dans un environnement multiculturel et capable de gérer de manière autonome les tâches administratives complexes. Mon sens de l'anticipation et mon aptitude à la gestion du temps me permettent d'assurer un support administratif optimal et de vous libérer du temps pour vous concentrer sur vos missions stratégiques.\n"
          "        Mon professionnalisme, ma discrétion et mon adaptabilité me permettront de m'intégrer rapidement à votre équipe et de vous épauler efficacement dans vos missions quotidiennes. En contribuant au bon fonctionnement de votre direction, je participerai activement au rayonnement de votre entreprise.\n"
    },
    {
      "type": "Développeur(euse) informatique",
      "body": "        Votre plateforme [type (web) ou nom] innovante et son interface utilisateur intuitive reflètent votre volonté de proposer une expérience utilisateur optimale. Votre engagement à développer des solutions numériques performantes et votre expertise technologique de pointe m'impressionnent particulièrement.\n"
          "        Développeur(euse) [type (web, mobile)] [front-end/back-end/full-stack] avec [durée] années d'expérience, je suis passionné(e) par les nouvelles technologies et doté(e) d'une solide connaissance des langages de programmation [type (web, mobile)]. Mon expérience en [mentionnez vos compétences techniques] me permet de créer des applications [type d’application (web)] performantes, sécurisées et respectueuses des standards du [web, mobile].\n"
          "        Mes compétences techniques et mon aptitude à travailler en équipe me permettront de m'intégrer facilement à votre équipe de développement. En participant activement à vos projets, je contribuerai à la création de solutions innovantes et à l'amélioration continue de votre plateforme."
    },
    {
      "type": "Chef(fe) de projet",
      "body": "        Votre entreprise est réputée pour sa démarche de gestion de projet rigoureuse et sa capacité à mener à bien des projets complexes. Votre culture d'entreprise orientée vers la collaboration et l'atteinte d'objectifs ambitieux me séduisent particulièrement.\n"
          "        Chef(fe) de projet expérimenté(e) avec [durée] années d'expérience, je suis doté(e) d'un excellent esprit d'équipe et d'une forte capacité à planifier, organiser et mener à bien des projets de grande envergure. Mes compétences en gestion des ressources et en communication me permettent de motiver et de coordonner les équipes pour atteindre les objectifs fixés, tout en respectant les délais et les budgets impartis.\n"
          "        Mon leadership, mon sens de la planification et mon aptitude à la gestion des risques me permettront de piloter efficacement vos projets et de garantir leur réussite. En collaborant étroitement avec vos équipes, je contribuerai à l'optimisation de vos process et à l'amélioration continue de votre performance globale."
    },
    {
      "type": "Juriste",
      "body": "        Votre cabinet d'avocats est reconnu pour son expertise pointue en droit [spécialisation du cabinet]. La complexité des dossiers que vous traitez et votre engagement à défendre les intérêts de vos clients avec rigueur et efficacité m'impressionnent particulièrement.\n"
          "        Juriste [spécialisation] diplômé(e) avec [durée] années d'expérience, je suis doté(e) d'un sens aigu de l'analyse et d'une parfaite maîtrise des textes juridiques. Mon expérience en [mentionnez vos expériences] me permet de traiter des dossiers complexes de manière rigoureuse et efficace. Je suis également à l'aise avec la recherche juridique et la rédaction de documents juridiques de qualité.\n"
          "        Mes compétences juridiques et mon sens du détail me permettront de m'intégrer rapidement à votre équipe d'avocats. En mettant mes connaissances et mon expertise à votre service, je contribuerai à la réussite de vos dossiers et à la défense optimale des intérêts de vos clients."
    },
    {
      "type": "Demande de formation",
      "body": "        Votre entreprise est reconnue pour son engagement dans le développement des compétences de ses collaborateurs. Votre programme de formation en \"[domaine de formation]\" correspond parfaitement à mon projet d'évolution professionnelle et me permettra d'acquérir les connaissances et les compétences nécessaires pour devenir [(Data Analyst)].\n"
          "        Titulaire d'un(e) [diplôme] en [votre domaine], j'ai [durée] années d'expérience en tant que [votre poste actuel]. J'ai développé un intérêt croissant pour [intérêt professionnel du domaine] et je suis convaincu que cette formation me permettra d'acquérir les compétences nécessaires pour évoluer vers un métier plus technique et en adéquation avec les besoins du marché.\n"
          "        Mon profil, ma motivation et ma capacité d'apprentissage me permettront de suivre avec succès cette formation et de m'intégrer rapidement à votre équipe [Domaine d’expertise de l’équipe]. En m'appropriant les outils et les techniques de [domaine de la formation], je contribuerai à [aptitudes que confèrent le formation]."
    },
    {
      "type": "Demande de stage",
      "body": "        Votre entreprise est spécialisée dans [domaine d’expertise de l’entreprise] et je suis fasciné par votre approche innovante et votre engagement à fournir des solutions performantes à vos clients. Je suis persuadé qu'un stage au sein de votre équipe me permettra d'acquérir une expérience concrète dans ce domaine et de mettre en pratique mes connaissances académiques.\n"
          "        Étudiant(e) en [année d’étude] de [cycle (licence/master/ingénieur] en [domaine], je suis passionné(e) par [domaine] et je suis doté(e) d'une solide connaissance des [compétences]. Je suis également capable de travailler en équipe et de m'adapter rapidement à de nouveaux environnements.\n"
          "        Mon profil, ma motivation et ma capacité d'apprentissage me permettront de m'intégrer rapidement à votre équipe de développement et de contribuer positivement à vos projets. En m'appropriant les exigences et les méthodologies de votre entreprise, je serai en mesure de vous proposer des solutions innovantes et de répondre aux besoins de vos clients."
    },
  ];
  final FocusNode _bodyFocusNode = FocusNode();
  final TextEditingController _bodyController = TextEditingController();

  Widget bodyBuilder() {
    late int i = bodyList.length;
    return Column(
      children: [
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        Center(
          child: Text(
            " Corps de la lettre: ",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 30,
        ),
        TextFormField(
          maxLines: null,
          focusNode: _bodyFocusNode,
          controller: _bodyController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "corps de la lettre",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            MoLetterDataManager(index: widget.index)
                .saveBody(_bodyController.text);
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        ExpansionTile(
            title: const Text(
              "Sélectionnez et personnalisez un corps de lettre préconçu",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: bodyList.map((e) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      i = bodyList.indexOf(e);
                      _bodyController.text = e["body"];
                      FocusScope.of(context).requestFocus(_bodyFocusNode);
                      MoLetterDataManager(index: widget.index)
                          .saveBody(_bodyController.text);
                    });
                  },
                  child: ListTile(
                    leading: Icon(
                      i != bodyList.indexOf(e)
                          ? Icons.check_box_outline_blank_sharp
                          : Icons.check_box_outlined,
                      color: Colors.blue,
                    ),
                    title: ExpansionTile(
                      title: Text(
                        "${e["type"]}",
                        style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 20),
                      ),
                      children: [
                        Text(e["body"]),
                      ],
                    ),
                    enabled: i == bodyList.indexOf(e) ? true : false,
                  ),
                ),
              );
            }).toList()),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                setState(() {
                  if (selectForm != 5) {
                    selectForm = selectForm + 1;
                    _scrollToCenter(selectForm);
                    for (int i = 0; i < 6; i++) {
                      i != selectForm
                          ? selectColor[i] = Colors.white54
                          : selectColor[i] = Colors.blue;
                    }
                  }
                });
              },
              child: const Text(
                "Suivant",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        )
      ],
    );
  }

  final FocusNode _conclusionFocusNode = FocusNode();
  final TextEditingController _conclusionController = TextEditingController();
  List<String> conclusionList = [
    "En vous remerciant de l'attention que vous porterez à ma candidature, je vous prie d'agréer, Madame, Monsieur, l'expression de mes salutations distinguées. Je suis convaincu(e) que mon profil correspond parfaitement à vos attentes et que je pourrais apporter une réelle valeur ajoutée à votre équipe.",
    "Je vous remercie de l'attention que vous porterez à ma candidature et j'espère avoir l'opportunité de vous rencontrer prochainement pour vous exposer plus en détail mon parcours et mes motivations.",
    "Je vous remercie de l'attention que vous porterez à ma candidature et vous prie d'agréer, Madame, Monsieur, l'expression de mes salutations distinguées. Je vous joins mon CV pour plus de détails sur mon parcours et mes compétences.",
    "Motivé(e) par les missions et les perspectives d'évolution offertes par ce poste, je serais ravi(e) de vous rencontrer pour vous exposer plus en détail mon parcours et mes motivations.",
    "Dynamique et motivé(e) par l'apprentissage, je suis persuadé(e) que ce stage me permettra d'acquérir les compétences et l'expérience nécessaires pour réussir dans mon domaine. Je suis impatient(e) de vous rencontrer et de vous parler plus en détail de mon projet professionnel.",
    "Convaincu(e) que cette formation me permettra d'atteindre mes objectifs professionnels, je suis impatient(e) de participer à ce programme et d'acquérir les compétences nécessaires pour réussir dans ce domaine. Je vous remercie de l'attention que vous porterez à ma candidature.",
    "Je suis persuadé(e) que ce stage me permettra de mettre en pratique mes connaissances et de développer de nouvelles compétences, tout en contribuant positivement à votre équipe. Je suis disponible pour un entretien à votre convenance.",
    "Mes compétences et mon expérience me permettront de m'intégrer rapidement à votre programme et de contribuer activement aux échanges et aux projets. Je suis enthousiaste à l'idée de participer à cette formation et de me perfectionner dans ce domaine.",
  ];

  Widget conclusionBuilder() {
    late int i = conclusionList.length;
    return Column(
      children: [
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        Center(
          child: Text(
            " Conclusion de la lettre: ",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        TextFormField(
          maxLines: null,
          focusNode: _conclusionFocusNode,
          controller: _conclusionController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Conclusion",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
          onChanged: (value) {
            MoLetterDataManager(index: widget.index)
                .saveConclusion(_conclusionController.text);
          },
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        ExpansionTile(
            title: const Text(
              "Sélectionnez et personnalisez une conclusion préconçue",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: conclusionList.map((e) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      i = conclusionList.indexOf(e);
                      _conclusionController.text = e;
                      FocusScope.of(context).requestFocus(_conclusionFocusNode);
                      MoLetterDataManager(index: widget.index)
                          .saveConclusion(_conclusionController.text);
                    });
                  },
                  child: ListTile(
                    leading: Icon(
                      i != conclusionList.indexOf(e)
                          ? Icons.check_box_outline_blank_sharp
                          : Icons.check_box_outlined,
                      color: Colors.blue,
                    ),
                    title: Text(e),
                    enabled: i == conclusionList.indexOf(e) ? true : false,
                  ),
                ),
              );
            }).toList()),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                setState(() {
                  if (selectForm != 5) {
                    selectForm = selectForm + 1;
                    _scrollToCenter(selectForm);
                    for (int i = 0; i < 6; i++) {
                      i != selectForm
                          ? selectColor[i] = Colors.white54
                          : selectColor[i] = Colors.blue;
                    }
                  }
                });
              },
              child: const Text(
                "Suivant",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        )
      ],
    );
  }

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.blue,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
    onDrawStart: () => debugPrint('onDrawStart called!'),
    onDrawEnd: () {
      debugPrint('enDrawStart called!');
    },
  );
  Uint8List? signature;

  Future<void> loadSignature() async {
    setState(() async {
      signature = await exportImage(context);
    });
  }

  void signatureL() {
    loadSignature();
  }

  Future<Uint8List?> exportImage(BuildContext context) async {
    final Uint8List? data = await _signatureController.toPngBytes(
      width: MediaQuery.of(context).size.width ~/ 1.5,
      height: MediaQuery.of(context).size.height ~/ 7,
    );
    return data;
  }

  Widget signatureBuilder() {
    return Column(
      children: [
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        Center(
          child: Text(
            " Signature et identification: ",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 30,
        ),
        TextFormField(
          controller: _nomExpController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Nom",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        TextFormField(
          controller: _prenomExpController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
            ),
            labelText: "Prénom ",
            focusColor: Colors.greenAccent,
            helperText: "Ce champ est recommandé",
          ),
        ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "    Signature",
              textAlign: TextAlign.start,
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width / 25),
            ),
            Container(
              //padding: EdgeInsets.all(MediaQuery.of(context).size.width/20),
              margin: EdgeInsets.all(MediaQuery.of(context).size.width / 25),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (signature != null && signature!.isNotEmpty)
                      ? Image.memory(signature!)
                      : Signature(
                          backgroundColor: Colors.white70,
                          controller: _signatureController,
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: MediaQuery.of(context).size.height / 7,
                        ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            _signatureController.clear();
                          });
                        },
                        icon: const Icon(Icons.delete)),
                  ),
                ],
              ),
            ),
            const Text("        Signez votre lettre dans le cadre")
          ],
        )
      ],
    );
  }
}

class MoLetterDataManager {
  final int index;

  MoLetterDataManager({required this.index});


  late Database formTamplateDatabase;

  Future<List<Map<String, dynamic>>> initformTamplateDatabase() async {
    formTamplateDatabase = await openDatabase(
      path.join(await getDatabasesPath(), 'formLTamplate${index.toString()}.db'),
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
    debugPrint("??????????????????????$list : valeur récupéré ????????????????????????");
    return list;
  }

  Future<void> saveFormTamplate(int num) async {
    formTamplateDatabase = await openDatabase(
      path.join(await getDatabasesPath(), 'formLTamplate${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE formTamplate${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, num INTEGER)',
        );
      },
      version: 1,
    );
    late int answer;
    answer = await formTamplateDatabase.insert(
        'formTamplate${index.toString()}', {'num': num},
        conflictAlgorithm: ConflictAlgorithm.replace);
    answer == 0? debugPrint("??????????????????????valeur: $num non enrégistré????????????"):debugPrint("??????????????????????valeur: $num  enrégistré????????????");
  }


  late Database headerDatabase;

  Future<Map<String, dynamic>> initHeaderDatabase() async {
    headerDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'header_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE header${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'lieu TEXT, date TEXT, nomExp TEXT,prenomExp TEXT, adresseExp TEXT, telephoneExp TEXT, '
            'emailExp TEXT, nomEntreprise TEXT, adresseEntreprise TEXT)');
      },
      version: 1,
    );
    return await _loadHeaderInfo();
  }

  Future<Map<String, dynamic>> _loadHeaderInfo() async {
    List<Map<String, dynamic>> listInfo =
        await headerDatabase.query('header${index.toString()}');
    return listInfo.isNotEmpty
        ? listInfo.last
        : {
            'lieu': "",
            'date': DateTime.now().toString(),
            'nomExp': "",
            'prenomExp': "",
            'adresseExp': "",
            'telephoneExp': "",
            'emailExp': "",
            'nomEntreprise': "",
            'adresseEntreprise': "",
          };
  }

  Future<void> saveHeaderInformation(
    String? lieu,
    String? date,
    String? nomExp,
    String? prenomExp,
    String? adresseExp,
    String? telephone,
    String? email,
    String? nomEntreprise,
    String? adresseEntreprise,
  ) async {
    headerDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'header_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE header${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'lieu TEXT, date TEXT, nomExp TEXT,prenomExp TEXT, adresseExp TEXT, telephoneExp TEXT, '
            'emailExp TEXT, nomEntreprise TEXT, adresseEntreprise TEXT)');
      },
      version: 1,
    );
    final headerInfo = {
      'lieu': lieu,
      'date': date,
      'nomExp': nomExp,
      'prenomExp': prenomExp,
      'adresseExp': adresseExp,
      'telephoneExp': telephone,
      'emailExp': email,
      'nomEntreprise': nomEntreprise,
      'adresseEntreprise': adresseEntreprise,
    };

    late int answer;

    answer = await headerDatabase.insert(
        'header${index.toString()}', headerInfo,
        conflictAlgorithm: ConflictAlgorithm.replace);
    answer == 0
        ? debugPrint(
            "!!!!!!!!!!!!!!!!!!! $headerInfo !!!!!!!!!!!!!!!!!!!! non enrégistré")
        : debugPrint(
            "************************** $headerInfo enrégistré **********************");
  }

  late Database objectDatabase;

  Future<Map<String, dynamic>> initObjectDatabase() async {
    objectDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'object_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE object${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'object TEXT)');
      },
      version: 1,
    );
    return await _loadObject();
  }

  Future<Map<String, dynamic>> _loadObject() async {
    List<Map<String, dynamic>> listInfo =
        await objectDatabase.query('object${index.toString()}');
    return listInfo.isNotEmpty ? listInfo.last : {'object': ""};
  }

  Future<void> saveObject(
    String? object,
  ) async {
    objectDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'object_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE object${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'object TEXT)');
      },
      version: 1,
    );
    debugPrint("******************objet: $object **************************");
    final objectM = {
      'object': object,
    };
    late int answer;

    answer = await objectDatabase.insert('object${index.toString()}', objectM,
        conflictAlgorithm: ConflictAlgorithm.replace);
    answer == 0
        ? debugPrint(
            "!!!!!!!!!!!!!!!!!!! $objectM !!!!!!!!!!!!!!!!!!!! non enrégistré")
        : debugPrint(
            "************************** $objectM enrégistré **********************");
  }

  late Database introductionDatabase;

  Future<Map<String, dynamic>> initIntroductionDatabase() async {
    introductionDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'introduction_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE introduction${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'salutation TEXT, introduction TEXT)');
      },
      version: 1,
    );
    return await _loadIntroduction();
  }

  Future<Map<String, dynamic>> _loadIntroduction() async {
    List<Map<String, dynamic>> listInfo =
        await introductionDatabase.query('introduction${index.toString()}');
    return listInfo.isNotEmpty
        ? listInfo.last
        : {
            "salutation": "",
            'introduction': "",
          };
  }

  Future<void> saveIntroduction(
    String? salutation,
    String? introduction,
  ) async {
    introductionDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'introduction_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE introduction${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'salutation TEXT, introduction TEXT)');
      },
      version: 1,
    );
    debugPrint(
        "******************objet: $salutation, $introduction **************************");
    final introductionM = {
      "salutation": salutation,
      'introduction': introduction,
    };
    late int answer;

    answer = await introductionDatabase.insert(
        'introduction${index.toString()}', introductionM,
        conflictAlgorithm: ConflictAlgorithm.replace);
    answer == 0
        ? debugPrint(
            "!!!!!!!!!!!!!!!!!!! $introductionM !!!!!!!!!!!!!!!!!!!! non enrégistré")
        : debugPrint(
            "************************** $introductionM enrégistré **********************");
  }

  late Database bodyDatabase;

  Future<Map<String, dynamic>> initBodyDatabase() async {
    bodyDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'body_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE body${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'body TEXT)');
      },
      version: 1,
    );
    return await _loadBody();
  }

  Future<Map<String, dynamic>> _loadBody() async {
    List<Map<String, dynamic>> listInfo =
        await bodyDatabase.query('body${index.toString()}');
    return listInfo.isNotEmpty ? listInfo.last : {"body": ""};
  }

  Future<void> saveBody(
    String? body,
  ) async {
    bodyDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'body_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE body${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'body TEXT)');
      },
      version: 1,
    );
    debugPrint("******************objet: $body **************************");
    final bodyM = {
      'body': body,
    };
    late int answer;

    answer = await bodyDatabase.insert('body${index.toString()}', bodyM,
        conflictAlgorithm: ConflictAlgorithm.replace);
    answer == 0
        ? debugPrint(
            "!!!!!!!!!!!!!!!!!!! $bodyM !!!!!!!!!!!!!!!!!!!! non enrégistré")
        : debugPrint(
            "************************** $bodyM enrégistré **********************");
  }

  late Database conclusionDatabase;

  Future<Map<String, dynamic>> initConclusionDatabase() async {
    conclusionDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'conclusion_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE conclusion${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'conclusion TEXT)');
      },
      version: 1,
    );
    return await _loadConclusion();
  }

  Future<Map<String, dynamic>> _loadConclusion() async {
    List<Map<String, dynamic>> listInfo =
        await conclusionDatabase.query('conclusion${index.toString()}');
    return listInfo.isNotEmpty ? listInfo.last : {"conclusion": ""};
  }

  Future<void> saveConclusion(
    String? conclusion,
  ) async {
    conclusionDatabase = await openDatabase(
      path.join(await getDatabasesPath(),
          'conclusion_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE conclusion${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'conclusion TEXT)');
      },
      version: 1,
    );
    debugPrint(
        "******************objet: $conclusion **************************");
    final conclusionM = {
      'conclusion': conclusion,
    };
    late int answer;
    answer = await conclusionDatabase.insert(
        'conclusion${index.toString()}', conclusionM,
        conflictAlgorithm: ConflictAlgorithm.replace);

    answer == 0
        ? debugPrint(
            "!!!!!!!!!!!!!!!!!!! $conclusionM !!!!!!!!!!!!!!!!!!!! non enrégistré")
        : debugPrint(
            "************************** $conclusionM enrégistré **********************");
  }

  late Database signatureDatabase;

  Future<Map<String, dynamic>> initSignatureDatabase() async {
    signatureDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'signature_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE signature${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'signature BLOB)');
      },
      version: 1,
    );
    return await _loadSignature();
  }

  Future<Map<String, dynamic>> _loadSignature() async {
    List<Map<String, dynamic>> listInfo =
        await signatureDatabase.query('signature${index.toString()}');
    return listInfo.isNotEmpty ? listInfo.last : {"signature": []};
  }

  Future<void> saveSignature(
    List<int>? signature,
  ) async {
    signatureDatabase = await openDatabase(
      path.join(
          await getDatabasesPath(), 'signature_database${index.toString()}.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE signature${index.toString()}(id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'signature BLOB)');
      },
      version: 1,
    );
    debugPrint(
        "******************objet: $signature **************************");
    final signatureM = {
      'signature': signature,
    };
    late int answer;
    answer = await signatureDatabase.insert(
        'signature${index.toString()}', signatureM,
        conflictAlgorithm: ConflictAlgorithm.replace);
    answer == 0
        ? debugPrint(
            "!!!!!!!!!!!!!!!!!!! $signatureM !!!!!!!!!!!!!!!!!!!! non enrégistré")
        : debugPrint(
            "************************** $signatureM enrégistré **********************");
  }

  Future<void> deleteAllDatabase() async {
    await initHeaderDatabase();
    await initObjectDatabase();
    await initIntroductionDatabase();
    await initBodyDatabase();
    await initConclusionDatabase();
    await initSignatureDatabase();
    List<String> dataBasePath = [];
    dataBasePath.add(path.join(
        await getDatabasesPath(), 'header_database${index.toString()}.db'));
    dataBasePath.add(path.join(
        await getDatabasesPath(), 'object_database${index.toString()}.db'));
    dataBasePath.add(path.join(await getDatabasesPath(),
        'introduction_database${index.toString()}.db'));
    dataBasePath.add(path.join(
        await getDatabasesPath(), 'body_database${index.toString()}.db'));
    dataBasePath.add(path.join(
        await getDatabasesPath(), 'conclusion_database${index.toString()}.db'));
    dataBasePath.add(path.join(
        await getDatabasesPath(), 'signature_database${index.toString()}.db'));

    if (headerDatabase.isOpen) {
      await headerDatabase.close();
    }
    if (objectDatabase.isOpen) {
      await objectDatabase.close();
    }
    if (introductionDatabase.isOpen) {
      await introductionDatabase.close();
    }
    if (bodyDatabase.isOpen) {
      await bodyDatabase.close();
    }
    if (conclusionDatabase.isOpen) {
      await conclusionDatabase.close();
    }
    if (signatureDatabase.isOpen) {
      await signatureDatabase.close();
    }

    for (var i = 0; i < dataBasePath.length; i++) {
      File refFile = File(dataBasePath[i]);
      if (refFile.existsSync()) {
        debugPrint(
            "!!!!!!!!!!!!!!!!${refFile.path} existe: ${refFile.existsSync()}!!!!!!!!!!!!!!!!!");
        refFile.deleteSync();
        debugPrint(
            "???????????????????????????????${refFile.path} existe: ${refFile.existsSync()}??????????????????????????????");
      }
    }
  }
}

class MoLetterMaker extends StatefulWidget {
  final int index;

  const MoLetterMaker({super.key, required this.index});

  @override
  State<MoLetterMaker> createState() => _MoLetterMakerState();
}

class _MoLetterMakerState extends State<MoLetterMaker> {
  late int indexi;
  PrintingInfo? printingInfo;
  late Map<String, dynamic> headerInfo;
  late Map<String, dynamic> object;
  late Map<String, dynamic> introduction;
  late Map<String, dynamic> body;
  late Map<String, dynamic> conclusion;
  late Map<String, dynamic> signature;
  late String nom;
  late String prenom;
  late String dateF1;
  late String dateF2;
  late String lieu;
  late String adresse;
  late String email;
  late String telephone;
  late String entreprise;
  late String adresseEntreprise;
  late String objectS;
  late String salutationS;
  late String introductionS;
  late String bodyS;
  late String conclusionS;
  Uint8List? signatureBytes;
  List<Map<String, dynamic>> formTamplateList = [];
  int formTamplate = 1;

  Future<void> loadInfo() async {
    List<int>? signatureI;
    formTamplateList =
    await MoLetterDataManager(index: widget.index).initformTamplateDatabase();
    headerInfo =
        await MoLetterDataManager(index: widget.index).initHeaderDatabase();
    object =
        await MoLetterDataManager(index: widget.index).initObjectDatabase();
    introduction = await MoLetterDataManager(index: widget.index)
        .initIntroductionDatabase();
    body = await MoLetterDataManager(index: widget.index).initBodyDatabase();
    conclusion =
        await MoLetterDataManager(index: widget.index).initConclusionDatabase();
    signature =
        await MoLetterDataManager(index: widget.index).initSignatureDatabase();

    setState(() {
      Map<String, dynamic> formM = {};
      formTamplateList.isNotEmpty ? formM = formTamplateList.last : null;
      formM.isNotEmpty ? formTamplate = formM['num'] : null;
    });

    lieu = headerInfo['lieu'] ?? '';
    nom = headerInfo["nomExp"] ?? '';
    prenom = headerInfo["prenomExp"] ?? '';
    adresse = headerInfo["adresseExp"] ?? '';
    telephone = headerInfo["telephoneExp"] ?? '';
    email = headerInfo["emailExp"] ?? '';
    entreprise = headerInfo["nomEntreprise"] ?? '';
    adresseEntreprise = headerInfo["adresseEntreprise"] ?? '';
    String dateInfo = headerInfo['date'] ?? '';

    objectS = object["object"] ?? '';
    salutationS = introduction["salutation"] ?? '';
    introductionS = introduction["introduction"] ?? '';
    bodyS = body["body"] ?? '';
    conclusionS = conclusion["conclusion"] ?? '';

    List<String> dateList1 = [];
    dateList1 = dateInfo.split(' ');
    String dateNaissance1 = '';
    dateNaissance1 = dateList1.first;
    List<String> dateList2 = [];
    dateList2 = dateNaissance1.split('-');
    List<String> dateNaissance2 = [];
    List<String> dateNaissance2P = [];

    List<String> moisY = [
      "Janvier",
      "Février",
      "Mars",
      "Avril",
      "Mai",
      "Juin",
      "Juillet",
      "Août",
      "Septempbre",
      "Octobre",
      "Novembre",
      "Décembre"
    ];
    List<String> moisI = [
      "01",
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "10",
      "11",
      "12"
    ];
    String mois = '';
    for (int i = 0; i < dateList2.length; i++) {
      dateNaissance2.add(dateList2[dateList2.length - 1 - i]);
      if (i != 1) {
        dateNaissance2P.add(dateList2[dateList2.length - 1 - i]);
      }

      if (i == 1) {
        String moisInfo = dateList2[i];
        for (int j = 0; j < moisY.length; j++) {
          if (moisInfo.trim() == moisI[j]) {
            setState(() {
              mois = moisY[j];
              dateNaissance2P.add(mois);
            });
            break;
          }
        }
      }
    }
    dateF1 = dateNaissance2.join('/');
    dateF2 = dateNaissance2P.join(' ');
    List<dynamic> sign = [];
    sign = signature["signature"];
    signatureI = sign.cast<int>();
    setState(() {
      if (signatureI!.isNotEmpty) {
        signatureBytes = Uint8List.fromList(signatureI);
      }
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
            icon: Icon(Icons.download), onPressed: saveAsLFile)
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
        title: const Text("Ma Lettre de Motivation"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MoLetterCreator(index: indexi),
                  ));
                },
                icon: const Icon(Icons.edit),
                color: Colors.black),
          )
        ],
      ),
      body: PdfPreview(
        build: generateLetter,
        actions: actions,
        onPrinted: showLShared,
        onShared: showLPrinted,
        canDebug: false,
        canChangeOrientation: false,
      ),
    );
  }

  Future<Uint8List> generateLetter(final PdfPageFormat format) async {
    await loadInfo();
    final ByteData fontData =
        await rootBundle.load('lib/Assets/Fonts/awesone.ttf');
    final Uint8List fontBytes =
        Uint8List.fromList(fontData.buffer.asUint8List());
    final pw.Font fontAwesome = pw.Font.ttf(fontBytes.buffer.asByteData());
    final doc = pw.Document(title: 'lettre$indexi.pdf');
    if (formTamplate == 0) {
      doc.addPage(pw.MultiPage(
        build: (context) {
          return [
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("${prenom.trim()} ${nom.trim()}",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(adresse.trim()),
                  pw.Text(telephone.trim()),
                  pw.Text(email.trim(),
                      style: const pw.TextStyle(color: PdfColors.blue))
                ]),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: -8),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(splitString(entreprise.trim(), 20, 0),
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.right),
                        //pw.Text(splitString(adresseEntreprise.trim(), 20, 0), textAlign: pw.TextAlign.right),
                        pw.Text("${adresseEntreprise.trim()}\n\n\n")
                      ])
                ],
              ),
            ),
            pw.Container(
              //margin: const pw.EdgeInsets.only(top: 20),
              padding: const pw.EdgeInsets.only(
                  left: 10, bottom: 15, right: 10, top: 8),
              decoration: pw.BoxDecoration(border: pw.Border.all(width: 2)),
              width: PdfPageFormat.a4.width,
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Objet:",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Center(
                        child: pw.Text(objectS,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)))
                  ]),
            ),
             pw.Align(
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Text("\n\n${lieu.trim()}, le ${dateF2.trim()}")),


               pw.Align(
                alignment: pw.Alignment.bottomLeft,
                child: pw.Text("\n${salutationS.trim()},\n\n"),
              ),

            pw.Paragraph(text: "        ${introductionS.trim()}"),
            pw.Paragraph(text: "        ${bodyS.trim()}"),
            pw.Paragraph(text: "        ${conclusionS.trim()}"),
            pw.Align(
              alignment: pw.Alignment.bottomRight,
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("${prenom.trim()} ${nom.trim()}\n",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    (signatureBytes!=null && signatureBytes!.isNotEmpty)?
                    pw.Image(
                      height: 40,
                      width: 100,
                      pw.MemoryImage(signatureBytes!),
                    ): pw.Text(""),
                  ]),
            ),
          ];
        },
      ));
    } else
      if (formTamplate == 1) {
        final ByteData footerData =
        await rootBundle.load('lib/Assets/Images/LetterImage/footer1.jpg');
        final Uint8List footerBytes =
        Uint8List.fromList(footerData.buffer.asUint8List());
      doc.addPage(pw.MultiPage(
        margin: const pw.EdgeInsets.all(0),
        footer: (context) {
          return pw.Align(
            alignment: pw.Alignment.bottomRight,
            child: pw.Image(
                height: 75,
                //width: 250,
                pw.MemoryImage(footerBytes)
            ),
          );
        },
        header: (context) {
          return pw.Container(
              //color: const PdfColor(33/256, 108/256, 108/256),
              width: 400,
              height: 80,
              //0.785/2
              transform: Matrix4.rotationZ(1.249 / 5),
              decoration: pw.BoxDecoration(
                color: const PdfColor(10 / 256, 135 / 256, 135 / 256),
                shape: pw.BoxShape.rectangle,
                border: pw.Border.all(
                    color: const PdfColor(10 / 256, 135 / 256, 135 / 256)),
              ));
        },
        build: (context) {
          return [
            pw.Padding(
                padding: const pw.EdgeInsets.all(30),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                          "\n${prenom.trim().toUpperCase()} ${nom.trim().toUpperCase()}",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 20)),
                      pw.Text(telephone.trim()),
                      pw.Text(email.trim()),
                      pw.Text(adresse.trim()),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: -100),
                        child: pw.Align(
                            alignment: pw.Alignment.topRight,
                            child:
                                pw.Text("${lieu.trim()} le ${dateF1.trim()}")),
                      ),
                      pw.Align(
                        alignment: pw.Alignment.topRight,
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(entreprise.trim(),
                                  textAlign: pw.TextAlign.right),
                              pw.Text(adresseEntreprise.trim(),
                                  textAlign: pw.TextAlign.right)
                            ]),
                      ),
                      pw.Text("\n\n\nObjet : ${objectS.trim()}",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("\n\n\n\n${salutationS.trim()},"),
                      pw.Text("\n\n\n     ${introductionS.trim()}"),
                      pw.Text("\n     ${bodyS.trim()}"),
                      pw.Text("\n     ${conclusionS.trim()}"),
                      pw.Align(
                        alignment: pw.Alignment.bottomRight,
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text("\n\n${prenom.trim()} ${nom.trim()}\n",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                              (signatureBytes!=null && signatureBytes!.isNotEmpty)?
                              pw.Image(
                                height: 40,
                                width: 100,
                                pw.MemoryImage(signatureBytes!),
                              ): pw.Text(""),
                            ]),
                      ),
                    ]))
          ];
        },
      ));
    } else
      if (formTamplate == 2) {
      doc.addPage(
        pw.MultiPage(
          build: (context) {
            return [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("${prenom.trim()}\n${nom.trim()}",
                        style:  pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                            color: PdfColors.orange900, fontSize: 20)),
                    pw.Align(
                      alignment: pw.Alignment.topRight,
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          //mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Row(children: [
                              pw.Icon(const pw.IconData(0xf095),
                                  font: fontAwesome,
                                  size: 15,
                                  color: PdfColors.orange900),
                              pw.Text('    $telephone',
                                  style: const pw.TextStyle(
                                    fontSize: 14,
                                  )),
                            ]),
                            pw.Row(children: [
                              pw.Icon(const pw.IconData(0xf0e0),
                                  font: fontAwesome,
                                  size: 15,
                                  color: PdfColors.orange900),
                              pw.Text('    $email',
                                  style: const pw.TextStyle(
                                    fontSize: 14,
                                  )),
                            ]),
                            pw.Row(children: [
                              pw.Icon(const pw.IconData(0xf041),
                                  font: fontAwesome,
                                  size: 15,
                                  color: PdfColors.orange900),
                              pw.Text('    $adresse',
                                  style: const pw.TextStyle(
                                    fontSize: 14,
                                  )),
                            ]),
                          ]),
                    )
                  ]),
              pw.Text("\n\n\n\n"),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(entreprise.trim(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(adresse.trim()),
                      ]
                  ),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text("${lieu.trim()}, le ${dateF2.trim()}", style: const pw.TextStyle(color: PdfColors.orange900)),
                  )
                ]
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 30, right: 30, top: 25),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Objet: ${objectS.trim()}\n\n\n\n", style: const pw.TextStyle(color: PdfColors.orange900)),
                    pw.Text("${salutationS.trim()},", textAlign: pw.TextAlign.justify),
                    pw.Text("\n\n"),
                    pw.Text("        ${introductionS.trim()}\n\n",textAlign: pw.TextAlign.justify),
                    pw.Text("        ${bodyS.trim()}\n\n", textAlign: pw.TextAlign.justify),
                    pw.Text("        ${conclusionS.trim()}\n\n", textAlign: pw.TextAlign.justify),
                  ]
                )
              ),
              pw.Text("\n\n"),
              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("\n\n${prenom.trim()} ${nom.trim()}\n",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold)),
                      (signatureBytes!=null && signatureBytes!.isNotEmpty)?
                      pw.Image(
                        height: 40,
                        width: 100,
                        pw.MemoryImage(signatureBytes!),
                      ): pw.Text(""),
                    ]),
              ),
            ];
          },
        ),
      );
    } else
      if(formTamplate == 3){

        final ByteData footerData =
        await rootBundle.load('lib/Assets/Images/LetterImage/footer2.jpg');
        final Uint8List footerBytes =
        Uint8List.fromList(footerData.buffer.asUint8List());

        doc.addPage(
          pw.MultiPage(
            margin: const pw.EdgeInsets.all(0),
            header: (context) {
              return pw.Container(
                height: 40,
                color: const PdfColor(245/256, 245/256, 245/256),
              );
            },
            footer: (context) {
              return pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Image(
                  height: 100,
                  width: 200,
                  pw.MemoryImage(footerBytes)
                ),
              );
            },
            build: (context) {
              return [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 40, right: 40, top: 20),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("${prenom.trim()} ${nom.trim()}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("${adresse.trim()} "),
                      pw.Text("${telephone.trim()} "),
                      pw.Text("${email.trim()} "),
                      pw.Align(
                        alignment: pw.Alignment.topRight,
                        child: pw.Text("${entreprise.trim()}\n${adresseEntreprise.trim()}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                      ),
                      pw.Text("\n\n\n${lieu.trim()} le ${dateF2.trim()}\n\n"),
                      pw.Text("\n\n\nObjet : ${objectS.trim()}\n\n", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("\n\n\n${salutationS.trim()},\n\n\n"),
                      pw.Text("        ${introductionS.trim()}\n\n", textAlign: pw.TextAlign.justify),
                      pw.Text("        ${bodyS.trim()}\n\n", textAlign: pw.TextAlign.justify),
                      pw.Text("        ${conclusionS.trim()}\n\n", textAlign: pw.TextAlign.justify),
                      pw.Text("\n\n"),
                      pw.Align(
                        alignment: pw.Alignment.bottomRight,
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text("\n\n${prenom.trim()} ${nom.trim()}\n",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                              (signatureBytes!=null && signatureBytes!.isNotEmpty)?
                              pw.Image(
                                height: 40,
                                width: 100,
                                pw.MemoryImage(signatureBytes!),
                              ): pw.Text(""),
                            ]),
                      ),
                    ]
                  )
                ),
              ];
            },
          )
        );
      }
    return doc.save();
  }
}
