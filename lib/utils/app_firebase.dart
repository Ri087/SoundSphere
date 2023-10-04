import 'package:cloud_firestore/cloud_firestore.dart';

class AppFirebase {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<String> getTestData() async {
    QuerySnapshot<Map<String, dynamic>> collectionReference = await db.collection("testcollection").get();
    if (collectionReference.docs[0]["testelement"] != null) {
      return collectionReference.docs[0]["testelement"];
    }
    return "No data";
  }

  static openDb() {
    db = FirebaseFirestore.instance;
  }

  static closeDb() {
    db.clearPersistence();
    db.terminate();
  }
}
