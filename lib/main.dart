import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:job_master/pages/home_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

int i = 0;

class _MyAppState extends State<MyApp> {
  Future<void> loading() async {
    /*while (!(await InternetConnection().hasInternetAccess)) {
      isConnected = await InternetConnection().hasInternetAccess;

      setState(() {
        isConnected = isConnected;
      });
    }*/
    isConnected = await InternetConnection().hasInternetAccess;
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();
    await Future.delayed(const Duration(seconds: 3));
  }

  bool? isConnected;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "JobMaster",
      theme: ThemeData(
          textTheme: const TextTheme(
              bodyLarge: TextStyle(fontFamily: "Times"),
              bodyMedium: TextStyle(fontFamily: "Times"),
              bodySmall: TextStyle(fontFamily: "Times"),
              displayLarge: TextStyle(fontFamily: "Times"),
              displayMedium: TextStyle(fontFamily: "Times"),
              displaySmall: TextStyle(fontFamily: "Times"),
              headlineLarge: TextStyle(fontFamily: "Times"),
              headlineMedium: TextStyle(fontFamily: "Times"),
              headlineSmall: TextStyle(fontFamily: "Times"),
              labelLarge: TextStyle(fontFamily: "Times"),
              labelMedium: TextStyle(fontFamily: "Times"),
              labelSmall: TextStyle(fontFamily: "Times"),
              titleLarge: TextStyle(fontFamily: "Times"),
              titleMedium: TextStyle(fontFamily: "Times"),
              titleSmall: TextStyle(fontFamily: "Times")),
          buttonTheme: const ButtonThemeData(
              padding: EdgeInsets.all(10), buttonColor: Colors.blue),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          dialogTheme: const DialogTheme(
              backgroundColor: Colors.white,
              iconColor: Colors.lightBlueAccent,
              titleTextStyle: TextStyle(fontSize: 25, color: Colors.black)),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Colors.blueGrey,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue))),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: loading(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Image(
                    image:
                        const AssetImage("lib/Assets/Images/ic_launcher.png"),
                    width: MediaQuery.of(context).size.width / 5,
                  )),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width / 16)),
                  Center(
                      child: Image(
                    image:
                        const AssetImage("lib/Assets/Images/loadingImage.gif"),
                    width: MediaQuery.of(context).size.width / 4,
                  )),
                ],
              ),
            );
          } else {
            if (isConnected!) {
              return const HomePage();
            } else {
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 20,
                          right: MediaQuery.of(context).size.width / 20),
                      child: Text(
                        "Aucune connexion internet.\n Veuillez-vous connecter à internet \n",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, elevation: 10),
                        onPressed: () {
                         setState(() {
                           runApp(const MyApp());
                         });
                        },
                        child: Text(
                          "Reessayez",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 20),
                        ))
                  ],
                ),
              );
            }
          }
        },
      ),
      //const HomePage(),
    );
  }
}
