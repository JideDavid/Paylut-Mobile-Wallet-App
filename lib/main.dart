import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paylut/View/auth_screen.dart';
import 'package:paylut/View/home_screen.dart';
import 'package:paylut/View/onboarding.dart';
import 'package:paylut/services/pref_helper.dart';
import 'package:paylut/services/settings_provider.dart';
import 'package:paylut/services/user_details_provider.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<UserDetailsProvider>(create: (_) => UserDetailsProvider()),
    ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider())
  ],
  child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool appFresh = true;

  //Checking if a user is already signed in
  Future<Widget> userSignedIn() async{
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

    UserDetails userDetails = UserDetails.fromJson(userData);

    return Home(userDetails: userDetails,);
  }

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  Future<void> getAppFresh() async{
    appFresh = (await PrefHelper().getAppIsFresh())!;
    if(mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getAppFresh();
    context.read<SettingsProvider>().getSaveTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Paylut",
      themeMode: context.watch<SettingsProvider>().themeMode,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white.withOpacity(0.97),
          primarySwatch: buildMaterialColor(const Color(0xffe91e63)),
          brightness: Brightness.light,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurple))),
          appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              actionsIconTheme: IconThemeData(color: Colors.black54),
              iconTheme: IconThemeData(color: Colors.deepPurple),
              titleTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.deepPurple,
          ),
          textTheme: const TextTheme(
            titleSmall: TextStyle( fontWeight: FontWeight.normal, fontSize: 14, color: Colors.black87),
          ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurple))),
        appBarTheme: const AppBarTheme(elevation: 0, titleTextStyle: TextStyle(fontSize: 15)),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: Colors.deepPurple),
        colorScheme:  ColorScheme.dark(
          background: Colors.black,
        ),
        textTheme: TextTheme()
      ),
      home: appFresh ? const OnBoarding()
      : FutureBuilder(
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if(snapshot.hasData){
            return snapshot.data!;
          }else{
            return const AuthScreen();
          }
        },
        initialData: Scaffold(
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                [
                  Text('fetching data', style: TextStyle(color: Colors.white38)),
                  SizedBox(height: 10,),
                  CircularProgressIndicator(
                    color: Colors.white30,
                  )
                ]
            ),
          ),
        ),
        future: userSignedIn(),
      ),
      routes: {
        "/main": (context) => const MyApp(),
        "/authScreen": (context) => const AuthScreen(),
      },
    );
  }
}
