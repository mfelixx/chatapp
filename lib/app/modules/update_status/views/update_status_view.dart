import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_status_controller.dart';

class UpdateStatusView extends GetView<UpdateStatusController> {
  UpdateStatusView({super.key});
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    controller.statusT.text = authC.users.value.status!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 0.5)),
            pinned: true,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            title: Text("Update status",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller: controller.statusT,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Input your status",
                    ),
                    onEditingComplete: () =>
                        authC.updateStatus(controller.statusT.text),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: Get.width,
                    child: ElevatedButton(
                      onPressed: () =>
                          authC.updateStatus(controller.statusT.text),
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                      child: Text("Update",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
