import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/enums.dart';
import '../models/friend_basic_info_model.dart';

class CustomUserActionSheet extends StatelessWidget {
  final FriendsBasicInfoModel friend;
  final Function(FriendActionType action)? onAction;

  const CustomUserActionSheet({
    super.key,
    required this.friend,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Wrap(
        children: [

          /// Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          /// Header
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(friend.avatar ?? ""),
            ),
            title: Text(friend.name ?? ""),
            subtitle: Text(friend.address ?? ""),
          ),

          const Divider(),

         /* _item(
            icon: Icons.message_outlined,
            title: "Message ${friend.name}",
            onTap: () => _handle(context, FriendActionType.follow),
          ),

          _item(
            icon: Icons.visibility_off_outlined,
            title: "Unfollow ${friend.name}",
            subtitle: "Stop seeing posts but stay friends.",
            onTap: () => _handle(context, FriendActionType.unfollow),
          ),
*/
          _item(
            icon: Icons.block,
            title: "Block ${friend.name}",
            subtitle: "Hide your profile and prevent interaction.",
            onTap: () => _handle(context, FriendActionType.block),
          ),

          _item(
            icon: Icons.person_remove_outlined,
            title: "Unfriend ${friend.name}",
            subtitle: "You’ll no longer be connected as friends.",
            onTap: () => _handle(context, FriendActionType.unfriend),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      onTap: onTap,
    );
  }

  void _handle(BuildContext context, FriendActionType action) {
    Get.back(result: action); // 🔥 important
    onAction?.call(action);
  }
}