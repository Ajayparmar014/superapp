import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supperapp/common/utils/utils.dart';
import 'package:supperapp/features/call/screens/call_screen.dart';
import 'package:supperapp/models/call.dart';
import 'package:supperapp/models/group.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });
  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCalls(
    BuildContext context,
    Call senderCallData,
    Call recieverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(senderCallData.recieverId)
          .set(recieverCallData.toMap());
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
              channelId: senderCallData.callId,
              call: senderCallData,
              isGroupChat: false),
        ),
      );
    } catch (e) {
      showsnackBar(context: context, content: e.toString());
    }
  }

  // Group call
  void makeGroupCall(
    BuildContext context,
    Call senderCallData,
    Call recieverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      var groupSnapshot = await firestore
          .collection('groups')
          .doc(senderCallData.recieverId)
          .get();
      Group group = Group.fromMap(groupSnapshot.data()!);

      for (var id in group.membersUid) {
        await firestore
            .collection('call')
            .doc(id)
            .set(recieverCallData.toMap());
      }

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
              channelId: senderCallData.callId,
              call: senderCallData,
              isGroupChat: true),
        ),
      );
    } catch (e) {
      showsnackBar(context: context, content: e.toString());
    }
  }

  //call end function
  void endCall(
    BuildContext context,
    String callerId,
    String recieverId,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(recieverId).delete();
    } catch (e) {
      showsnackBar(context: context, content: e.toString());
    }
  }

  //End Group call function
  void endGroupCall(
    BuildContext context,
    String callerId,
    String recieverId,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      var groupSnapshot =
          await firestore.collection('groups').doc(recieverId).get();
      Group group = Group.fromMap(groupSnapshot.data()!);
      for (var id in group.membersUid) {
        await firestore.collection('call').doc(id).delete();
      }
    } catch (e) {
      showsnackBar(context: context, content: e.toString());
    }
  }
}
