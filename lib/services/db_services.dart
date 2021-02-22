import 'dart:io';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DbServices{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addData(String collection, data) {
    CollectionReference colRef = firestore.collection(collection);
    return colRef.add(data)
        .then((value){return true;})
        .catchError((error){return false;});
  }

  Future addDataWithId(String collection, String id, data) {

    DocumentReference docRef = firestore.collection(collection).doc(id);
    return docRef.set(data)
        .then((value){return true;})
        .catchError((error){return false;});
  }



  Future getSnapshot(String collection) async {
    CollectionReference colRef = firestore.collection(collection);
     QuerySnapshot querySnapshot = await colRef.get();
     return querySnapshot.docs;
  }

  Future<DocumentSnapshot> getDoc(String collection, String docId) async {
    print(docId);
    DocumentReference docRef = firestore.collection(collection).doc(docId);
    DocumentSnapshot doc = await docRef.get();
    print(doc.data());
    return doc;
  }


  Future updateDoc(String collection, String docId, Map<String, dynamic> data) async {
    DocumentReference docRef = firestore.collection(collection).doc(docId);
    docRef.update(data).then((value){
      return true;
    }).catchError((e){
      return e;
    });
  }

  Future getSnapshotWithQuery(String collection, String field, List<dynamic> value ) async {
    CollectionReference colRef = firestore.collection(collection);
    QuerySnapshot querySnapshot = await colRef
        .where(field, whereIn: value)
        .get();
    return querySnapshot.docs;
  }


  Future uploadFile(String collection, File file) async {
    String name = basename(file.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('$collection/$name');
    try {
      await ref.putFile(file);
      dynamic url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      return e;
    }
  }


}