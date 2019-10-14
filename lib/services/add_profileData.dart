import 'package:cloud_firestore/cloud_firestore.dart';
class UserData {
  Future<void> addData( profileData) async {
      Firestore.instance
          .collection('ProfileData')
          .add(profileData)
          .catchError((error) {
        print(error);
      });
  }
}
