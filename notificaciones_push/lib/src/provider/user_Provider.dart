import 'package:flutter/material.dart';
import 'package:notificaciones_push/src/models/usuario_models.dart';

class UserProvider extends ChangeNotifier {
  late Map<String, dynamic> _user = <String, dynamic>{};
  late String _token;
  Map<String, dynamic> get getUser => _user;
  String get getTokenUser => _token;

  void addUser(UsersModel user) {
    _user = <String, dynamic>{
      "token": user.token,
      "key": user.key,
      "usuario": user.usuario,
      "url_avatar": user.url_avatar,
    };
    notifyListeners();
  }

  void addTokenUser(String tokenUser) {
    _token = tokenUser;
    notifyListeners();
  }
}
