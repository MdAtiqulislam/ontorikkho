import 'package:get/get.dart';
import '../app/modules/friends/models/single_friend_model.dart';

class FriendStore extends GetxController {
  static FriendStore get to => Get.find();

  /// All friends (id based)
  final friendsMap = <int, SingleFriendModel>{}.obs;

  /// Lists
  final suggestions = <SingleFriendModel>[].obs;
  final incoming = <SingleFriendModel>[].obs;
  final sent = <SingleFriendModel>[].obs;
  final myFriends = <SingleFriendModel>[].obs;

  /// ================= SETTERS =================

  void setSuggestions(List<SingleFriendModel> list) {
    suggestions.assignAll(list);
    _syncMap(list);
  }

  void setIncoming(List<SingleFriendModel> list) {
    incoming.assignAll(list);
    _syncMap(list);
  }

  void setSent(List<SingleFriendModel> list) {
    sent.assignAll(list);
    _syncMap(list);
  }

  void setMyFriends(List<SingleFriendModel> list) {
    myFriends.assignAll(list);
    _syncMap(list);
  }

  void _syncMap(List<SingleFriendModel> list) {
    for (var f in list) {
      if (f.user?.id != null) {
        friendsMap[f.user!.id!] = f;
      }
    }
  }

  /// ================= UPDATE STATUS =================

  void updateStatus(int userId, String status) {
    /// 🔥 update map
    if (friendsMap.containsKey(userId)) {
      final existing = friendsMap[userId]!;

      final updated = existing.copyWith(
        user: existing.user?.copyWith(
          friendshipStatus: status,
        ),
      );

      friendsMap[userId] = updated;
    }

    /// 🔥 update all lists
    _updateList(suggestions, userId, status);
    _updateList(incoming, userId, status);
    _updateList(sent, userId, status);
    _updateList(myFriends, userId, status);
  }

  void _updateList(
      RxList<SingleFriendModel> list,
      int userId,
      String status,
      ) {
    final index = list.indexWhere((e) => e.user?.id == userId);

    if (index != -1) {
      final existing = list[index];

      final updated = existing.copyWith(
        user: existing.user?.copyWith(
          friendshipStatus: status,
        ),
      );

      list[index] = updated;
      list.refresh();
    }
  }

  /// ================= REMOVE =================

  void removeSuggestion(int userId) {
    suggestions.removeWhere((e) => e.user?.id == userId);
  }

  /// ================= GETTERS =================

  String? getStatus(int userId) {
    return friendsMap[userId]?.user?.friendshipStatus;
  }

  SingleFriendModel? getFriend(int userId) {
    return friendsMap[userId];
  }

  Future<void> clearAll() async {
    suggestions.clear();
    incoming.clear();
    sent.clear();
    myFriends.clear();
    friendsMap.clear();
  }

}