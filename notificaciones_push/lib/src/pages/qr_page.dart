import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {
  
  String _dataString =
      '{"token":"token_aplicacion","key":"key_firebase", "usuario":"nombre_persona", "url_avatar":"ur del avatar"}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mi codigo'),),
      body: _contentWidget(),
    );
  }


  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(      
      child: Column(
        children: <Widget>[
          // Expanded(
          //   child: Center(
          //     child: RepaintBoundary(
          //       key: globalKey,
          //       child: 
                QrImage(
                  data: _dataString,
                  size: 0.5 * bodyHeight,
                ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
