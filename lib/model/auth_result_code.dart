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

  /// 一键登录内部错误码，请注意1600011及1600012错误内均含有运营商返回码
  /// 具体错误在碰到之后查阅 https://help.aliyun.com/document_detail/85351.html?spm=a2c4g.11186623.6.561.32a7360cxvWk6H
  // 接口成功
  alicomFusionNumberAuthInnerCodeSuccess('1600000', '接口成功'),
  // 未知异常
  alicomFusionNumberAuthInnerCodeUnknownError('1600010', '未知异常');

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
