import 'package:chatapp/app/data/models/users_model.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSkip = false.obs;
  var isAuth = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var users = UsersModel().obs;

  Future<void> firstInit() async {
    final autoLog = await autoLogin();
    if (autoLog) {
      isAuth.value = true;
    }
    final skipIntro = await skipIntroduction();
    if (skipIntro) {
      isSkip.value = true;
    }
  }

  Future<bool> skipIntroduction() async {
    final box = GetStorage();
    if (box.read("skipIntro") != null || box.read("skipIntro") == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    final isSignIn = await _googleSignIn.isSignedIn();
    if (isSignIn) {
      final googleUser = await _googleSignIn.signInSilently();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      CollectionReference collectionUsers = firestore.collection('users');
      final checkusers = await collectionUsers.doc(googleUser!.email).get();

      // masukkan data user ke firestore
      await collectionUsers.doc(googleUser.email).update({
        "lastLogin":
            userCredential.user!.metadata.lastSignInTime!.toIso8601String()
      });

      final currentUser = checkusers.data() as Map<String, dynamic>;
      users(UsersModel.fromJson(currentUser));

      return true;
    }
    return false;
  }

  Future<void> login() async {
    final box = GetStorage();
    try {
      await _googleSignIn.signOut();
      final googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (box.read("skipIntro") != null || box.read("skipIntro") == true) {
        box.remove("skipIntro");
      }
      box.write("skipIntro", true);

      CollectionReference collectionUsers = firestore.collection('users');
      final checkusers = await collectionUsers.doc(googleUser!.email).get();

      if (checkusers.exists) {
        await collectionUsers.doc(googleUser.email).update({
          "lastLogin":
              userCredential.user!.metadata.lastSignInTime!.toIso8601String()
        });
      } else {
        // masukkan data user ke firestore
        await collectionUsers.doc(googleUser.email).set({
          'uid': userCredential.user!.uid,
          'displayName': googleUser.displayName,
          'keyName': googleUser.displayName!.substring(0, 1).toUpperCase(),
          'email': googleUser.email,
          'photoUrl': googleUser.photoUrl,
          'status': "",
          'creadtedAt':
              userCredential.user!.metadata.creationTime!.toIso8601String(),
          'lastLogin':
              userCredential.user!.metadata.lastSignInTime!.toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          "chats": [],
        });
      }
      final currentUser = checkusers.data() as Map<String, dynamic>;
      users(UsersModel.fromJson(currentUser));

      isAuth.value = true;
      Get.offAllNamed(Routes.HOME);
    } catch (error) {
      print(error);
    }
  }

  void logout() {
    _googleSignIn.disconnect();
    _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void changeProfile(String name, String status) async {
    String date = DateTime.now().toIso8601String();

    // update db
    final googleUser = await _googleSignIn.signInSilently();
    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken,
      accessToken: googleAuth?.accessToken,
    );
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    CollectionReference collectionUsers = firestore.collection('users');
    collectionUsers.doc(googleUser!.email).update({
      "displayName": name,
      "keyName": name.substring(0, 1).toUpperCase(),
      "status": status,
      "lastLogin":
          userCredential.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedAt": date,
    });

    // update user model
    users.update((user) {
      user!.displayName = name;
      user.keyName = name.substring(0, 1).toUpperCase();
      user.status = status;
      user.lastLogin =
          userCredential.user!.metadata.lastSignInTime!.toIso8601String();
      user.updateAt = date;
    });

    users.refresh();
    Get.snackbar("Success", "Profile Updated");
  }

  void updateStatus(String status) async {
    String date = DateTime.now().toIso8601String();

    // update db
    final googleUser = await _googleSignIn.signInSilently();
    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken,
      accessToken: googleAuth?.accessToken,
    );
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    CollectionReference collectionUsers = firestore.collection('users');
    collectionUsers.doc(googleUser!.email).update({
      "status": status,
      "lastLogin":
          userCredential.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedAt": date,
    });

    users.update((user) {
      user!.status = status;
      user.lastLogin =
          userCredential.user!.metadata.lastSignInTime!.toIso8601String();
      user.updateAt = date;
    });

    users.refresh();
    Get.snackbar("Success", "Status Updated");
  }

  void createConnection(String friendEmail) async {
    bool flagNewConnect = false;
    var chat_id;
    String date = DateTime.now().toIso8601String();
    CollectionReference userCollection = firestore.collection('users');
    CollectionReference chats = firestore.collection('chats');
    final googleUser = await _googleSignIn.signInSilently();

    // jika belum pernah punya history chat
    final docUser = await userCollection.doc(googleUser!.email).get();
    final docChats = (docUser.data() as Map<String, dynamic>)["chats"] as List;

    if (docChats.isNotEmpty) {
      // user sudah pernah chat dgn seseorang
      for (var e in docChats) {
        if (e["connection"] == friendEmail) {
          chat_id = e["chat_id"];
        }
      }

      if (chat_id != null) {
        // if docChats[connection] == friendEmail
        flagNewConnect = false;
      } else {
        // if docChats[connection] != friendEmail
        flagNewConnect = true;
      }
    } else {
      // user belum pernah chat dgn seseorang
      flagNewConnect = true;
    }

    if (flagNewConnect) {
      // cek chats collection, apakah keduanya sudah mempunyai koneksi
      final chatDocs = await chats.where("connection", whereIn: [
        [googleUser.email, friendEmail],
        [friendEmail, googleUser.email]
      ]).get();

      if (chatDocs.docs.isNotEmpty) {
        // terdapat chat, sudah ada koneksi
        final chatDataId = chatDocs.docs[0].id;
        final chatsData = chatDocs.docs[0].data() as Map<String, dynamic>;
        docChats.add({
          "connection": friendEmail,
          "chat_id": chatDataId,
          "lastTime": chatsData["lastTime"]
        });
        await userCollection.doc(googleUser.email).update({"chats": docChats});

        users.update((user) {
          user!.chats = docChats as List<Chat>;
        });

        chat_id = chatDataId;
        users.refresh();
      } else {
        final newChat = await chats.add({
          "connection": [googleUser.email, friendEmail],
          "total_chats": 0,
          "total_read": 0,
          "total_unread": 0,
          "chat": [],
          "lastTime": date
        });

        userCollection.doc(googleUser.email).update({
          "chats": [
            {"connection": friendEmail, "chat_id": newChat.id, "lastTime": date}
          ]
        });

        docChats.add({
          "connection": friendEmail,
          "chat_id": newChat.id,
          "lastTime": date
        });
        await userCollection.doc(googleUser.email).update({"chats": docChats});

        users.update((user) {
          user!.chats = docChats as List<Chat>;
        });

        chat_id = newChat.id;
        users.refresh();
      }
    }
    Get.toNamed(Routes.CHAT_ROOM, arguments: chat_id);
  }
}
