import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdateStatusController extends GetxController {
  late TextEditingController statusT;

  @override
  void onInit() {
    statusT = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    statusT.dispose();
    super.onClose();
  }
}
