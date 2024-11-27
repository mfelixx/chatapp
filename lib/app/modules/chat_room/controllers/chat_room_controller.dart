import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  var emojiIsOpen = false.obs;

  late FocusNode focusNode;
  late TextEditingController chatT;

  void addEmoji(Emoji emoji) {
    chatT.text = chatT.text + emoji.emoji;
  }

  void deleteEmoji() {
    chatT.text = chatT.text.substring(0, chatT.text.length - 2);
  }

  @override
  void onInit() {
    chatT = TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          emojiIsOpen.value = false;
        }
      },
    );
    super.onInit();
  }

  @override
  void onClose() {
    focusNode.dispose();
    chatT.dispose();
    super.onClose();
  }
}
