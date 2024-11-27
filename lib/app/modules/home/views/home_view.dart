import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final mychats = List.generate(
    20,
    (i) => ListTile(
      onTap: () => Get.toNamed(Routes.CHAT_ROOM),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      leading: CircleAvatar(
        child: Image.asset("assets/logo/profile.png"),
      ),
      title: Text(
        "Nama ke- ${i + 1}",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        "Chat dari nama ke- ${i + 1}",
        style: TextStyle(fontSize: 12),
      ),
      trailing: Chip(
        label: Text(
          "1",
        ),
        labelStyle: TextStyle(color: Colors.white, fontSize: 10),
        side: BorderSide.none,
        backgroundColor: Colors.grey[400],
        shape: CircleBorder(),
        padding: EdgeInsets.zero,
      ),
    ),
  ).reversed.toList();

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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => mychats[index],
              childCount: mychats.length,
            ),
          ),
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
