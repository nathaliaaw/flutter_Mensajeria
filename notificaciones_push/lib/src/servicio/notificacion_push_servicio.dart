import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  final String urlServ = 'https://fcm.googleapis.com/fcm/send';

  Future<Map<String, dynamic>> sendNotification({
    String? key,
    String? userTokenSender,
    String? token,
    String? message,
  }) async {
    final headers = {
      'Authorization': 'key=$key',
      'Content-Type': 'application/json'
    };
    final request = http.Request('POST', Uri.parse(urlServ));
    request.body = json.encode({
      "notification": {
        "body": "Texto del push",
        "title": "Titulo pruebas",
      },
      "priority": "high",
      "data": {
        "clave": message,
        "tokenUserSender":userTokenSender        ,
      },
      "to": token
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map<String, dynamic> dataResponse =
          json.decode(await response.stream.bytesToString());
      return dataResponse;
    } else {
      return throw Exception("Falló al enviar la notificación");
    }
  }
}
