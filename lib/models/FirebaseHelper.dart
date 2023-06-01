import 'package:cloud_firestore/cloud_firestore.dart';

import 'UserModel.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserById(String uid) async {
    UserModel? userModel;
    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    userModel = UserModel.fromJson(userData.data() as Map<String, dynamic>);
    return userModel;
  }
}
