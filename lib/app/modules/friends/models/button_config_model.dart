/*
import 'package:flutter/material.dart';

import '../../../../utils/enums.dart';

class ButtonConfigModel {
  final String? primaryText;
  final VoidCallback? primaryAction;

  final String? secondaryText;
  final VoidCallback? secondaryAction;

  /// 🔥 extra dynamic buttons (future proof)
  final List<ActionButtonConfig>? extraActions;

  const ButtonConfigModel({
    this.primaryText,
    this.primaryAction,
    this.secondaryText,
    this.secondaryAction,
    this.extraActions,
  });
}

class ActionButtonConfig {
  final String text;
  final VoidCallback? onTap;
  final bool isPrimary;

  const ActionButtonConfig({
    required this.text,
    this.onTap,
    this.isPrimary = false,
  });
}
*/

import '../../../../utils/enums.dart';

/// ✅ Button configuration for a friend card
class ButtonConfigModel {
  final String? primaryText;
  final FriendActionType? primaryActionType;

  final String? secondaryText;
  final FriendActionType? secondaryActionType;

  /// 🔥 extra dynamic buttons (future proof)
  final List<ActionButtonConfig>? extraActions;

  const ButtonConfigModel({
    this.primaryText,
    this.primaryActionType,
    this.secondaryText,
    this.secondaryActionType,
    this.extraActions,
  });
}

/// Extra button config
class ActionButtonConfig {
  final String text;
  final FriendActionType action;
  final bool isPrimary;

  const ActionButtonConfig({
    required this.text,
    required this.action,
    this.isPrimary = false,
  });
}