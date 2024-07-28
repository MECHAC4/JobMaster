//import 'package:flutter/material.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:job_master/pages/player.dart';

//import 'fonstions.dart';
/*
class Cours extends StatefulWidget {
  const Cours({super.key});

  @override
  State<Cours> createState() => _CoursState();
}

class _CoursState extends State<Cours> {
  @override
  Widget build(BuildContext context) {
    return const ListFormation();
  }
}

class ListFormation extends StatefulWidget {
  const ListFormation({super.key});

  @override
  State<ListFormation> createState() => _ListFormationState();
}

class _ListFormationState extends State<ListFormation> {

  List<Map<String, String>> formationDetails = [
    {
      'url': "lib/Assets/Images/titreFormation.jpg",
      'title': "Formation complète sur la rédaction de CV",
      "subtitle": "Impressionnez vos recruteurs avec votre CV",
      "duree": "3h30",
      "shortTitle": "Rédaction de CV",
      "type": "Formation vidéo"
    }
  ];
  BannerAd? _bannerAd;

  final adUnitBanniereId = 'ca-app-pub-3940256099942544/6300978111';

  void loadBanniereAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitBanniereId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {});
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBanniereAd();
  }

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.6,
      ),
      itemCount: formationDetails.length + 1,
      itemBuilder: (context, index) {
          Map<String, String> formationDetail = formationDetails[index == 0? 0: 0];
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        return index == 0
            ? Card(
                elevation: 10,
                color: Colors.white54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                            image: AssetImage(formationDetail['url']!),
                            height: pourcent(height, 20)),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              elevation: 10,
                              padding: EdgeInsets.all(pourcent(width, 2)),
                              fixedSize: Size(
                                  pourcent(width, 40), pourcent(height, 6))),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FormationPage(
                                  index: index,
                                  titleFormation:
                                      formationDetail['shortTitle']!),
                            ));
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Suivre la formation',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: pourcent(width, 3)),
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(height: innerPadding.vertical),
                    Padding(
                      padding: EdgeInsets.all(pourcent(width, 0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formationDetail['title']!,
                            style: TextStyle(
                                fontSize: pourcent(width, 4),
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Table(
                            children: [
                              TableRow(children: [
                                Text(
                                  "          Type de la formation: ${formationDetail["type"]!}",
                                  style: const TextStyle(),
                                  textAlign: TextAlign.left,
                                ),
                              ]),
                              TableRow(children: [
                                Text(
                                  "          Durée de la formation: ${formationDetail["duree"]!}",
                                  style: const TextStyle(),
                                  textAlign: TextAlign.left,
                                )
                              ])
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: pourcent(height, 0))),
                  ],
                ),
              )
            : ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 320, // minimum recommended width
                  minHeight: 90, // minimum recommended height
                  maxWidth: 400,
                  maxHeight: 200,
                ),
                child: AdWidget(ad: _bannerAd!),
              );
      },
    );
  }
}

class FormationPage extends StatefulWidget {
  final int index;
  final String titleFormation;

  const FormationPage({
    super.key,
    required this.index,
    required this.titleFormation,
  });

  @override
  State<FormationPage> createState() => _FormationPageState();
}

class _FormationPageState extends State<FormationPage> {
  int _currentStep = 0;
  final List<bool> _chapterCompleted = [true, true, true, true];
  final videoUrls = [
    {
      'url': "https://youtu.be/Gqbo88HCgqs?si=AZnyUNsnDabjUh5E",
      'title': "Ce qu'il faut savoir"
    },
    {
      'url': "https://youtu.be/Gqbo88HCgqs?si=AZnyUNsnDabjUh5E",
      'title': "Utiliser un vocabulaire approprié"
    },
    {
      'url': "https://www.youtube.com/watch?v=nJEUDrsefJ8",
      'title': "Erreurs à ne pas commettre"
    },
    {
      'url': "https://www.youtube.com/watch?v=RxGkG8HFFHs",
      'title': "Points clés"
    },
    {
      'url': "https://www.youtube.com/watch?v=ivRovRJWbVQ",
      'title': "Modernisation"
    }
  ];

  InterstitialAd? _interstitialAd;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitInterId = 'ca-app-pub-3940256099942544/1033173712';

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



  Widget videoBuilder(List<Map<String, String>> chapterVideoUrl) {
    return Column(
      children: chapterVideoUrl.map((e) {
        final videoUrl = e['url'];
        final videoID = YoutubePlayer.convertUrlToId(videoUrl!);
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                loadInterAd();
                _interstitialAd?.show();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlayerScreen(videoID: videoID),
                ));
              },
              child: Image.network(
                YoutubePlayer.getThumbnail(videoId: videoID!),
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                      height: 200,
                      width: 300,
                      color: Colors.black,
                      child: Center(
                          child: Text(
                        'Erreur de chargement $error',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      )));
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Container(
                      height: 200,
                      width: 300,
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Text(
              e['title']!,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 28))
          ],
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInterAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: Colors.blue,
        title: Text(
          widget.titleFormation,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < _chapterCompleted.length - 1 &&
              _chapterCompleted[_currentStep]) {
            setState(() {
              _currentStep++;
              _chapterCompleted[_currentStep] = true;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        steps: [
          Step(
            title: const Text('Chapitre 1'),
            content: videoBuilder(videoUrls),
            isActive: _chapterCompleted[0],
            state:
                _chapterCompleted[0] ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: const Text('Chapitre 2'),
            content: videoBuilder(videoUrls),
            isActive: _chapterCompleted[1],
            state:
                _chapterCompleted[1] ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: const Text('Chapitre 3'),
            content: videoBuilder(videoUrls),
            isActive: _chapterCompleted[2],
            state:
                _chapterCompleted[2] ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: const Text('Chapitre 4'),
            content: videoBuilder(videoUrls),
            isActive: _chapterCompleted[3],
            state:
                _chapterCompleted[3] ? StepState.complete : StepState.disabled,
          ),
        ],
      ),
    );
  }
}
*/