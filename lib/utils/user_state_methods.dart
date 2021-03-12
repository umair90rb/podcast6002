
import './user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserStateMethods {

  void setUserState(String userId, dynamic userState) {
    print(userState);
    FirebaseFirestore.instance.collection("profile").doc(userId).update({
      "status": userState.toString(),
      "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }


}
