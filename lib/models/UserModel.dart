import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    String? uid,
    String? email,
    String? fullName,
    String? profilePic,
  }) {
    _uid = uid;
    _email = email;
    _fullname = fullName;
    _profilepic = profilePic;
  }

  UserModel.fromJson(dynamic json) {
    _uid = json['uid'];
    _email = json['email'];
    _fullname = json['fullname'];
    _profilepic = json['profilepic'];
  }

  String? _uid;
  String? _email;
  String? _fullname;
  String? _profilepic;

  UserModel copyWith({
    String? uid,
    String? email,
    String? fullname,
    String? profilepic,
  }) =>
      UserModel(
        uid: uid ?? _uid,
        email: email ?? _email,
        fullName: fullname ?? _fullname,
        profilePic: profilepic ?? _profilepic,
      );

  String? get uid => _uid;

  String? get email => _email;

  String? get fullname => _fullname;

  String? get profilepic => _profilepic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['email'] = _email;
    map['fullname'] = _fullname;
    map['profilepic'] = _profilepic;
    return map;
  }
}
