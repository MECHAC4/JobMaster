import 'package:flutter/material.dart';
import 'package:job_master/pages/cv_marker.dart' show DataManager, CvMarkerClass;
import 'package:job_master/pages/mo_letter_creater.dart' show MoLetterDataManager, MoLetterMaker;
import 'package:share_plus/share_plus.dart' show Share;
import 'package:url_launcher/url_launcher.dart';

import 'fonstions.dart';
import 'home_page.dart' show PrivacyPolicyPage;

class FormTamplateClass extends StatefulWidget {
  final int index;
  final int utilite;

  const FormTamplateClass(
      {super.key, required this.index, required this.utilite});

  @override
  State<FormTamplateClass> createState() => _FormTamplateClassState();
}

class _FormTamplateClassState extends State<FormTamplateClass> {
  late int indexi;
  Color decColor = Colors.blue;
  late int utilite;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indexi = widget.index;
    utilite = widget.utilite;
    decColor = Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageURL = [
      "lib/Assets/Images/modele1.jpg",
      "lib/Assets/Images/modele2.jpg",
      "lib/Assets/Images/modele3.jpg",
      "lib/Assets/Images/modele4.webp",
      "lib/Assets/Images/modele5.webp",
      "lib/Assets/Images/modele6.jpg"
    ];
    Future<void> save(int index) async {
      await DataManager(index: indexi).saveFormTamplate(index);
    }

    return Scaffold(
      appBar: utilite == 0
          ? AppBar(
              title: Text('Choix du modèle de CV',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 15)),
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  )),
              backgroundColor: Colors.blue,
            )
          : null,
      body: GridView.builder(

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: pourcent(MediaQuery.of(context).size.height, 40),
            crossAxisCount: 2),
        itemCount: imageURL.length,
        itemBuilder: (context, index) {
          return IconButton(
              color: decColor,
              onPressed: () {
                if (utilite == 0 && index != 3) {
                  save(index);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CvMarkerClass(index: indexi),
                      ));
                } else if (utilite == 0 && index == 3) {
                  save(index);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CvMarkerClass(index: indexi),
                      ));
                } else if (utilite == 1) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewTemplate(url: imageURL[index]),
                  ));
                }
              },
              icon: Image(image: AssetImage(imageURL[index])));
        },
      ),
    );
  }
}

class ViewTemplate extends StatelessWidget {
  final String url;

  const ViewTemplate({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Image(
            image: AssetImage(url),
            height: MediaQuery.of(context).size.height - 20),
      ),
    );
  }
}


class FormLetter extends StatefulWidget {
  final int index;
  final int utilite;

  const FormLetter(
      {super.key, required this.index, required this.utilite});


  @override
  State<FormLetter> createState() => _FormLetterState();
}

class _FormLetterState extends State<FormLetter> {
  late int indexi;
  Color decColor = Colors.blue;
  late int utilite;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indexi = widget.index;
    utilite = widget.utilite;
    decColor = Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageURL = [
      "lib/Assets/Images/LetterImage/modele1.jpg",
      "lib/Assets/Images/LetterImage/modele2.jpg",
      "lib/Assets/Images/LetterImage/modele3.png",
      "lib/Assets/Images/LetterImage/modele4.jpg",
    ];
    Future<void> save(int index) async {
      await MoLetterDataManager(index: indexi).saveFormTamplate(index);
    }

    return Scaffold(
      appBar: utilite == 0
          ? AppBar(
        title: Text('Choix du modèle de Lettre',
            style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width / 15)),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        backgroundColor: Colors.blue,
      )
          : null,
      body: GridView.builder(

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: pourcent(MediaQuery.of(context).size.height, 40),
            crossAxisCount: 2),
        itemCount: imageURL.length,
        itemBuilder: (context, index) {
          return IconButton(
              color: decColor,
              onPressed: () {
                if (utilite == 0) {
                  save(index);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoLetterMaker(index: indexi),
                      ));
                }  else  {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewTemplate(url: imageURL[index]),
                  ));
                }
              },
              icon: Image(image: AssetImage(imageURL[index])));
        },
      ),
    );
  }
}

  class Templates extends StatefulWidget {
    const Templates({super.key});

    @override
    State<Templates> createState() => _TemplatesState();
  }

  class _TemplatesState extends State<Templates> with TickerProviderStateMixin {


    AppBar _appBarBuilder(double width, double height, String title) {
      return AppBar(
        leading: const DrawerButton(
          style: ButtonStyle(
              iconColor: MaterialStatePropertyAll<Color>(Colors.white)),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 10,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.indigo,
                Colors.indigoAccent,
                Colors.blueAccent,
                Colors.blueGrey,
                Colors.greenAccent
              ])),
        ),
        title: Text(
          title,
          style:
          TextStyle(color: Colors.greenAccent, fontSize: pourcent(width, 8)),
        ),
        centerTitle: true,
        bottomOpacity: 1,
        bottom: TabBar(tabs: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              "CVs",
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
        ], controller: _tabController),
      );
    }



    ListView drawerBuilder(double width, double height) {
      return ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Text(
                  "JobMaster",
                  style: TextStyle(
                      fontSize: pourcent(width, 10),
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Créateur de CV et de lettres professionnelles",
                  style:
                  TextStyle(fontSize: pourcent(width, 3), color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Partager l\'application'),
            leading: const Icon(Icons.share),
            onTap: () {
              shareApp();
            },
          ),
          ListTile(
            title: const Text('Politique et règles de confidentialité'),
            leading: const Icon(Icons.security),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Évaluez-nous'),
            leading: const Icon(Icons.star),
            onTap: () {
              showRatingDialog(context);
            },
          ),
          ListTile(
            title: const Text('Nous contacter'),
            leading: const Icon(Icons.mail),
            onTap: () {
              openEmailApp();
            },
          ),
        ],
      );
    }


    void shareApp() {
      Share.share(
          'Téléchargez l\'application JobMaster depuis le lien, une application qui vous forme et vous aide pour la création des CV et lettres professionnelles : https://play.google.com/store/apps/details?id=com.jline.job_master',
          subject: 'Créer des CV professionnels avec JobMaster');
    }

    void openEmailApp() async {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'contact@votreentreprise.com', // Remplacez par votre adresse e-mail
        queryParameters: {'subject': 'Contact depuis l\'application'},
      );

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      }
    }









    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: 0);
  }

    @override
    void dispose() {
      _tabController.dispose();
      super.dispose();
    }

    late TabController _tabController;
    @override
    Widget build(BuildContext context) {
      return  DefaultTabController(length: 2,
            child: Scaffold(
              drawer: Drawer(
                  backgroundColor: Colors.blue.shade50,
                  elevation: 10,
                  child: drawerBuilder(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height)),
              appBar: _appBarBuilder(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height, "Formats"),
            body: TabBarView(
                controller: _tabController,
                children: const [
              FormTamplateClass(index: 0, utilite:1),
              FormLetter(index: 0, utilite: 1),
            ]),
            )
        );

    }
  }



