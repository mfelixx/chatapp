import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchChatController extends GetxController {
  late TextEditingController searchController;
  var isSearch = false.obs;
  var initialQuery = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchFriend(String data, String email) async {
    if (data.isEmpty) {
      initialQuery.value = [];
      tempSearch.value = [];
    } else {
      var capitalized = data.substring(0, 1).toUpperCase() + data.substring(1);
      print(capitalized);

      if (initialQuery.isEmpty && data.isNotEmpty) {
        CollectionReference collectionUsers = firestore.collection('users');
        final query = await collectionUsers
            .where('keyName', isEqualTo: data.substring(0, 1).toUpperCase())
            .where('email', isNotEqualTo: email)
            .get();

        if (query.docs.isNotEmpty) {
          for (var i = 0; i < query.docs.length; i++) {
            initialQuery.add(query.docs[i].data() as Map<String, dynamic>);
          }
          print("Query result ${initialQuery}");
        } else {
          print("No query result");
        }
      }

      if (initialQuery.isNotEmpty) {
        tempSearch.value = [];
        for (var e in initialQuery) {
          if (e["displayName"].toLowerCase().contains(data.toLowerCase()) ||
              e['keyName'].contains(capitalized)) {
            tempSearch.add(e);
          }
        }
      }
    }
    print("Temp search ${tempSearch}");
    initialQuery.refresh();
    tempSearch.refresh();
  }

  @override
  void onInit() {
    searchController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
