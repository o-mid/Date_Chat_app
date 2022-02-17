import 'dart:convert';

class User {
  String username;
  String biography;
  String avatar;
  int serverId;
  List<String> personalIssues;
  bool heretohelp;

  User(
      {required this.username,
      required this.biography,
      required this.avatar,
      required this.serverId,
      required this.heretohelp,
      required this.personalIssues});

  factory User.fromJson(Map<String, dynamic> jsonReponse) {
    return User(
        username: jsonReponse['username'],
        biography: jsonReponse['biography'],
        avatar: jsonReponse['avatar'],
        serverId: jsonReponse['serverId'],
        personalIssues: List<String>.from(
            json.decode(jsonReponse['personalIssues'] ?? "[]")),
        heretohelp: jsonReponse['heretohelp'] ?? false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['biography'] = this.biography;
    data['avatar'] = this.avatar;
    data['serverId'] = this.serverId;
    data['personalIssues'] = json.encode(this.personalIssues);
    data['heretohelp'] = this.heretohelp;

    return data;
  }
}
