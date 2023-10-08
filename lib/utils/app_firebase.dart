import 'package:cloud_firestore/cloud_firestore.dart';

class AppFirebase {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static openDb() {
    db = FirebaseFirestore.instance;
  }

  static closeDb() {
    db.clearPersistence();
    db.terminate();
  }
}
