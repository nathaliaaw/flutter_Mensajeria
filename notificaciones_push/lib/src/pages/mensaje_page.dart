import 'package:flutter/material.dart';

class MensajePage extends StatefulWidget {
  @override
  _MensajePageState createState() => _MensajePageState();
}

class _MensajePageState extends State<MensajePage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments ?? 'No data';

    return Scaffold(
      appBar: AppBar(
        title: Text('En linea $args'),
      ),
      body: ListView(children: [_cuerpo()]),
    );
  }

  Widget _cuerpo() {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          _cajaTexto(),
          _historialMensajes(),
        ],
      ),
    );
  }

  Widget _cajaTexto() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.2,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Ingrese su mensaje',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
            // onChanged: bloc.changedescripcion,
          ),
          ElevatedButton(onPressed: () {}, child: Text("Registrar"))
        ],
      ),
    );
  }

  Widget _historialMensajes() {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(15.0),
      height: size.height * 0.6,
      width: double.infinity,
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: new BorderRadius.circular(40)),
      child: ListView(
        children:[  Column(
          children: [
            _mensajesEntrantes(Colors.blueAccent,
                'colorC colorCcol orCcolorC se debe borrar la caja de texto al momento del envío de la notificación y se debe cerrar el teclado colorCc olorCcolor color CcolorC colorCc olorCc olorC C'),
            ],
        ),
      ]
       
      ),
    );
  }

  _mensajesEntrantes(Color colorC, String texto) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10,left: 5,right: 5),
      constraints: BoxConstraints(
        maxHeight: double.infinity,
      ),
      decoration: BoxDecoration(
          color: colorC,
          // border: Border.all(color: Colors.blueAccent),
          borderRadius: new BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              '$texto',
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
