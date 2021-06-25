class MessageUserModel {
  int id;
  String tokenUserSender;
  String bodyMessage;
  int idMessage;
  int? idUser;

  MessageUserModel({
    this.id = 0,
    this.tokenUserSender = "",
    this.bodyMessage = "",
    this.idMessage = 0,
    this.idUser = 0,
  });
}