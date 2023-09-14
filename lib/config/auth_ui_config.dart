class AuthUIConfig {
  final String? nameLabelText;

  // 登录
  final String? loginBtnText;

  // 背景
  final String? backgroundColor;

  // logo
  final String? logoImage;
  final int? logoWidth;
  final int? logoHeight;
  final bool? logoIsHidden;

  // 切换到其他方式
  final bool? changeBtnIsHidden;
  final String? changeBtnTitle;

  // 协议
  final String? checkedImage;
  final String? uncheckImage;

  // 自定义控件
  final List<CustomViewBlock>? customViewBlockList;

  const AuthUIConfig({
    this.nameLabelText,
    this.loginBtnText,
    this.backgroundColor,
    this.logoImage,
    this.logoWidth,
    this.logoHeight,
    this.logoIsHidden,
    this.changeBtnIsHidden,
    this.changeBtnTitle,
    this.checkedImage,
    this.uncheckImage,
    this.customViewBlockList,
  });

  Map<String, dynamic> toJson() {
    return {
      'nameLabelText': nameLabelText,
      'loginBtnText': loginBtnText,
      'backgroundColor': backgroundColor,
      'logoImage': logoImage,
      'logoWidth': logoWidth,
      'logoHeight': logoHeight,
      'logoIsHidden': logoIsHidden,
      'changeBtnIsHidden': changeBtnIsHidden,
      'changeBtnTitle': changeBtnTitle,
      'checkedImage': checkedImage,
      'uncheckImage': uncheckImage,
      'customViewBlockList':
          customViewBlockList?.map((e) => e.toJson()).toList(growable: false),
    }..removeWhere((key, value) => value == null);
  }

  @override
  String toString() {
    return 'AuthUIConfig${toJson()}';
  }
}

// 自定义控件添加
class CustomViewBlock {
  const CustomViewBlock({
    required this.viewId,
    required this.offsetX,
    required this.offsetY,
    required this.width,
    required this.height,
    required this.enableTap,
    this.text,
    this.textColor,
    this.textSize,
    this.backgroundColor,
    this.image,
  });

  // 用于回调时候判断返回的 id 判断
  final int viewId;
  final String? text;
  final String? textColor;
  final double? textSize;
  final String? backgroundColor;
  final String? image;
  final double offsetX;
  final double offsetY;
  final double width;
  final double height;
  final bool enableTap;

  Map<String, dynamic> toJson() {
    return {
      'viewId': viewId,
      'text': text,
      'textColor': textColor,
      'textSize': textSize,
      'backgroundColor': backgroundColor,
      'image': image,
      'offsetX': offsetX,
      'offsetY': offsetY,
      'width': width,
      'height': height,
      'enableTap': enableTap,
    }..removeWhere((key, value) => value == null);
  }

  @override
  String toString() {
    return 'CustomViewBlock${toJson()}';
  }
}
