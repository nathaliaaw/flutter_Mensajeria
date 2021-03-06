// message_page.dart:
import 'package:flutter/material.dart';
import 'package:notificaciones_push/src/models/mensaje_usuario_model.dart';
import 'package:notificaciones_push/src/models/mesajes_model.dart';
import 'package:notificaciones_push/src/preferencia/general_preferencias.dart';
import 'package:notificaciones_push/src/provider/user_Provider.dart';
import 'package:notificaciones_push/src/servicio/db_service.dart';
import 'package:notificaciones_push/src/servicio/notificacion_push_servicio.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  DbService service = DbService();
  NotificationService notification = NotificationService();
  List<MessageUserModel> _messageList = <MessageUserModel>[];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _ctrlMessages = TextEditingController();
  late Map<String, dynamic> _user;
  late Map<String, dynamic> _message;
  final _preferences = GeneralPreferences();

  @override
  void initState() {
    super.initState();
    _getMessages();
  }

  @override
  Widget build(BuildContext context) {
    DbService.dbPublic.instanceBD;
    final userProv = Provider.of<UserProvider>(context);
    _user = userProv.getUser.isNotEmpty ? userProv.getUser : {};
    _message = _user;
    // _getMessages();
    String usuario = _message["usuario"];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Text("En linea"),
            const SizedBox(
              width: 10.0,
            ),
            Text('$usuario'),
          ],
        ),
      ),
      body: ListView(children: [
        _body(),
      ]),
    );
  }

  Widget _body() {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          _textBox(),
          _messageHistory(),
        ],
      ),
    );
  }

  Widget _textBox() {
    final size = MediaQuery.of(context).size;
    // ignore: sized_box_for_whitespace
    return Container(
      height: size.height * 0.2,
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _ctrlMessages,
                  keyboardType: TextInputType.text,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Digite su mensaje',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    notification.sendNotification(
                      key: _message['key'],
                      userTokenSender: _preferences.getToken,
                      token: _message['token'],
                      message: _ctrlMessages.text,
                    );
                    insertMessage();
                    _formKey.currentState!.reset();
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10.0,
                  ),
                  child: const Text("Enviar Mensaje"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void insertMessage() async {
    try {
      MessageNotifyModel msgObj = MessageNotifyModel(
        bodyMessage: _ctrlMessages.text,
        creationDate: DateTime.now().toString(),
      );
      final messageId = await service.insertMessage(msgObj);
      MessageUserModel msgUser = MessageUserModel(
        tokenUserSender: _message['token'],
        idMessage: messageId,
        idUser: _message['id'],
      );
      await service.insertMessageUser(msgUser);
    } catch (e) {}
  }

  Widget _messageHistory() {
    final size = MediaQuery.of(context).size;
    return FutureBuilder<List<MessageUserModel>>(
        future: _getMessages(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<dynamic>> snapshot,
        ) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.all(15.0),
                height: size.height * 0.6,
                width: double.infinity,
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(40)),
                child: ListView(
                  children: _listMessage(),
                ),
              );
            } else {
              return Center(
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                child: const Text("No hay registros para mostrar"),
              ));
            }
          } else {
            return Center(
                // ignore: avoid_unnecessary_containers
                child: Container(
              child: const Text("No hay registros para mostrar"),
            ));
          }
        });
  }

  List<Widget> _listMessage() {
    return _messageList.map((elem) {
      final isUser = (elem.idUser != 0) ? elem.idUser == _message['id'] : false;
      return Column(
        children: [
          _mensajesEntrantes(
              isUser ? Colors.blueGrey : Colors.blueAccent, elem,isUser?Alignment.bottomRight:Alignment.bottomLeft),
        ],
      );
    }).toList();
  }

_mensajesEntrantes(
    Color colorC,
    MessageUserModel data,
    Alignment align,
  ) {
    return Container(
      alignment: align,
      margin: const EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
      ),
      constraints: const BoxConstraints(
        maxHeight: double.infinity,
      ),
      decoration: BoxDecoration(
        color: colorC,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.bodyMessage,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                Text(
                  data.creationDate,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<List<MessageUserModel>> _getMessages() async {
    _messageList =
        (await DbService.dbPublic.getMessageByIdUser(_message['token']));
    return _messageList;
  }
}
