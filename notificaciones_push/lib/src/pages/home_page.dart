import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:notificaciones_push/src/models/usuario_models.dart';
import 'package:notificaciones_push/src/pages/qr_page.dart';
import 'package:notificaciones_push/src/servicio/db_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String textoLeido = '';
  DBService service = DBService();
  List<UsuarioModel> _usersList = <UsuarioModel>[];

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  // @override
  Widget build(BuildContext context) {
    DBService.dbPublic.instanceBD;
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
                UsuarioModel user = UsuarioModel(
                  token: jsonResponse['token'],
                  key: jsonResponse['key'],
                  usuario: jsonResponse['usuario'],
                  urlAvatar: jsonResponse['urlAvatar'],
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
    return FutureBuilder<List<UsuarioModel>>(
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
    if (data.isNotEmpty) {
      return _usersList.map((elem) {
        // final item = _users[index];
        return Column(
          children: [
            ListTile(
              title: Text(elem.usuario),
              onTap: () {
                Navigator.pushNamed(context, 'message',
                    arguments: elem.usuario);
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

  List<Widget> _listaUsers(List<dynamic> data, BuildContext context) {
    if (data.isNotEmpty) {
      return _usersList.map((elem) {
        // final item = _users[index];
        return Column(
          children: [
            Dismissible(
              direction: DismissDirection.endToStart,
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Advertencia"),
                      content:
                          const Text("Estas seguro de eliminar este registro?"),
                      actions: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              elevation: 5.0,
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  // BDusa.dbPublic.deleteUserById(elem.id);
                                  _getUsers();
                                  Navigator.of(context).pop(false);
                                },
                              );
                            },
                            child: const Text("Eliminar")),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancelar"),
                        ),
                      ],
                    );
                  },
                );
              },
              background: Container(
                padding: const EdgeInsets.all(20.0),
                color: Colors.redAccent,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.remove,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
              key: Key(
                elem.id.toString(),
              ),
              child: ListTile(
                title: Text(elem.usuario),
                subtitle: Text(elem.usuario),
                onTap: () {},
              ),
            ),
            const Divider(),
          ],
        );
      }).toList();
    } else {
      return [];
    }
  }

  Future<List<UsuarioModel>> _getUsers() async {
    _usersList = await DBService.dbPublic.getUsers();
    return _usersList;
  }
}
