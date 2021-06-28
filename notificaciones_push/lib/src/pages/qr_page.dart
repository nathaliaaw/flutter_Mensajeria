import 'package:flutter/material.dart';
import 'package:notificaciones_push/src/preferencia/general_preferencias.dart';
import 'package:notificaciones_push/src/provider/user_Provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {
  static const double _topSectionTopPadding = 20.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;
  String _inputErrorText = '';
  late Map<String, dynamic> _user;
  late Map<String, dynamic> _message;
  GlobalKey globalKey = new GlobalKey();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _urlAvatalController = TextEditingController();
  final TextEditingController _urlFirebaseController = TextEditingController();
  String _dataString = '';
  final _prefs= GeneralPreferences();
  // '{"token":"token_aplicacion","key":"key_firebase", "usuario":"nombre_persona", "url_avatar":"ur del avatar"}';

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    _user = userProv.getUser.isNotEmpty ? userProv.getUser : {};
    _message = _user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi codigo'),
      ),
      body: _contentWidget(),
    );
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      // color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPadding,
            ),
            child: Container(
              // height: _topSectionHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      hintText: 'Ingrese su nombre',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    // decoration: InputDecoration(
                    //   hintText: "Ingrese su nombre",
                    //   // errorText: _inputErrorText,
                    // ),
                  ),
                  Divider(),
                  TextField(
                    controller: _urlAvatalController,
                    decoration: InputDecoration(
                      labelText: 'Imagen',
                      hintText: 'Ingrese URL de su foto',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      //  errorText: _inputErrorText,
                    ),
                  ),
                  Divider(),
                  TextField(
                    controller: _urlFirebaseController,
                    decoration: InputDecoration(
                      labelText: 'URL de Firebase',
                      hintText: 'Ingrese URL de Firebase',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.filter_b_and_w),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      //  errorText: _inputErrorText,
                    ),
                  ),
                  Divider(),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.teal,
                      onSurface: Colors.grey,
                    ),
                    child: Text("Guardar"),
                    onPressed: () {
                      setState(() {
                        _dataString = '{"token": "'+
                        _prefs.getToken.toString()+'","key":"' +
                            _urlFirebaseController.text +
                            '","usuario":"' +
                            _textController.text +
                            '", "url_avatar":"' +
                            _urlAvatalController.text +
                            '"}';
                        _textController.text;
                        print(_dataString);
                        // '${_textController.text}';
                        // _inputErrorText = null;
                      });
                    },
                  ),
                  // )
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: globalKey,
                child: Container(
                  color: const Color(0xFFFFFFFF),
                  child: QrImage(
                    data: _dataString,
                    size: 0.5 * bodyHeight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
