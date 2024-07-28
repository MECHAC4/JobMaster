/*import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerScreen extends StatefulWidget {
  final String videoID;

  const PlayerScreen({required this.videoID, super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}
*/
/*class _PlayerScreenState extends State<PlayerScreen> {
  final bool _muted = false;
  late final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: widget.videoID,
    flags: YoutubePlayerFlags(
      controlsVisibleAtStart: true,
      autoPlay: true,
      mute: _muted,
      forceHD: isHD,
    ),
  )..addListener(_onControllerUpdate);

  void _onControllerUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _controller.setVolume(volume.toInt());
  }

  bool isHD = false;
  double volume = 100;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInterAd();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          progressIndicatorColor: Colors.blue,
          controlsTimeOut: const Duration(seconds: 5),
          showVideoProgressIndicator: true,
          controller: _controller,
          actionsPadding: const EdgeInsets.all(0),
          onEnded: (metaData) {
            _interstitialAd?.show();
          },
          onReady: () {
            _interstitialAd?.show();
          },
        ),
        builder: (context, player) {
          return Scaffold(
            appBar: !_controller.value.isFullScreen
                ? AppBar(
                    title: const Text("Lecteur Vidéo"),
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                  )
                : null,
            body: ListView(
              children: [
                player,
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          );
        });*/
  //}
//}