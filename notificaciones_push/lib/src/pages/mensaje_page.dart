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
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(40.0),
            topRight: const Radius.circular(40.0),
          )),
      child: Column(
        children: [
          Text('My Awesome Border'),
        ],
      ),
    );
  }
}
