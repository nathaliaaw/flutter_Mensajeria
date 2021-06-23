import 'dart:io';

import 'package:notificaciones_push/src/models/mensaje_usuario_model.dart';
import 'package:notificaciones_push/src/models/mesajes_model.dart';
import 'package:notificaciones_push/src/models/usuario_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static Database? _dbConnect;

  static final DBService dbPublic = DBService();
  DBService();

  Future<Database?> get instanceBD async {
    if (_dbConnect == null) {
      return openBD();
    } else {
      return _dbConnect;
    }
  }

  Future<Database?> openBD() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'dbProyect.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY,
        token TEXT,
        key TEXT,
        usuario TEXT,
        urlAvatar TEXT
      );
      CREATE TABLE message(
        id INTEGER PRIMARY KEY,
        bodyMessage TEXT,
        creationDate DATETIME
      );
      CREATE TABLE message_user(
        idMessage_user INTEGER PRIMARY KEY,
        idUser int ,
        idMessage int 
      );     
      ''');
      },
    );
  }

  Future<int> insertUser(UsuarioModel user) async {
    final bd = await instanceBD;
    final int response = await bd!.rawInsert(
        "INSERT INTO user(token,key, usuario, urlAvatar) VALUES('${user.token}','${user.key}', '${user.usuario}', '${user.urlAvatar}')");
    return response;
  }

  Future<int> insertMessage(MensajeModel mensaje) async {
    final bd = await instanceBD;
    final int response = await bd!.rawInsert(
        "INSERT INTO message(bodyMessage,creationDate) VALUES('${mensaje.body}','${mensaje.fecha}'");
    return response;
  }

  Future<int> insertMessageUser(MessageUserModel mensaje) async {
    final bd = await instanceBD;
    final int response = await bd!.rawInsert(
        "INSERT INTO message_user(idUser,idMessage) VALUES('${mensaje.idUser}','${mensaje.idMessage}'");
    return response;
  }

  Future<List<UsuarioModel>> getUsers() async {
    final bd = await instanceBD;
    final List<Map<String, dynamic>> maps = await bd!.query('user');

    return List.generate(
      maps.length,
      (i) {
        return UsuarioModel(
          id: maps[i]['id'],
          token: maps[i]['token'],
          key: maps[i]['key'],
          usuario: maps[i]['usuario'],
          urlAvatar: maps[i]['urlAvatar'],
        );
      },
    );
  }

  void deleteUserById(int id) async {
    final bd = await instanceBD;
    await bd!.delete(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void deleteUserAll() async {
    final bd = await instanceBD;
    await bd!.delete('user');
  }
}
