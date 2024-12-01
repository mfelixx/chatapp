import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: Colors.white,
            shape: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 0.5)),
            pinned: true,
            title: Text(
              "Chat",
            ),
            titleTextStyle: TextStyle(
              color: Colors.blue,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () => Get.toNamed(Routes.PROFILE),
                  icon: const Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: controller.chatStream(authC.users.value.email!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final allChats = snapshot.data!.docs;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) =>
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream:
                          controller.friendStream(allChats[i]["connection"]),
                      builder: (context, snapshot2) {
                        if (snapshot2.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 50,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final friendData = snapshot2.data!.data();
                        if (friendData == null) {
                          return SizedBox(
                            height: 50,
                            child: Center(child: Text("Friend data is null.")),
                          );
                        }

                        return ListTile(
                          onTap: () => Get.toNamed(Routes.CHAT_ROOM),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          leading: CircleAvatar(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: friendData["photoUrl"] == ""
                                  ? Image.asset("assets/logo/profile.png")
                                  : Image.network("${friendData["photoUrl"]}"),
                            ),
                          ),
                          title: Text(
                            "${friendData["displayName"]}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          subtitle: friendData["status"] != ""
                              ? Text(
                                  "${friendData["status"]}",
                                  style: TextStyle(fontSize: 12),
                                )
                              : null,
                          trailing: allChats[i]["totalUnread"] == 0
                              ? SizedBox()
                              : Chip(
                                  label: Text("${allChats[i]["totalUnread"]}"),
                                  labelStyle: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                  side: BorderSide.none,
                                  backgroundColor: Colors.grey[400],
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.zero,
                                ),
                        );
                      },
                    ),
                    childCount: allChats.length,
                  ),
                );
              }
              return SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Get.toNamed(Routes.SEARCH_CHAT),
        child: const Icon(
          Icons.message_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
