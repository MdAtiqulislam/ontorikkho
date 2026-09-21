import '../../../../utils/enums.dart';
import 'button_config_model.dart';

class FriendButtonConfigFactory {
  static ButtonConfigModel build({
    required FriendRequestStatus? status,

    /// 🔥 NEW FLAG
    bool showRemoveForCanceled = false,
  }) {
    switch (status) {
      case FriendRequestStatus.friend:
        return ButtonConfigModel(
          primaryText: "Friends",
          primaryActionType: FriendActionType.openMenu,
          extraActions: [
            ActionButtonConfig(
              text: "Remove friend",
              action: FriendActionType.remove,
            ),
            ActionButtonConfig(
              text: "Block",
              action: FriendActionType.block,
            ),
          ],
        );

      case FriendRequestStatus.sent:
        return ButtonConfigModel(
          secondaryText: "Cancel request",
          secondaryActionType: FriendActionType.cancel,
        );

      case FriendRequestStatus.received:
        return ButtonConfigModel(
          primaryText: "Confirm",
          primaryActionType: FriendActionType.confirm,
          secondaryText: "Delete",
          secondaryActionType: FriendActionType.delete,
        );

      case FriendRequestStatus.blocked:
        return ButtonConfigModel(
          secondaryText: "Unblock",
          secondaryActionType: FriendActionType.unblock,
        );

      case FriendRequestStatus.canceled:
      default:
        return ButtonConfigModel(
          primaryText: "Add friend",
          primaryActionType: FriendActionType.add,

          /// 🔥 conditional remove
          secondaryText:
          showRemoveForCanceled ? "Remove" : null,
          secondaryActionType:
          showRemoveForCanceled ? FriendActionType.remove : null,
        );
    }
  }
}