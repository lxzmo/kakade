class AuthUIConfig {
  final String? navTitle;
  final String? navColor;
  final bool? hideNavBackItem;
  final String? navBackImage;

  final String? sloganText;

  final String? backgroundColor;

  final bool? changeBtnIsHidden;

  const AuthUIConfig(
      {this.navTitle,
      this.navColor,
      this.hideNavBackItem,
      this.navBackImage,
      this.sloganText,
      this.backgroundColor,
      this.changeBtnIsHidden});

  Map<String, dynamic> toJson() {
    return {
      'navTitle': navTitle,
      'navColor': navColor,
      'hideNavBackItem': hideNavBackItem,
      'navBackImage': navBackImage,
      'sloganText': sloganText,
      'backgroundColor': backgroundColor,
      'changeBtnIsHidden': changeBtnIsHidden
    }..removeWhere((key, value) => value == null);
  }

  @override
  String toString() {
    return 'AuthUIConfig${toJson()}';
  }
}
