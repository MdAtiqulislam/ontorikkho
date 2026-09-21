import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';
import 'package:ontorikkho/utils/util.dart';
import 'package:permission_handler/permission_handler.dart';

class InviteFriendsController extends GetxController {
  RxList<ContactInfo> contacts = <ContactInfo>[].obs;
  RxBool isLoading = false.obs;
  RxBool sendingInvitation = false.obs;

  RxMap<String, List<ContactInfo>> groupedContacts =
      <String, List<ContactInfo>>{}.obs;

  TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    isLoading.value = true;
    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      final list = await FlutterContactsService.getContacts();
      contacts.value = list;
      _groupContacts();
    } else {
      Get.snackbar(
        "Permission Required",
        "Please allow contact access to invite friends.",
      );
    }
    isLoading.value = false;
  }

  void _groupContacts() {
    final Map<String, List<ContactInfo>> map = {};
    for (var contact in contacts) {
      final name = contact.displayName ?? "";
      final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : "#";
      if (!map.containsKey(firstLetter)) {
        map[firstLetter] = [];
      }
      map[firstLetter]!.add(contact);
    }
    groupedContacts.value = map;
  }

  void search(String query) {
    if (query.isEmpty) {
      _groupContacts();
    } else {
      final filtered =
          contacts
              .where(
                (c) =>
                    (c.displayName?.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ??
                        false),
              )
              .toList();
      final Map<String, List<ContactInfo>> map = {};
      for (var contact in filtered) {
        final name = contact.displayName ?? "";
        final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : "#";
        if (!map.containsKey(firstLetter)) {
          map[firstLetter] = [];
        }
        map[firstLetter]!.add(contact);
      }
      groupedContacts.value = map;
    }
  }

  void initMessage({required ContactInfo contact}) {
    String message =
        "Hello ${contact.displayName},"
        "\nI'm inviting you to join the Ontorikkho app — a place "
        "to stay connected, explore communities,"
        " and enjoy exciting new features."
        "\nI’d love to see you there!";
    messageController.text = message;
  }

  void invite(String phone) async {
    sendingInvitation.value = true;
    var endpoint = APIEndPoints.inviteFriend;
    var body = {"mobile": sanitizePhone(phone), "messages": messageController.text};
    try {
      var res = await RemoteServices.postRequest(
        endpoint: endpoint,
        body: body,
      );
      if (res != null) {
        Get.back();
        CustomSnackBar(isSuccess: true, msg: res["msg"]).showSnackBar();
      } else {
        CustomSnackBar(
          isSuccess: false,
          msg: APIEndPoints.httpErrorMSG.value,
        ).showSnackBar();
      }
    } finally {
      sendingInvitation.value = false;
    }
  }
}
