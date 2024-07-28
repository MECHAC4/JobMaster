import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:job_master/pages/cv_marker.dart';
import 'package:job_master/pages/mo_letter_creater.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import 'fonstions.dart';
import 'home_page.dart';

class Dowload extends StatefulWidget {
  final int initialIndex;

  const Dowload({required this.initialIndex, super.key});

  @override
  State<Dowload> createState() => _DowloadState();
}

class _DowloadState extends State<Dowload> with TickerProviderStateMixin {
  final GlobalKey<_DowloadState> myPageKey = GlobalKey<_DowloadState>();
  late Database _database;
  late Database _lateIndexDataBase;
  List<int> indexList = [];
  late int initialIndex;
  List<int> mlIndexList = [];

  Future<void> _initDatabase() async {
    _database = await openDatabase(
        path.join(await getDatabasesPath(), 'index_database.db'),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE index_list(id INTEGER PRIMARY KEY AUTOINCREMENT, index_cv INTEGER)',
      );
    }, version: 1);
    _lateIndexDataBase =
        await openDatabase(path.join(await getDatabasesPath(), 'lateindex.db'),
            onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE late_index(id INTEGER PRIMARY KEY AUTOINCREMENT, lateind INTEGER)');
    }, version: 1);
    await _loadIndex();
  }

  List<Map<String, dynamic>> indexs = [];
  List<Map<String, dynamic>> lateIndexMap = [];
  int lateIndex = 0;

  Future<void> _loadIndex() async {
    indexs = await _database.query('index_list');
    lateIndexMap = await _lateIndexDataBase.query('late_index');

    if (indexs.isNotEmpty) {
      setState(() {
        for (int i = 0; i < indexs.length; i++) {
          indexList.add(indexs[i]['index_cv']);
        }
      });
    }
    if (lateIndexMap.isNotEmpty) {
      lateIndex = lateIndexMap[lateIndexMap.length - 1]['lateind'];
    } else {
      lateIndex = 0;
    }
    await infoPersoLoading();
  }

  Future<void> infoPersoLoading() async {
    if (indexList.isNotEmpty) {
      for (int i = 0; i < indexList.length; i++) {
        final info =
            await DataManager(index: indexList[i]).initInfoPersoDatabase();
        setState(() {
          info.isNotEmpty
              ? infoPerso.add(info.last)
              : infoPerso.add({"nom": ' ', "prenom": ' '});
        });
      }
    }
  }

  Future<void> ajouterIndex() async {
    int ind;
    ind = lateIndex + 1;
    setState(() {
      indexList.add(ind);
    });
    await _database.insert('index_list', {'index_cv': ind},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await _lateIndexDataBase.insert("late_index", {'lateind': ind});
  }

  void supprimerIndex(int indexi) async {
    await _database
        .delete('index_list', where: 'index_cv = ?', whereArgs: [indexi]);
  }

  Widget mlListBuilder() {
    if (mlIndexList.isNotEmpty) {
      return ListView.builder(
        itemCount: mlIndexList.length,
        itemBuilder: (context, index) {
          String nom = " ";
          String adresse = " ";
          if (receiverInfo.isNotEmpty) {
            if (receiverInfo.length > index) {
              nom = receiverInfo[index]["nomEntreprise"];
              adresse = receiverInfo[index]["adresseEntreprise"];
            }
          }

          return Container(
            height: MediaQuery.of(context).size.width / 2.5,
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 80,
                right: MediaQuery.of(context).size.width / 80),
            child: Card(
              color: Colors.white54,
              elevation: 10,
              child: ListTile(
                title: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.height / 8,
                        height: MediaQuery.of(context).size.height / 6,
                        child: Icon(
                          Icons.email,
                          color: Colors.blue,
                          size: MediaQuery.of(context).size.height / 8,
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Destinée à ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          "Entreprise : $nom",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Adresse : $adresse",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, elevation: 12),
                            onPressed: () {
                              loadInterAd();
                              _interstitialAd?.show();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoLetterMaker(index: mlIndexList[index]),));
                              debugPrint("Lettre vue");
                            },
                            child: const Text(
                              "Voir la lettre",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  ],
                ),
                //leading: const Icon(Icons.email_sharp, color: Colors.blue, size: 100,),
                trailing: PopupMenuButton(
                  color: Colors.white,
                  padding: const EdgeInsets.all(0),
                  icon: Icon(Icons.more_vert,
                      size: MediaQuery.of(context).size.height / 15),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.blue,
                                      content: Text(
                                        'Voulez-vous vraiment supprimer cette lettre ?',
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
                                                int x = mlIndexList[index];
                                                setState(() {
                                                  MoIndexManager()
                                                      .supprimerIndex(
                                                          mlIndexList
                                                              .removeAt(index));
                                                  //initMotLetterDatabase();
                                                  if (receiverInfo.length >
                                                      index) {
                                                    receiverInfo
                                                        .removeAt(index);
                                                  }
                                                  //int x = mlIndexList.removeAt(index);
                                                });
                                                MoLetterDataManager(index: x).deleteAllDatabase();

                                                Navigator.of(context).pop();
                                              });
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
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.delete,
                            )),
                      ),
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    MoLetterCreator(index: mlIndexList[index]),
                              ));
                              debugPrint(
                                  "***********Lettre ${mlIndexList[index]} cliqué*********");
                            },
                            icon: const Icon(
                              Icons.edit,
                            )),
                      )
                    ];
                  },
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Text(
        "Aucune lettre de motivation",
        style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20),
      );
    }
  }

  Future<void> ajouterMoLetter() async {
    setState(() {
      mlIndexList.add(lateMlIndex + 1);
    });
    await MoIndexManager().ajouterIndex();
    setState(() {});
  }

  Widget cvListBuilder() {
    if (indexList.isNotEmpty) {
      return ListView.builder(
        itemCount: indexList.length,
        itemBuilder: (context, index) {
          String nom = ' ';
          String prenom = ' ';
          String titre = ' ';
          List<int> imageBytes = [];
          Uint8List imageFile = Uint8List.fromList(imageBytes);
          if (infoPerso.isNotEmpty) {
            if (infoPerso.length > index) {
              nom = infoPerso[index]["nom"] ?? ' ';
              prenom = infoPerso[index]["prenom"] ?? ' ';
              titre = infoPerso[index]["titre"] ?? ' ';
              if (infoPerso[index]["image"] != null &&
                  infoPerso[index]["image"] != [] &&
                  infoPerso[index]["image"].toString().isNotEmpty) {
                imageBytes = infoPerso[index]["image"];
                imageBytes.isNotEmpty
                    ? imageFile = Uint8List.fromList(imageBytes)
                    : null;
              }
            }
          }
          return Container(
            height: MediaQuery.of(context).size.width / 2.5,
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 80,
                right: MediaQuery.of(context).size.width / 80),
            child: Card(
              color: Colors.white54,
              elevation: 10,
              child: ListTile(
                title: Row(
                  children: [
                    (imageFile.isNotEmpty)
                        ? Image.memory(
                            alignment: Alignment.centerLeft,
                            imageFile,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.height / 8,
                          )
                        : Image(
                            alignment: Alignment.centerLeft,
                            image:
                                const AssetImage("lib/Assets/Images/imp.png"),
                            width: MediaQuery.of(context).size.height / 8,
                          ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Nom:  ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(nom),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Prénom:  ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(prenom),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Titre:  ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(titre),
                          ],
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, elevation: 12),
                            onPressed: () {
                              loadInterAd();
                              _interstitialAd?.show();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CvMarkerClass(index: indexList[index]),
                                  ));
                            },
                            child: const Text(
                              "Voir le CV",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  ],
                ),
                //leading:
                trailing: PopupMenuButton(
                  color: Colors.white,
                  padding: const EdgeInsets.all(0),
                  icon: Icon(Icons.more_vert,
                      size: MediaQuery.of(context).size.height / 15),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.blue,
                                      content: Text(
                                        'Voulez-vous vraiment supprimer ce CV ?',
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
                                                int x = indexList[index];
                                                supprimerIndex(
                                                    indexList.removeAt(index));
                                                infoPerso.removeAt(index);
                                                DataManager(index: x)
                                                    .deleteAllDatabase()
                                                    .then((value) =>
                                                        const CircularProgressIndicator());
                                                Navigator.of(context).pop();
                                              });
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
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.delete,
                            )),
                      ),
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CvMarker(index: indexList[index]),
                              ));
                            },
                            icon: const Icon(
                              Icons.edit,
                            )),
                      )
                    ];
                  },
                ),
              ),
            ),
          );
        },
      );
    } else {
      return const Text("Aucun CV");
    }
  }

  List<Map<String, dynamic>> infoPerso = [];

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

  late int lateMlIndex;

  Future<void> loadLateMlindex() async {
    lateMlIndex = await MoIndexManager().lateIndexF();
    debugPrint("********late index: $lateMlIndex*****************");
  }

  @override
  void initState() {
    setState(() {
      initialIndex = widget.initialIndex;
    });
    // TODO: implement initState
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: initialIndex);
    setState(() {
      _initDatabase();
      initMotLetterDatabase();
      loadLateMlindex();
    });
    loadInterAd();
  }

  List<Map<String, dynamic>> receiverInfo = [];

  void initMotLetterDatabase() async {
    mlIndexList = await MoIndexManager().initDatabase();
    debugPrint(
        "Voici la liste des index des lettres de motivation: $mlIndexList *************************");
    for (int i = 0; i < mlIndexList.length; i++) {
      final headerInfo =
          await MoLetterDataManager(index: mlIndexList[i]).initHeaderDatabase();
      final nomEntrepriseController = headerInfo["nomEntreprise"];
      final adressEntrepriseController = headerInfo["adresseEntreprise"];
      debugPrint(
          "donné récupéré de la base de donnée pour l'index ${mlIndexList[i]}: $headerInfo");
      setState(() {
        headerInfo.isNotEmpty
            ? receiverInfo.add({
                "nomEntreprise": nomEntrepriseController,
                "adresseEntreprise": adressEntrepriseController
              })
            : receiverInfo
                .add({"nomEntreprise": "  ", "adresseEntreprise": "  "});
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return MaterialApp(
        key: myPageKey,
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            } else {
              return DefaultTabController(
                  initialIndex: initialIndex,
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ));
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          )),
                      backgroundColor: Colors.blue,
                      title: const Text("Mes Documents",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      centerTitle: true,
                      bottom: TabBar(tabs: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            "Mes CVs",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 5 + width / 44, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            "Lettres de motivation",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 5 + width / 44, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            "Lettres de démission",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 5 + width / 44, color: Colors.white),
                          ),
                        ),
                      ], controller: _tabController),
                    ),
                    body: TabBarView(controller: _tabController, children: [
                      Padding(
                        padding: EdgeInsets.only(top: width / 30),
                        child: Center(child: cvListBuilder()),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: width / 30),
                        child: Center(child: mlListBuilder()),
                      ),
                      Center(
                          child: Text("Aucune lettre de démission",
                              style: TextStyle(fontSize: width / 20))),
                    ]),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        loadInterAd();
                        _interstitialAd?.show();
                        if (_tabController.index == 0) {
                          setState(() {
                            addFuntion();
                          });

                          cvMarkerFunction(
                              context, indexList[indexList.length - 1]);
                        } else if (_tabController.index == 1) {
                          setState(() {
                            receiverInfo.add({
                              "nomEntreprise": " ",
                              "adresseEntreprise": " "
                            });
                            ajouterMoLetter();
                          });
                          initMotLetterDatabase();
                          setState(() {
                            debugPrint(
                                "***********Lettre ${mlIndexList.last} créé*********");
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MoLetterCreator(index: lateMlIndex + 1),
                            ));
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                scrollable: true,
                                backgroundColor: Colors.blue,
                                content: Center(
                                  child: Text(
                                    "Cette session de l'application n'est pas encore disponible pour le moment. Veillez y revenir plus tard",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Ok',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                20,
                                          )))
                                ],
                              );
                            },
                          );
                        }
                      },
                      backgroundColor: Colors.blue,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ));
            }
          },
        ));
  }

  void addFuntion() async {
    if (_tabController.index == 0) {
      await ajouterIndex();
      await infoPersoLoading();
    }
  }
}

class Instruction extends StatefulWidget {
  const Instruction({super.key});

  @override
  State<Instruction> createState() => _InstructionState();
}

class _InstructionState extends State<Instruction> {
  int selectedPage = 0;
  PageController pageController = PageController(initialPage: 0);
  int pageCount = 4;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
          "Instructions pour vos CV avec JobMaster",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        actions: [
          if (selectedPage != 3)
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Annuler",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width / 20),
                )),
          if (selectedPage == 3)
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "D'accord",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width / 20),
                ))
        ],
        content: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                        allowImplicitScrolling: true,
                        controller: pageController,
                        onPageChanged: (page) {
                          setState(() {
                            selectedPage = page;
                            pageController =
                                PageController(initialPage: selectedPage);
                          });
                        },
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 12),
                            child: Center(
                              child: Text(
                                  "Visualisez le modèle de CV que vous "
                                  "désirez créer dans la partie \"Modèles\" et ayez "
                                  "en tête les informations nécessaires pour la "
                                  "création de ce modèle.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              20)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 12),
                            child: Center(
                              child: Text(
                                  "Remplissez seulement les informations "
                                  "nécessaires pour la création du modèle que "
                                  "vous désirez. Les autres informations ne seront pas"
                                  " utiliser.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              20)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 12),
                            child: Center(
                              child: Text(
                                  "Redimensionnez vos photos pour qu'elles"
                                  " soient adaptées aux modèles de CV que vous"
                                  " souhaitez créer. ",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              20)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 12),
                            child: Center(
                              child: Text(
                                  "Bien que cela ne soit pas une obligation,"
                                  " faites au maximum que votre CV reste sur une"
                                  " page; cela rendra plus fluide le design de votre CV.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              20)),
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: PageViewDotIndicator(
                      currentItem: selectedPage,
                      count: pageCount,
                      unselectedColor: Colors.black26,
                      selectedColor: Colors.blue,
                      duration: const Duration(milliseconds: 200),
                      boxShape: BoxShape.circle,
                      onItemClicked: (index) {
                        pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                        setState(() {
                          selectedPage = index;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class MoIndexManager {
  late Database _database;
  late Database _lateIndexDataBase;
  List<int> indexList = [];
  late int initialIndex;

  Future<int> lateIndexF() async {
    await initDatabase();
    return lateIndex;
  }

  Future<List<int>> initDatabase() async {
    _database = await openDatabase(
        path.join(await getDatabasesPath(), 'moindex_database.db'),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE index_list(id INTEGER PRIMARY KEY AUTOINCREMENT, index_ml INTEGER)',
      );
    }, version: 1);
    _lateIndexDataBase = await openDatabase(
        path.join(await getDatabasesPath(), 'molateindex.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE late_index(id INTEGER PRIMARY KEY AUTOINCREMENT, lateind INTEGER)');
    }, version: 1);
    debugPrint("$_lateIndexDataBase initialisé");
    return await loadIndex();
  }

  List<Map<String, dynamic>> indexs = [];
  List<Map<String, dynamic>> lateIndexMap = [];
  int lateIndex = 0;

  Future<List<int>> loadIndex() async {
    indexs = await _database.query('index_list');
    lateIndexMap = await _lateIndexDataBase.query('late_index');

    if (indexs.isNotEmpty) {
      for (int i = 0; i < indexs.length; i++) {
        indexList.add(indexs[i]['index_ml']);
      }
    }
    if (lateIndexMap.isNotEmpty) {
      lateIndex = lateIndexMap[lateIndexMap.length - 1]['lateind'];
    } else {
      lateIndex = 0;
    }
    return indexList;
  }

  Future<List<int>> ajouterIndex() async {
    await initDatabase();
    int ind;
    ind = lateIndex + 1;

    indexList.add(ind);
    debugPrint("Voilà la liste: $indexList");

    await _database.insert('index_list', {'index_ml': ind},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await _lateIndexDataBase.insert("late_index", {'lateind': ind});
    return indexList;
  }

  void supprimerIndex(int indexi) async {
    await initDatabase();
    await _database
        .delete('index_list', where: 'index_ml = ?', whereArgs: [indexi]);
  }
}
