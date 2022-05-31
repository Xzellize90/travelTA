class LikeModel {
  int _id;
  int _idUser;
  int _idContent;
  int _like;
  LikeModel({
    int id,
    int idUser,
    int idContent,
    int like,
  }) {
    this._id = id;
    this._idUser = idUser;
    this._idContent = idContent;
    this._like = like;
  }

  int get id => _id;
  int get idUser => _idUser;
  int get idContent => _idContent;
  int get like => _like;

  LikeModel.fromJson(Map<String, dynamic> json) {
    _id = int.parse(json['id'].toString());
    _idUser = int.parse(json['id_user'].toString());
    _idContent = int.parse(json['id_content'].toString());
    _like = int.parse(json['like'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['idUser'] = this._idUser;
    data['idContent'] = this._idContent;
    data['like'] = this._like;
    return data;
  }
}
