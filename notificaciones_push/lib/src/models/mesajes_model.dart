class MensajeModel {
  int id;
  String body;
  DateTime fecha = DateTime.now();

  MensajeModel({
    this.id = 0,
    this.body = '',
  });
}
