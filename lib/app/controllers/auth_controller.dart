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
      final checkusers = collectionUsers.doc(googleUser!.email);

      // masukkan data user ke firestore
      await checkusers.update({
        "lastLogin":
            userCredential.user!.metadata.lastSignInTime!.toIso8601String()
      });
      final currUser = await collectionUsers.doc(googleUser.email).get();
      final currentUser = currUser.data() as Map<String, dynamic>;

      users(UsersModel.fromJson(currentUser));
      users.refresh();

      final listChats =
          await collectionUsers.doc(googleUser.email).collection("chats").get();

      if (listChats.docs.isNotEmpty) {
        List<Chat> dataListChats = [];
        for (var e in listChats.docs) {
          final dataDocChat = e.data();
          final dataDocChatId = e.id;
          dataListChats.add(Chat(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              totalUnread: dataDocChat["totalUnread"]));
        }
        users.update((user) {
          user!.chats = dataListChats;
        });
      } else {
        users.update((user) {
          user!.chats = [];
        });
      }

      users.refresh();
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

      if (checkusers.data() != null) {
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
        });

        // buat collection chats
        collectionUsers.doc(googleUser.email).collection("chats");
      }

      final docUser = await collectionUsers.doc(googleUser.email).get();
      final currentUser = docUser.data() as Map<String, dynamic>;

      users(UsersModel.fromJson(currentUser));
      users.refresh();

      // users(UsersModel(
      //   uid: currentUser["uid"],
      //   displayName: currentUser["displayName"],
      //   keyName: currentUser["keyName"],
      //   email: currentUser["email"],
      //   photoUrl: currentUser["photoUrl"],
      //   status: currentUser["status"],
      //   createdAt: currentUser["creadtedAt"],
      //   lastLogin: currentUser["lastLogin"],
      //   updateAt: currentUser["updatedAt"],
      // ));

      final listChats =
          await collectionUsers.doc(googleUser.email).collection("chats").get();

      if (listChats.docs.isNotEmpty) {
        List<Chat> dataListChats = [];
        for (var e in listChats.docs) {
          final dataDocChat = e.data();
          final dataDocChatId = e.id;
          dataListChats.add(Chat(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              totalUnread: dataDocChat["totalUnread"]));
        }
        users.update((user) {
          user!.chats = dataListChats;
        });
      } else {
        users.update((user) {
          user!.chats = [];
        });
      }

      users.refresh();
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
    final docChats =
        await userCollection.doc(googleUser!.email).collection("chats").get();

    if (docChats.docs.isNotEmpty) {
      // user sudah pernah chat dengan seseorang
      final checkConnection = await userCollection
          .doc(googleUser.email)
          .collection("chats")
          .where("connection", isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.isNotEmpty) {
        // if docChats[connection] == friendEmail
        flagNewConnect = false;
        chat_id = checkConnection.docs[0].id;
      } else {
        // if docChats[connection] != friendEmail
        flagNewConnect = true;
      }
    } else {
      // user belum pernah chat dengan seseorang
      flagNewConnect = true;
    }

    // TODO : Fix

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

        final listChats = await userCollection
            .doc(googleUser.email)
            .collection("chats")
            .get();

        if (listChats.docs.isNotEmpty) {
          List<Chat> dataListChats = List<Chat>.empty();
          for (var e in listChats.docs) {
            final dataDocChat = e.data();
            final dataDocChatId = e.id;
            dataListChats.add(Chat(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: chatsData["lastTime"],
                totalUnread: dataDocChat["totalUnread"]));
          }
          users.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          users.update((user) {
            user!.chats = [];
          });
        }
        await userCollection.doc(googleUser.email).update({"chats": docChats});

        users.update((user) {
          user!.chats = docChats as List<Chat>;
        });

        chat_id = chatDataId;
        users.refresh();
      } else {
        final newChat = await chats.add({
          "connection": [googleUser.email, friendEmail],
          "chat": [],
        });

        await userCollection
            .doc(googleUser.email)
            .collection("chats")
            .doc(newChat.id)
            .set({
          "connection": friendEmail,
          "lastTime": date,
          "totalUnread": 0
        });

        final listChats = await userCollection
            .doc(googleUser.email)
            .collection("chats")
            .get();

        if (listChats.docs.isNotEmpty) {
          List<Chat> dataListChats = List<Chat>.empty();
          for (var e in listChats.docs) {
            final dataDocChat = e.data();
            final dataDocChatId = e.id;
            dataListChats.add(Chat(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: dataDocChat["lastTime"],
                totalUnread: dataDocChat["totalUnread"]));
          }
          users.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          users.update((user) {
            user!.chats = [];
          });
        }

        chat_id = newChat.id;
        users.refresh();
      }
    }
    Get.toNamed(Routes.CHAT_ROOM, arguments: chat_id);
  }
}
