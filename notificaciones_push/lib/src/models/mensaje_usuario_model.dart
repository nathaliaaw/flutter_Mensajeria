class MessageUserModel {
  int id;
  String tokenUserSender;
  String bodyMessage;
  String creationDate;
  int idMessage;
  int? idUser;

  MessageUserModel({
    this.id = 0,
    this.tokenUserSender = "",
    this.bodyMessage = "",
    this.creationDate = "",
    this.idMessage = 0,
    this.idUser = 0,
  });
}