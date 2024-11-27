import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChangeProfileController extends GetxController {
  late TextEditingController nameT;
  late TextEditingController emailT;
  late TextEditingController statusT;

  @override
  void onInit() {
    emailT = TextEditingController();
    nameT = TextEditingController();
    statusT = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    nameT.dispose();
    emailT.dispose();
    statusT.dispose();
    super.onClose();
  }
}
