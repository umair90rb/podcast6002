
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'dart:async';

class DbServices{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

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

  Future addCollection(String collection, String id, String collectionName, String ref,  data) {

    DocumentReference docRef = firestore.collection(collection).doc(id);
    return docRef.collection(collectionName).doc(ref).set(data)
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

  Future getSnapshotWithDualQuery(String collection, String field, List<dynamic> value, String field1, List<dynamic> value1 ) async {
    CollectionReference colRef = firestore.collection(collection);
    QuerySnapshot querySnapshot = await colRef
        .where(field, isEqualTo: value)
        .where(field1, whereIn: value1)
        .get();
    return querySnapshot.docs;
  }

  Future getSnapshotWithTripleQuery(String collection, String field, List<dynamic> value,
      String field1, List<dynamic> value1, String field2, List<dynamic> value2 ) async {
    CollectionReference colRef = firestore.collection(collection);
    QuerySnapshot querySnapshot = await colRef
        .where(field, whereIn: value)
        .where(field1, isEqualTo: value1)
        .where(field2, isEqualTo: value2)
        .get();
    return querySnapshot.docs;
  }

  Future deleteDoc(String collection, String docId) async {
    DocumentReference docRef = firestore.collection(collection).doc(docId);
    try {
      await docRef.delete();
      return true;
    } on Exception catch (e){
      return e;
    }
  }

  Future uploadFile(String collection, File file) async {
    String name = basename(file.path);
    firebase_storage.Reference ref = storage.ref('$collection/$name');
    try {
      await ref.putFile(file);
      dynamic url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      return e;
    }
  }

  Future deleteFile(String url) async {
    firebase_storage.Reference ref = storage.refFromURL(url);
    try {
      await ref.delete();
      return true;
    } on Exception catch (e){
      return e;
    }
  }


}
