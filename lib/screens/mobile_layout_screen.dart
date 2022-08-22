// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supperapp/common/utils/utils.dart';
import 'package:supperapp/features/auth/controller/auth_controller.dart';
import 'package:supperapp/features/group/screens/create_group_screen.dart';
import 'package:supperapp/features/select_contacts/screens/select_contact_sreens.dart';
import 'package:supperapp/features/chat/widget/contact_list.dart';
import 'package:supperapp/features/status/screen/confirm_status_screen.dart';
import 'package:supperapp/features/status/screen/status_contacts_screen.dart';
import 'package:supperapp/widgets/colors/colors.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
          centerTitle: false,
          title: const Text(
            'SuperApp',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
            PopupMenuButton(
              color: Colors.white,
              icon: const Icon(
                Icons.more_vert,
                color: Colors.yellow,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text(
                    ' Create Group',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Future(() => Navigator.pushNamed(
                        context, CreateGroupScreen.routeName));
                  },
                ),
                PopupMenuItem(
                  child: const Text(
                    'New BoradCast',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text(
                    'Link Device',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text(
                    'Starred Message',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text(
                    'Payments',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text(
                    'Setting',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALL',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: const [
            ContactsList(),
            StatusContactsScreen(),
            Text('Call'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabBarController.index == 0) {
              Navigator.pushNamed(context, SelectContactsScreen.routeName);
            } else {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                    arguments: pickedImage);
              }
            }
          },
          backgroundColor: tabColor,
          child: const Icon(Icons.comment, color: Colors.white),
        ),
      ),
    );
  }
}
