import 'auth_ui_config.dart';

class AuthConfig {
  final String currentTemplatedId;
  final String tokenStr;
  final String iosSchemeCode;
  final String androidSchemeCode;
  final bool? enableLog;
  final AuthUIConfig? authUIConfig;

  AuthConfig({
    required this.currentTemplatedId,
    required this.tokenStr,
    required this.iosSchemeCode,
    required this.androidSchemeCode,
    this.enableLog,
    this.authUIConfig,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentTemplatedId': currentTemplatedId,
      'tokenStr': tokenStr,
      'iosSchemeCode': iosSchemeCode,
      'androidSchemeCode': androidSchemeCode,
      'enableLog': enableLog ?? false,
      'authUIConfig': authUIConfig?.toJson(),
    }..removeWhere((key, value) => value == null);
  }

  @override
  String toString() {
    return 'AuthConfig${toJson()}';
  }
}
