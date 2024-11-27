import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Selamat datang di MyChatApp!",
            body:
                "Hubungkan, berbagi, dan terhubung dengan orang-orang terdekat Anda kapan saja, di mana saja.",
            image: Container(
              // decoration: BoxDecoration(border: Border.all()),
              height: Get.height * 0.3,
              width: Get.width * 0.5,
              child:
                  Center(child: Lottie.asset("assets/lottie/first-intro.json")),
            ),
            decoration: const PageDecoration(
              imagePadding: EdgeInsets.only(bottom: 0),
              bodyTextStyle: TextStyle(fontSize: 16),
            ),
          ),
          PageViewModel(
            title: "Terhubung Tanpa Batas!",
            body:
                "Mulai percakapan dalam satu ketukan. Jalin hubungan dengan lebih mudah.",
            image: Container(
              // decoration: BoxDecoration(border: Border.all()),
              height: Get.height * 0.3,
              width: Get.width * 0.7,
              child: Center(child: Lottie.asset("assets/lottie/intro1.json")),
            ),
            decoration: const PageDecoration(
              imagePadding: EdgeInsets.only(bottom: 0),
              bodyTextStyle: TextStyle(fontSize: 17),
            ),
          ),
          PageViewModel(
            title: "Ekspresikan Diri Anda",
            body:
                "Buat setiap pesan lebih berkesan. Tunjukkan perasaan Anda dengan mudah.",
            image: Container(
              // decoration: BoxDecoration(border: Border.all()),
              height: Get.height * 0.3,
              width: Get.width * 0.7,
              child: Center(child: Lottie.asset("assets/lottie/intro2.json")),
            ),
            decoration: const PageDecoration(
              imagePadding: EdgeInsets.only(bottom: 0),
              bodyTextStyle: TextStyle(fontSize: 17),
            ),
          ),
        ],
        showSkipButton: true,
        skip: const Icon(Icons.skip_next),
        next: const Text("Next"),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w700)),
        onDone: () => Get.offAllNamed(Routes.LOGIN),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).colorScheme.secondary,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }
}
