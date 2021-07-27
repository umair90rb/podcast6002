import '../models/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection("call");

  var msgCollection =
  FirebaseFirestore.instance.collection("msgRequest");


  Stream callStream({String uid}){
    Query query = FirebaseFirestore.instance.collection("call");
    query = query.where('pid', isEqualTo: uid);
    query = query.where('status', isEqualTo: 'dialing');
    return query.snapshots();

  }

  Stream<QuerySnapshot> msgStream({String uid}){
    Query query = FirebaseFirestore.instance.collection("msgRequest");
    query = query.where('to', isEqualTo: uid);
    query = query.where('read', isEqualTo: false);
    return query.snapshots();
  }




  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      await callCollection
          .doc(call.callerId)
          .get()
          .then((value) => print(value.data));

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
