import 'package:flutter/material.dart';

import 'package:notificaciones_push/src/pages/home_page.dart';
import 'package:notificaciones_push/src/pages/mensaje_page.dart';
import 'package:notificaciones_push/src/pages/qr_page.dart';
import 'package:notificaciones_push/src/preferencia/general_preferencias.dart';
import 'package:notificaciones_push/src/provider/user_Provider.dart';
import 'package:notificaciones_push/src/servicio/notificacion_push_servicio.dart';
import 'package:notificaciones_push/src/servicio/pushNotification_Service.dart';
import 'package:provider/provider.dart';


void main() async {
    final preferences=GeneralPreferences();
  WidgetsFlutterBinding.ensureInitialized();
  await preferences.initPreferences();   
  await PushNotificationService.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    // Context!
    PushNotificationService.messagesStream.listen((message) {
      // print('MyApp: $message');
      navigatorKey.currentState?.pushNamed('message', arguments: message);

      final snackBar = SnackBar(content: Text(message));
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        navigatorKey: navigatorKey, // Navegar
        scaffoldMessengerKey: messengerKey, // Snacks
        theme: ThemeData.dark(),
        routes: {
          'home': (_) => HomePage(),
          'message': (_) => MessagePage(),
          'generate': (_) => GenerateScreen(),
        },
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Material App',
    //   initialRoute: 'home',
    //   navigatorKey: navigatorKey, // Navegar
    //   scaffoldMessengerKey: messengerKey, // Snacks
    //   routes: {
    //     'home': (_) => HomePage(),
    //     'message': (_) => MessagePage(),
    //     'generate': (_) => GenerateScreen(),
    //   },
    // );
 
  }
}
