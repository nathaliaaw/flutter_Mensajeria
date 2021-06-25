import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notificaciones_push/src/models/mensaje_usuario_model.dart';
import 'package:notificaciones_push/src/models/mesajes_model.dart';
import 'package:notificaciones_push/src/preferencia/general_preferencias.dart';
import 'package:notificaciones_push/src/servicio/db_service.dart';
// import 'globals.dart' as globals;

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;
  static final service = DbService();
  static final prefs = GeneralPreferences();

  static Future _backgroundHandler(RemoteMessage message) async {
    insertMessage(message);
    _messageStream.add(message.data.toString());
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    insertMessage(message);
    _messageStream.add(message.data.toString());
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    insertMessage(message);
    _messageStream.add(message.data.toString());
  }

  static void insertMessage(RemoteMessage message) async {
    try {
      DbService.dbPublic.instanceBD;
      final msgJson = message.data;

      MessageNotifyModel msgObj = MessageNotifyModel(
        bodyMessage: msgJson['clave'],
        creationDate: DateTime.now().toString(),
      );
      final messageId = await service.insertMessage(msgObj);
      MessageUserModel msgUser = MessageUserModel(
        tokenUserSender: msgJson['tokenUserSender'],
        idMessage: messageId,
      );
      await service.insertMessageUser(msgUser);
    } catch (e) {
      print(e);
    }
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();
    // ignore: avoid_print
    print('Token de la aplicacion : $token');
    
    prefs.setToken(token!);
    
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    // ignore: avoid_print
    print('User push notification status ${settings.authorizationStatus}');
  }

  static closeStreams() {
    _messageStream.close();
  }
}
