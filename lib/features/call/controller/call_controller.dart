import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supperapp/features/auth/controller/auth_controller.dart';
import 'package:supperapp/features/call/repository/call_repository.dart';
import 'package:supperapp/models/call.dart';
import 'package:uuid/uuid.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    ref: ref,
    auth: FirebaseAuth.instance,
  );
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void makeCall(
    BuildContext context,
    String recieverName,
    String recieverUid,
    String recieverProfilePic,
    bool isGroupChat,
  ) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value!.name,
        callerPic: value.profilePic,
        recieverId: recieverUid,
        recieverName: recieverName,
        recieverPic: recieverProfilePic,
        callId: callId,
        hasDialled: true,
      );
      Call recieverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        recieverId: recieverUid,
        recieverName: recieverName,
        recieverPic: recieverProfilePic,
        callId: callId,
        hasDialled: false,
      );
      if (isGroupChat) {
        callRepository.makeGroupCall(context, senderCallData, recieverCallData);
      } else {
        callRepository.makeCalls(context, senderCallData, recieverCallData);
      }
    });
  }

  void endCall(
    BuildContext context,
    String callerId,
    String recieverId,
  ) {
    callRepository.endCall(context, callerId, recieverId);
  }

  void endGroupCall(
    BuildContext context,
    String callerId,
    String recieverId,
  ) {
    callRepository.endCall(context, callerId, recieverId);
  }
}
