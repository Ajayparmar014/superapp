import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supperapp/common/widgets/error.dart';
import 'package:supperapp/features/auth/screens/login_screen.dart';
import 'package:supperapp/features/auth/screens/otp_screen.dart';
import 'package:supperapp/features/auth/screens/user_information.dart';
import 'package:supperapp/features/group/screens/create_group_screen.dart';
import 'package:supperapp/features/select_contacts/screens/select_contact_sreens.dart';
import 'package:supperapp/features/chat/screen/mobile_chat_screen.dart';
import 'package:supperapp/features/status/screen/confirm_status_screen.dart';
import 'package:supperapp/features/status/screen/status_screen.dart';
import 'package:supperapp/models/status_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OtpScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OtpScreen(
                verificationId: verificationId,
              ));
    case UserInformation.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformation(),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactsScreen());
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (contet) => ConfirmStatusScreen(file: file),
      );
    case StatusScreen.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
        builder: (contex) => StatusScreen(
          status: status,
        ),
      );
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(builder: (context) => const CreateGroupScreen());
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: 'this page does not exit'),
              ));
  }
}
