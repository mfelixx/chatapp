import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => WillPopScope(
          onWillPop: () async {
            if (controller.emojiIsOpen.value) {
              controller.emojiIsOpen.value = false;
            } else {
              Get.back();
            }
            return false;
          },
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      shape: Border(
                          bottom:
                              BorderSide(color: Colors.grey[200]!, width: 1)),
                      pinned: true,
                      title: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/logo/profile.png"),
                        ),
                        title: Text(
                          "Mikhael",
                          // style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        subtitle: Text(
                          "Online",
                          // style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        ItemChat(isSender: true),
                        ItemChat(isSender: false),
                        ItemChat(isSender: true),
                        ItemChat(isSender: false),
                        ItemChat(isSender: true),
                        ItemChat(isSender: false),
                        ItemChat(isSender: true),
                        ItemChat(isSender: false),
                        ItemChat(isSender: true),
                        ItemChat(isSender: false),
                        ItemChat(isSender: true),
                        ItemChat(isSender: false),
                      ]),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: controller.chatT,
                          focusNode: controller.focusNode,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: IconButton(
                              onPressed: () {
                                controller.focusNode.unfocus();
                                controller.emojiIsOpen.toggle();
                              },
                              icon: Icon(Icons.emoji_emotions_outlined),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none),
                            hintText: "Type a message",
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue),
                        iconColor: WidgetStatePropertyAll(Colors.white),
                        iconSize: WidgetStatePropertyAll(20),
                      ),
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                      ),
                    )
                  ],
                ),
              ),
              if (controller.emojiIsOpen.isTrue)
                SizedBox(
                  child: EmojiPicker(
                    onEmojiSelected: (Category? category, Emoji emoji) =>
                        controller.addEmoji(emoji),
                    onBackspacePressed: () => controller.deleteEmoji(),
                    // textEditingController:
                    //     textEditingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                    config: Config(
                      customBackspaceIcon: Icon(Icons.backspace_outlined),
                      checkPlatformCompatibility: true,
                      emojiViewConfig: EmojiViewConfig(
                        columns: 7,
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 28 * (GetPlatform.isIOS ? 1.20 : 1.0),
                        verticalSpacing: 5,
                        horizontalSpacing: 5,
                        backgroundColor: Colors.grey[200]!,
                      ),
                      viewOrderConfig: const ViewOrderConfig(
                        top: EmojiPickerItem.searchBar,
                        middle: EmojiPickerItem.emojiView,
                        bottom: EmojiPickerItem.categoryBar,
                      ),
                      skinToneConfig: const SkinToneConfig(),
                      categoryViewConfig: const CategoryViewConfig(),
                      bottomActionBarConfig: BottomActionBarConfig(
                        backgroundColor: Colors.grey[200]!,
                        buttonColor: Colors.transparent,
                        buttonIconColor: Colors.grey.shade800,
                      ),
                      searchViewConfig: SearchViewConfig(),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat({super.key, required this.isSender});
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width * 0.6,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: isSender ? Radius.circular(10) : Radius.circular(0),
                topRight: isSender ? Radius.circular(0) : Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child:
                Text("Halo nama aku mikhael, aku kuliah di universitas jambi"),
          ),
          Text("18:00 PM"),
        ],
      ),
    );
  }
}
