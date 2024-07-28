import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:job_master/pages/fonstions.dart';
import 'package:job_master/pages/form_tamplate.dart';
import 'package:rating_dialog/rating_dialog.dart' show RatingDialog;
import 'package:share_plus/share_plus.dart' show Share;
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;
import 'package:url_launcher/url_launcher_string.dart'
    show launchUrlString, canLaunchUrlString;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> imagePath = [
    "lib/Assets/Images/images11.png",
    "lib/Assets/Images/image6.png",
    "lib/Assets/Images/images10.png",
    //"lib/Assets/Images/images13.jfif",
    //"lib/Assets/Images/image9.jfif",
    "lib/Assets/Images/imaged.png"
  ];
  List<String> title = [
    "Créer un CV",
    "Lettre de motivation",
    "Lettre de démission",
    // "Questions d'entretien",
    // "Lettres professionnelles",
    "Mes documents"
  ];
  List<String> subtitle = [
    "Design Professionnel",
    "Convaincre votre Recruteur",
    "Donner vos Raisons",
    //"Impressionner votre Recruteur",
    //"Sortir de l'Ordinaire",
    "CVs et lettres"
  ];
  late AppLifecycleReactor _appLifecycleReactor;

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
    );
  }

  GridView _gridViewBuilder(double width, double height) {
    final innerPadding = EdgeInsets.only(top: pourcent(width, 2));
    return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: MediaQuery.of(context).size.height / 18,
            crossAxisSpacing: MediaQuery.of(context).size.width / 18,
            mainAxisExtent: pourcent(height, 27),
            crossAxisCount: 2),
        padding: EdgeInsets.all(pourcent(width, 4)),
        children: [
          GestureDetector(
              onTap: () {
                loadInterAd();
                _interstitialAd?.show();
                dowloadFunction(context, 0);
              },
              child: Card(
                elevation: 10,
                color: Colors.white54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: pourcent(height, 3)),
                    CircleAvatar(
                      radius: pourcent(width, 38) / 3.6,
                      backgroundColor: Colors.greenAccent,
                      child: Image(image: AssetImage(imagePath[0])),
                    ),
                    SizedBox(height: innerPadding.vertical),
                    Padding(
                      padding: EdgeInsets.all(pourcent(width, 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title[0],
                            style: TextStyle(fontSize: pourcent(width, 4)),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            subtitle[0],
                            style: TextStyle(fontSize: pourcent(width, 2)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: pourcent(height, 2))),
                  ],
                ),
              )),
          GestureDetector(
              onTap: () {
                loadInterAd();
                _interstitialAd?.show();
                dowloadFunction(context, 1);
              },
              child: Card(
                elevation: 10,
                color: Colors.white54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: pourcent(height, 3)),
                    CircleAvatar(
                      radius: pourcent(width, 38) / 3.6,
                      backgroundColor: Colors.greenAccent,
                      child: Image(image: AssetImage(imagePath[1])),
                    ),
                    SizedBox(height: innerPadding.vertical),
                    Padding(
                      padding: EdgeInsets.all(pourcent(width, 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title[1],
                            style: TextStyle(fontSize: pourcent(width, 4)),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            subtitle[1],
                            style: TextStyle(fontSize: pourcent(width, 2)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: pourcent(height, 2))),
                  ],
                ),
              )),
          if (_nativeAd1 != null && _nativeAdIsLoaded1)
            ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width / 2.5,
                    minHeight: MediaQuery.of(context).size.height / 5,
                    maxWidth: MediaQuery.of(context).size.width / 2,
                    maxHeight: MediaQuery.of(context).size.height / 3.5),
                child: AdWidget(ad: _nativeAd1!)),
          if (_nativeAd2 != null && _nativeAdIsLoaded2)
            ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width / 2.5,
                    minHeight: MediaQuery.of(context).size.height / 5,
                    maxWidth: MediaQuery.of(context).size.width / 2,
                    maxHeight: MediaQuery.of(context).size.height / 3.5),
                child: AdWidget(ad: _nativeAd2!)),
          GestureDetector(
              onTap: () {
                loadInterAd();
                _interstitialAd?.show();
                dowloadFunction(context, 2);
              },
              child: Card(
                elevation: 10,
                color: Colors.white54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: pourcent(height, 3)),
                    CircleAvatar(
                      radius: pourcent(width, 38) / 3.6,
                      backgroundColor: Colors.greenAccent,
                      child: Image(image: AssetImage(imagePath[2])),
                    ),
                    SizedBox(height: innerPadding.vertical),
                    Padding(
                      padding: EdgeInsets.all(pourcent(width, 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title[2],
                            style: TextStyle(fontSize: pourcent(width, 4)),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            subtitle[2],
                            style: TextStyle(fontSize: pourcent(width, 2)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: pourcent(height, 2))),
                  ],
                ),
              )),
          GestureDetector(
              onTap: () {
                loadInterAd();
                _interstitialAd?.show();
                dowloadFunction(context, 0);
              },
              child: Card(
                elevation: 10,
                color: Colors.white54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: pourcent(height, 3)),
                    CircleAvatar(
                      radius: pourcent(width, 38) / 3.6,
                      backgroundColor: Colors.greenAccent,
                      child: Image(image: AssetImage(imagePath[3])),
                    ),
                    SizedBox(height: innerPadding.vertical),
                    Padding(
                      padding: EdgeInsets.all(pourcent(width, 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title[3],
                            style: TextStyle(fontSize: pourcent(width, 4)),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            subtitle[3],
                            style: TextStyle(fontSize: pourcent(width, 2)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: pourcent(height, 2))),
                  ],
                ),
              )),
        ]);
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

  void showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => RatingDialog(
        force: true,
        starSize: MediaQuery.of(context).size.width / 17,
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

  int _currentIndex = 0;

  InterstitialAd? _interstitialAd;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitInterId = 'ca-app-pub-7533781313698535/3799146141';

  /// Loads an interstitial ad.
  ///
  /*
  I his ad may have not been loaded or has been disposed. Ad with the following id could not be found 5.
   */
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

  NativeAd? _nativeAd1;
  NativeAd? _nativeAd2;
  bool _nativeAdIsLoaded1 = false;
  bool _nativeAdIsLoaded2 = false;

  late String _adUnitId1 = 'ca-app-pub-7533781313698535/3241910239';
  late String _adUnitId2 = 'ca-app-pub-7533781313698535/5484930190';
  AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();

  @override
  void initState() {
    _adUnitId1 = 'ca-app-pub-7533781313698535/3241910239';
    _adUnitId2 = 'ca-app-pub-7533781313698535/5484930190';
    appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
    loadAd1();
    loadAd2();
    _loadVersionString();
    loadInterAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (MediaQuery.orientationOf(context) == Orientation.landscape) {
      setState(() {
        double changedValue = MediaQuery.of(context).size.width;
        width = height;
        height = changedValue;
      });
    }

    return Scaffold(
      drawer: Drawer(
          backgroundColor: Colors.blue.shade50,
          elevation: 10,
          child: drawerBuilder(width, height)),
      appBar: [
        _appBarBuilder(width, height, 'JobMaster'),
        null
        //_appBarBuilder(width, height, 'Formats'),
        //_appBarBuilder(width, height, 'Formations')
      ][_currentIndex],
      body: [
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 18),
            child: _gridViewBuilder(width, height)),
        const Templates(),
        //const Cours(),
      ][_currentIndex],
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: pourcent(width, 20),
      bottomNavigationBar:
          BottomNavigationBar(currentIndex: _currentIndex, items: [
        BottomNavigationBarItem(
            label: 'Accueil',
            icon: IconButton(
                style: IconButton.styleFrom(elevation: 10),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                icon: const Icon(Icons.home))),
        BottomNavigationBarItem(
            label: 'Modèles',
            icon: IconButton(
                style: IconButton.styleFrom(elevation: 10),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                icon: const Icon(Icons.format_indent_decrease))),
        /* BottomNavigationBarItem(
            label: 'Cours',
            icon: IconButton(
                style: IconButton.styleFrom(elevation: 10),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                icon: const Icon(Icons.flight_class_sharp))),*/
      ]),
    );
  }

  void loadAd1() {
    _nativeAd1 = NativeAd(
        adUnitId: _adUnitId1,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded1 = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.white54,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

  void loadAd2() {
    _nativeAd2 = NativeAd(
        adUnitId: _adUnitId2,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded2 = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.white54,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

  void _loadVersionString() {
    MobileAds.instance.getVersionString().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nativeAd1?.dispose();
    _nativeAd2?.dispose();
    super.dispose();
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Politique de confidentialité',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 25),
        child: ListView(
          children: [
            Text(
              'Politique de Confidentialité',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Dernière mise à jour: Janvier 2024',
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            const SizedBox(height: 20.0),
            Text(
              '1. Informations Collectées',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 22,
                  fontWeight: FontWeight.bold),
            ),
            const Text('\n'),
            const Text("1.1 INFORMATIONS FOURNIES PAR L'UTILISATEUR: Lors de "
                "l'utilisation de l'application, vous pouvez choisir de "
                "fournir des informations personnelles telles que votre "
                "nom,"
                " vos coordonnées, votre expérience professionnelle, "
                "vos compétences,"
                " et d'autres informations liées à la création de votre CV."
                " Ces informations sont stockées localement sur votre appareil."),
            const Text('\n'),
            const Text("1.2 DONNEES DE L'APPAREIL: Nous pouvons collecter des "
                "informations sur votre appareil, y compris le modèle, la "
                "version du système d'exploitation, l'identifiant unique de"
                " l'appareil, et d'autres données similaires à des fins "
                "d'amélioration de l'application."),
            const Text('\n\n'),
            Text(
              '2 Utilisation des informations:',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 22,
                  fontWeight: FontWeight.bold),
            ),
            const Text('\n'),
            const Text("2.1 FOURNITURE DE SERVICE: Les informations que vous "
                "fournissez sont utilisées pour créer et stocker localement "
                "vos documents à l'intérieur de l'application, vous permettant ainsi"
                " de visualiser, modifier et exporter vos documents (CV et lettres)."),
            const Text('\n'),
            const Text(
                "2.2 AMELIORATION DE L'APPLICATION: Les données de l'appareil"
                " sont utilisées de manière agrégée et anonyme pour améliorer"
                " les fonctionnalités de l'application, la performance et "
                "l'expérience utilisateur."),
            const Text('\n\n'),
            Text(
              "3. Stockage des Données",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 22),
            ),
            const Text('\n'),
            const Text("Toutes les informations que vous fournissez lors de"
                " l'utilisation de l'application sont stockées localement sur "
                "votre appareil. Nous ne stockons pas ces informations sur des "
                "serveurs externes."),
            const Text('\n\n'),
            Text("4. Partage des Informations:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 22)),
            const Text('\n'),
            const Text(
                "Nous ne partageons pas vos informations personnelles avec des "
                "tiers. Vos données de CV sont stockées de manière sécurisée sur"
                " votre appareil et ne sont pas accessibles par des tiers sans"
                " votre consentement explicite."),
            const Text('\n\n'),
            Text('5. Sécurité des Données:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 22)),
            const Text('\n'),
            const Text("Nous prenons des mesures raisonnables pour protéger les"
                " informations que vous fournissez et stockez dans "
                "l'application. Cependant, veuillez noter qu'aucune méthode de"
                " transmission ou de stockage électronique n'est totalement "
                "sécurisée, et nous ne pouvons garantir la sécurité absolue "
                "de vos informations."),
            const Text('\n\n'),
            Text('6. Modifications de la Politique de Confidentialité:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 22)),
            const Text('\n'),
            const Text(
                "Nous nous réservons le droit de modifier cette Politique de "
                "Confidentialité à tout moment. Toute modification sera publiée "
                "dans l'application, et nous vous encourageons à consulter "
                "régulièrement cette page pour rester informé des mises à jour."),

            // Ajoutez d'autres sections de la politique de confidentialité au besoin
          ],
        ),
      ),
    );
  }
}

class AppOpenAdManager {
  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  String adUnitId = 'ca-app-pub-7533781313698535/1132953345';

  /// Load an [AppOpenAd].
  void loadAd() {
    AppOpenAd.load(
      adUnitId: adUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  /// Shows the ad, if one exists and is not already being shown.
  ///
  /// If the previously cached ad has expired, this just loads and caches a
  /// new ad.
  void showAdIfAvailable() {
    if (!isAdAvailable) {
      debugPrint('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      debugPrint('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      debugPrint('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        debugPrint('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}

class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    debugPrint('New AppState state: $appState');
    if (appState == AppState.foreground) {
      appOpenAdManager.showAdIfAvailable();
    }
  }
}
