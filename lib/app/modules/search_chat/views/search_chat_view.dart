import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/search_chat_controller.dart';

class SearchChatView extends GetView<SearchChatController> {
  SearchChatView({super.key});
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          Obx(
            () {
              return SliverAppBar(
                automaticallyImplyLeading:
                    controller.isSearch.isFalse ? true : false,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shadowColor: Colors.grey[200],
                pinned: true,
                title: controller.isSearch.isFalse
                    ? Text("Search name",
                        style: TextStyle(color: Colors.white, fontSize: 20))
                    : SizedBox(
                        // decoration: BoxDecoration(border: Border.all()),
                        height: 40,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.bottom,
                          cursorColor: Colors.blue,
                          controller: controller.searchController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide.none),
                            hintText: "Search",
                            prefixIcon: IconButton(
                              onPressed: () {
                                controller.searchController.clear();
                                controller.tempSearch.value = [];
                                controller.isSearch.value =
                                    !controller.isSearch.value;
                              },
                              color: Colors.blue,
                              hoverColor: Colors.transparent,
                              icon: Icon(
                                Icons.arrow_back,
                              ),
                            ),
                          ),
                          onChanged: (value) => controller.searchFriend(
                              value, authC.users.value.email!),
                        ),
                      ),
                actions: [
                  controller.isSearch.isFalse
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            onPressed: () {
                              controller.isSearch.value =
                                  !controller.isSearch.value;
                            },
                            color: Colors.white,
                            icon: Icon(
                              Icons.search,
                              size: 30,
                            ),
                          ),
                        )
                      : Container()
                ],
              );
            },
          ),
          Obx(
            () => controller.tempSearch.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                        child: SizedBox(
                      width: Get.width * 0.5,
                      child: Lottie.asset(
                        "assets/lottie/empty.json",
                      ),
                    )),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        leading: CircleAvatar(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: controller.tempSearch[i]["photoUrl"] == ""
                                ? Image.asset("assets/logo/profile.png")
                                : Image.network(
                                    "${controller.tempSearch[i]["photoUrl"]}"),
                          ),
                        ),
                        title: Text(
                          "${controller.tempSearch[i]["displayName"]}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          "${controller.tempSearch[i]["email"]}",
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: GestureDetector(
                          onTap: () => authC.createConnection(
                              controller.tempSearch[i]["email"]),
                          child: Chip(
                            label: Icon(Icons.chat_outlined),
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 10),
                            side: BorderSide.none,
                            backgroundColor: Colors.transparent,
                            // shape: CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      childCount: controller.tempSearch.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
