import 'package:tracker_app/services/collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  get db => _db;
  
  Future<void> createUserDocument(String email, String name) async {
    String uid = _auth.currentUser!.uid;
    final db = FirebaseFirestore.instance;

    await db.collection("Users").doc(uid).set({
      'email': email,
      'username': name,
    });

    await db.collection("Mileage").doc(uid).set(Miles.defaultInputs().toMap());
    await db.collection("Energy").doc(uid).set(Energy.defaultInputs().toMap());
    await db.collection("Carbon").doc(uid).set(Carbon.defaultInputs().toMap());
    await db.collection("Setup").doc(uid).set({"setupFinished": false});
  }

  Future<T?> getUserData<T>(String uid, String collection,
      T Function(DocumentSnapshot) fromDocument) async {
    try {
      DocumentSnapshot doc = await _db.collection(collection).doc(uid).get();
      return fromDocument(doc);
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<Miles?> getUserMiles(String uid) {
    return getUserData(uid, "Mileage", (doc) => Miles.fromDocument(doc));
  }

  Future<Energy?> getUserEnergy(String uid) {
    return getUserData(uid, "Energy", (doc) => Energy.fromDocument(doc));
  }

  Future<Carbon?> getUserCarbon(String uid) {
    return getUserData(uid, "Carbon", (doc) => Carbon.fromDocument(doc));
  }

  Future<bool?> getSetup(String uid){
    return getUserData(uid, "Setup", (doc) => doc['setupFinished']);
  }

  Future<void> updateValue(String collection, String uid, Map<String, dynamic> data) async {
    try{
      await _db.collection(collection).doc(uid).set(data);
    } catch (e){
      print(e);
      return;
    }
  }

  Future<void> deleteUserInfo(String uid) async {
    db.collection("Mileage").doc(uid).delete();
    db.collection("Energy").doc(uid).delete();
    db.collection("Carbon").doc(uid).delete();
    db.collection("Setup").doc(uid).delete();
    db.collection("Users").doc(uid).delete();
  }
}
