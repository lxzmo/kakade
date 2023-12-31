class AuthResponseModel {
  String? templateId;
  String? nodeId;
  String? resultCode;
  String? resultMsg;
  String? innerMsg;
  String? innerCode;
  String? carrierFailedResultData;
  String? innerRequestId;
  String? requestId;
  String? maskToken;

  AuthResponseModel(
      {this.templateId,
      this.nodeId,
      this.resultCode,
      this.resultMsg,
      this.innerMsg,
      this.innerCode,
      this.carrierFailedResultData,
      this.innerRequestId,
      this.requestId,
      this.maskToken});

  AuthResponseModel.fromJson(Map<String, dynamic> json) {
    templateId = json['templateId'];
    nodeId = json['nodeId'];
    resultCode = json['resultCode'];
    resultMsg = json['resultMsg'];
    innerMsg = json['innerMsg'];
    innerCode = json['innerCode'];
    carrierFailedResultData = json['carrierFailedResultData'];
    innerRequestId = json['innerRequestId'];
    requestId = json['requestId'];
    maskToken = json['maskToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['templateId'] = templateId;
    data['nodeId'] = nodeId;
    data['resultCode'] = resultCode;
    data['resultMsg'] = resultMsg;
    data['innerMsg'] = innerMsg;
    data['innerCode'] = innerCode;
    data['carrierFailedResultData'] = carrierFailedResultData;
    data['innerRequestId'] = innerRequestId;
    data['requestId'] = requestId;
    data['maskToken'] = maskToken;
    return data;
  }
}
