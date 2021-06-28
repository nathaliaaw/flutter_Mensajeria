import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:notificaciones_push/src/models/usuario_models.dart';
import 'package:notificaciones_push/src/pages/qr_page.dart';
import 'package:notificaciones_push/src/provider/user_Provider.dart';
import 'package:notificaciones_push/src/servicio/db_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String textoLeido = '';
  DbService service = DbService();
  List<UsersModel> _usersList = <UsersModel>[];

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  // @override
  Widget build(BuildContext context) {
    DbService.dbPublic.instanceBD;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: _listUsersCards(),
      floatingActionButton: _botonesInferiores(),
    );
  }

  _botonesInferiores() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
            heroTag: "btnRest",
            child: Icon(Icons.qr_code),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GenerateScreen()),
              );
            }),
        FloatingActionButton(
          heroTag: "btnRest1",
          child: Icon(Icons.filter_center_focus),
          onPressed: () async {
            try {
              String jsonString = await FlutterBarcodeScanner.scanBarcode(
                  '#00FF00', "Cancelar", true, ScanMode.QR);

              if (jsonString.isNotEmpty) {
                final jsonResponse = jsonDecode(jsonString);
                UsersModel user = UsersModel(
                  token: jsonResponse['token'],
                  key: jsonResponse['key'],
                  usuario: jsonResponse['usuario'],
                  url_avatar: jsonResponse['url_avatar'],
                );

                service.insertUser(user);
                // service.getUsers();
              }

              setState(() {});
            } catch (e) {
              print(e);
            }
          },
        ),
      ],
    );
  }

  // Widget _listadoContactos() {
  //   return Container(
  //     child: ListView.builder(
  //       itemCount: 10,
  //       itemBuilder: (context, int index) {
  //         return ListTile(
  //           title: Text('contacto 1'),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _listUsersCards() {
    return FutureBuilder<List<UsersModel>>(
      future: _getUsers(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<dynamic>> snapshot,
      ) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return ListView(
              children: _listUsers(snapshot.data as dynamic, context),
            );
          } else {
            // ignore: avoid_unnecessary_containers
            return Container(
                child: const Text("No hay registros para mostrar"));
          }
        } else {
          // ignore: avoid_unnecessary_containers
          return Container(child: const Text("No hay registros para mostrar"));
        }
      },
    );
  }

  List<Widget> _listUsers(List<dynamic> data, BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    if (data.isNotEmpty) {
      return _usersList.map((elem) {
        // final item = _users[index];
        return Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30.0,
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(elem.url_avatar),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(elem.usuario),
                  ),
                ],
              ),
              onTap: () {
                userProv.addUser(elem); // fill provider

                Navigator.pushNamed(context, 'message');
              },
            ),
            const Divider(),
          ],
        );
      }).toList();
    } else {
      return [];
    }
  }

  Future<List<UsersModel>> _getUsers() async {
    _usersList = await DbService.dbPublic.getUsers();
    return _usersList;
  }
}
