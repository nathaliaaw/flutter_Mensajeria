import 'dart:io';
import 'package:intl/intl.dart';
import 'package:notificaciones_push/src/models/mensaje_usuario_model.dart';
import 'package:notificaciones_push/src/models/mesajes_model.dart';
import 'package:notificaciones_push/src/models/usuario_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbService {
  static Database? _dbConnect;

  static final DbService dbPublic = DbService();
  DbService();

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
          url_avatar TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE message(
        id INTEGER PRIMARY KEY,
        bodyMessage TEXT,
        creationDate TEXT
        )
      ''');
        await db.execute('''
      CREATE TABLE message_user(
          idMessage_user INTEGER PRIMARY KEY,
          tokenUserSender TEXT,
          idUser int,
          idMessage int
        )
      ''');
      },
    );
  }

  Future<int> insertUser(UsersModel user) async {
    final bd = await instanceBD;
    final int response = await bd!.rawInsert(
        "INSERT INTO user(token, key, usuario, url_avatar) VALUES('${user.token}', '${user.key}', '${user.usuario}', '${user.url_avatar}')");
    return response;
  }

  Future<int> insertMessage(MessageNotifyModel message) async {
    final bd = await instanceBD;
    final int response = await bd!.rawInsert(
        "INSERT INTO message(bodyMessage, creationDate) VALUES('${message.bodyMessage}', '${message.creationDate}')");
    return response;
  }

  Future<int> insertMessageUser(MessageUserModel msgUser) async {
    final bd = await instanceBD;
    final int response = await bd!.rawInsert(
        "INSERT INTO message_user(tokenUserSender, idUser, idMessage) VALUES('${msgUser.tokenUserSender}', '${msgUser.idUser}', '${msgUser.idMessage}')");
    return response;
  }

  Future<List<UsersModel>> getUsers() async {
    final bd = await instanceBD;
    final List<Map<String, dynamic>> maps = await bd!.query('user');

    return List.generate(
      maps.length,
      (i) {
        return UsersModel(
          id: maps[i]['id'],
          token: maps[i]['token'],
          key: maps[i]['key'],
          usuario: maps[i]['usuario'],
          url_avatar: maps[i]['url_avatar'],
        );
      },
    );
  }

  Future<List<MessageNotifyModel>> getMessage() async {
    final bd = await instanceBD;
    final List<Map<String, dynamic>> maps = await bd!.query('message');

    return List.generate(
      maps.length,
      (i) {
        return MessageNotifyModel(
          id: maps[i]['id'],
          bodyMessage: maps[i]['bodyMessage'],
        );
      },
    );
  }

  Future<List<MessageUserModel>> getMessageByIdUser(
      String tokenUserSender) async {
    final bd = await instanceBD;
    // await bd!.rawQuery('user')
    final List<Map<String, dynamic>> message = await bd!.rawQuery(
        'SELECT m.id, m.bodyMessage,mu.idUser, mu.tokenUserSender,mu.idMessage, m.creationDate FROM message m LEFT JOIN message_user mu on m.id = mu.idMessage where mu.tokenUserSender=?',
        [tokenUserSender]);

    if (message.isNotEmpty) {
      return List.generate(
        message.length,
        (i) {
          return MessageUserModel(
            id: message[i]['id'] as int,
            tokenUserSender: message[i]['tokenUserSender'] as String,
            bodyMessage: message[i]['bodyMessage'] as String,
            creationDate: formatDate(message[i]['creationDate'].toString()) ,
            idMessage: message[i]['idMessage'] as int,
            idUser: message[i]['idUser'] as int,
          );
        },
      );
    } else {
      return [];
    }
  }

  String formatDate(String datestr) {
    var date = DateTime.parse(datestr);

    String formatteDate=DateFormat('MMM d,h:mm a').format(date);
    return formatteDate;
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