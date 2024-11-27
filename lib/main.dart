import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';

import 'app/controllers/auth_controller.dart';
import 'app/utils/splashscreen.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 5)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Obx(
            () => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: authC.isSkip.isTrue
                  ? authC.isAuth.isTrue
                      ? Routes.HOME
                      : Routes.LOGIN
                  : Routes.INTRODUCTION,
              getPages: AppPages.routes,
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.white,
                ),
                scaffoldBackgroundColor: Colors.white,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          );
        }
        return FutureBuilder(
          future: authC.firstInit(),
          builder: (context, snapshot) => SplashScreen(),
        );
      },
    );
  }
}
