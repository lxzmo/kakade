///阿里云SDK返回回调Enum
///具体错误在碰到之后查阅 https://help.aliyun.com/document_detail/2252093.html?spm=a2c4g.2252101.0.0.df2e7b8cK0m5uG
enum AuthResultCode {
  /// 场景相关
  // 场景不存在
  alicomFusionTemplateNotExist('100001', '场景不存在'),
  // 场景还未开始
  alicomFusionTemplateNotStart('100002', '场景还未开始'),
  // 上一个场景还未退出
  alicomFusionTemplateNotEnd('100003', '上一个场景还未退出'),
  // 场景结束
  alicomFusionTemplateEnd('100004', '场景结束'),
  // 场景成功结束
  alicomFusionTemplateEndSuccess('110005', '场景成功结束'),

  /// 节点流程事件
  // 查找下一个节点失败
  alicomFusionAuthNextNodeFail('200001', '查找下一个节点失败'),
  // 查找下一个节点成功
  alicomFusionAuthNextNodeSuccess('200002', '查找下一个节点成功'),
  // 当前节点任务还未结束，不允许继续操作
  alicomFusionAuthCurrentNodeNotComplete('200003', '当前节点任务还未结束，不允许继续操作'),

  /// token相关
  // token正在鉴权
  alicomFusionTokenIsVerifying('300001', 'token正在鉴权'),
  // token鉴权合法
  alicomFusionTokenValid('300002', 'token鉴权合法'),
  // token鉴权不合法
  alicomFusionTokenInvalid('300003', 'token鉴权不合法'),
  // token获取超时，默认60s
  alicomFusionTokenUpdateTimeout('300004', 'token获取超时'),
  // token解析失败
  alicomFusionTokenAnalyseFail('300005', 'token解析失败'),
  // token鉴权失败
  alicomFusionTokenVerifyFail('300006', 'token鉴权失败'),

  /// 一键登录相关
  // 一键登录初始化成功
  alicomFusionNumberAuthInitSuccess('400001', '一键登录初始化成功'),
  // 一键登录初始化失败
  alicomFusionNumberAuthInitFail('400002', '一键登录初始化失败'),
  // 一键登录弹起授权页成功
  alicomFusionNumberAuthPresentSuccess('400003', '一键登录弹起授权页成功'),
  // 一键登录弹起授权页失败
  alicomFusionNumberAuthPresentFail('400004', '一键登录弹起授权页失败'),
  // 一键登录弹起授权页取消
  alicomFusionNumberAuthDisMiss('400005', '一键登录弹起授权页取消'),
  // 一键登录获取token成功
  alicomFusionNumberAuthGetTokenSuccess('400006', '一键登录获取token成功'),
  // 一键登录获取token失败
  alicomFusionNumberAuthGetTokenFail('400007', '一键登录获取token失败'),
  // 一键登录获取页面各种点击事件
  alicomFusionNumberAuthGetTokenEvent('410008', '一键登录获取页面各种点击事件'),
  // 一键登录获取页面其他手机号登录按钮点击事件
  alicomFusionNumberAuthOtherPhoneLoginClickEvent(
      '410009', '一键登录获取页面其他手机号登录按钮点击事件'),
  // 一键登录点击返回按钮
  alicomFusionNumberAuthBackBtnClickEvent('410010', '一键登录点击返回按钮'),
  // 一键登录授权页点击协议
  alicomFusionNumberAuthProtocolClickEvent('410011', '一键登录授权页点击协议'),
  // 一键登录录授权页二次弹窗点击协议
  alicomFusionNumberAuthAlertProtocolClickEvent('410012', '一键登录录授权页二次弹窗点击协议'),

  /// 一键登录内部错误码，请注意1600011及1600012错误内均含有运营商返回码
  /// 具体错误在碰到之后查阅 https://help.aliyun.com/document_detail/85351.html?spm=a2c4g.11186623.6.561.32a7360cxvWk6H
  // 接口成功
  alicomFusionNumberAuthInnerCodeSuccess('1600000', '接口成功'),
  // 获取运营商配置信息失败
  alicomFusionNumberAuthInnerCodeGetOperatorInfoFailed(
      '1600004', '获取运营商配置信息失败'),
  // 未检测到sim卡
  alicomFusionNumberAuthInnerCodeNoSIMCard('1600007', '未检测到sim卡'),
  // 蜂窝网络未开启或不稳定
  alicomFusionNumberAuthInnerCodeNoCellularNetwork('1600008', '蜂窝网络未开启或不稳定'),
  // 无法判运营商
  alicomFusionNumberAuthInnerCodeUnknownOperator('1600009', '无法判运营商'),
  // 未知异常
  alicomFusionNumberAuthInnerCodeUnknownError('1600010', '未知异常'),
  // 获取token失败
  alicomFusionNumberAuthInnerCodeGetTokenFailed('1600011', '获取token失败'),
  // 预取号失败
  alicomFusionNumberAuthInnerCodeGetMaskPhoneFailed('1600012', '预取号失败'),
  // 运营商维护升级，该功能不可用
  alicomFusionNumberAuthInnerCodeInterfaceDemoted('1600013', '运营商维护升级，该功能不可用'),
  // 运营商维护升级，该功能已达最大调用次数
  alicomFusionNumberAuthInnerCodeInterfaceLimited(
      '1600014', '运营商维护升级，该功能已达最大调用次数'),
  // 接口超时
  alicomFusionNumberAuthInnerCodeInterfaceTimeout('1600015', '接口超时'),
  // AppID、Appkey解析失败
  alicomFusionNumberAuthInnerCodeDecodeAppInfoFailed(
      '1600017', 'AppID、Appkey解析失败'),
  // 运营商已切换
  alicomFusionNumberAuthInnerCodeCarrierChanged('1600021', '运营商已切换'),
  // 终端环境检测失败（终端不支持认证 / 终端检测参数错误）
  alicomFusionNumberAuthInnerCodeEnvCheckFail('1600025', '终端环境检测失败');

  factory AuthResultCode.fromCode(String resultCode) {
    return values.firstWhere(
      (element) => element.code == resultCode,
      orElse: () => AuthResultCode.alicomFusionNumberAuthInnerCodeUnknownError,
    );
  }

  const AuthResultCode(this.code, this.message);

  final String code;
  final String message;
}
