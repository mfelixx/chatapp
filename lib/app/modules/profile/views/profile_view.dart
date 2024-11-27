import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 0.5)),
            pinned: true,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            title: Text("Profile",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () => authC.logout(),
                  icon: const Icon(
                    Icons.logout_outlined,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!, width: 0.5)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: authC.users.value.photoUrl == "noImage"
                            ? Image.asset("assets/logo/profile.png",
                                fit: BoxFit.cover)
                            : Image.network("${authC.users.value.photoUrl}",
                                fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${authC.users.value.displayName}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${authC.users.value.email}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
                        leading: const Icon(Icons.flip_camera_android_outlined),
                        title: const Text("Status"),
                        subtitle: Text("Update your status here",
                            style: TextStyle(color: Colors.grey[600])),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: () => Get.toNamed(Routes.CHANGE_PROFILE),
                        leading: const Icon(Icons.person_2_outlined),
                        title: const Text("Profile"),
                        subtitle: Text("Change your profile here",
                            style: TextStyle(color: Colors.grey[600])),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: const Icon(Icons.color_lens_outlined),
                        title: const Text("Theme"),
                        subtitle: Text("Light",
                            style: TextStyle(color: Colors.grey[600])),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      bottom: Get.context!.mediaQueryPadding.bottom + 20),
                  child: Column(
                    children: [
                      Text(
                        "Chat App",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        "Version 1.0.0",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
