class AppConfigModel {
  final String current;
  final String androidVersion;
  final String androidTestVersion;
  final String iosVersion;
  final String iosTestVersion;
  final bool enable;
  final MajorMessage majorMsg;
  final MinorMessage minorMsg;

  AppConfigModel({
    required this.current,
    required this.androidVersion,
    required this.androidTestVersion,
    required this.iosVersion,
    required this.iosTestVersion,
    required this.enable,
    required this.majorMsg,
    required this.minorMsg,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      current: json['current'],
      androidVersion: json['android_version'],
      androidTestVersion: json['android_test_version'],
      iosVersion: json['ios_version'],
      iosTestVersion: json['ios_test_version'],
      enable: json['enable'],
      majorMsg: MajorMessage.fromJson(json['majorMsg']),
      minorMsg: MinorMessage.fromJson(json['minorMsg']),
    );
  }
}

class MajorMessage {
  final String title;
  final String msg;
  final String button;
  final Map<String, dynamic>? url;

  MajorMessage({required this.title, required this.msg, required this.button, this.url});

  factory MajorMessage.fromJson(Map<String, dynamic> json) {
    return MajorMessage(
      title: json['title'],
      msg: json['msg'],
      button: json['button'],
      url: json['url'],
    );
  }
}

class MinorMessage {
  final String title;
  final String msg;
  final String button;

  MinorMessage({required this.title, required this.msg, required this.button});

  factory MinorMessage.fromJson(Map<String, dynamic> json) {
    return MinorMessage(
      title: json['title'],
      msg: json['msg'],
      button: json['button'],
    );
  }
}
