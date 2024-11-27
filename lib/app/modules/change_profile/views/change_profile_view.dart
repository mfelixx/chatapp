import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  ChangeProfileView({super.key});
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    controller.emailT.text = authC.users.value.email!;
    controller.nameT.text = authC.users.value.displayName!;
    controller.statusT.text = authC.users.value.status!;
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
            title: Text("Change profile",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: authC.users.value.photoUrl! == "noImage"
                          ? Image.asset("assets/logo/profile.png",
                              fit: BoxFit.cover)
                          : Image.network("${authC.users.value.photoUrl!}",
                              fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: controller.emailT,
                    readOnly: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Email",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: controller.nameT,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Name",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: controller.statusT,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Status",
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("No image"),
                      TextButton(onPressed: () {}, child: Text("Choosen")),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: Get.width,
                    child: ElevatedButton(
                      onPressed: () => authC.changeProfile(
                          controller.nameT.text, controller.statusT.text),
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
