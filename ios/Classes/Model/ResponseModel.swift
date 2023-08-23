import AlicomFusionAuth
import Foundation

struct ResponseModel: Codable {
    var templateId: String?
    var nodeId: String?
    var resultCode: String?
    var resultMsg: String?
    var innerCode: String?
    var innerMsg: String?
    var carrierFailedResultData: String?
    var innerRequestId: String?
    var requestId: String?
    var extendData: String?
  
    init(_ data: [String: Any]) {
        self.templateId = data["templateId"] as? String
        self.nodeId = data["nodeId"] as? String
        self.resultCode = data["resultCode"] as? String
        self.resultMsg = data["resultMsg"] as? String
        self.innerCode = data["innerCode"] as? String
        self.innerMsg = data["innerMsg"] as? String
        self.carrierFailedResultData = data["carrierFailedResultData"] as? String
        self.innerRequestId = data["innerRequestId"] as? String
        self.requestId = data["requestId"] as? String
        self.extendData = data["extendData"] as? String
    }

    init(_ data: [AnyHashable: Any]?) {
        self.templateId = data?["templateId"] as? String
        self.nodeId = data?["nodeId"] as? String
        self.resultCode = data?["resultCode"] as? String
        self.resultMsg = data?["resultMsg"] as? String
        self.innerCode = data?["innerCode"] as? String
        self.innerMsg = data?["innerMsg"] as? String
        self.carrierFailedResultData = data?["carrierFailedResultData"] as? String
        self.innerRequestId = data?["innerRequestId"] as? String
        self.requestId = data?["requestId"] as? String
        self.extendData = data?["extendData"] as? String
    }

    init(id: String?, code: String?, msg: String) {
        self.requestId = id ?? Date().timeStamp
        self.resultCode = code ?? AlicomFusionNumberAuthInnerCodeSuccess
        self.resultMsg = msg
    }

    init(code: String?, msg: String) {
        self.requestId = Date().timeStamp
        self.resultCode = code ?? AlicomFusionNumberAuthInnerCodeSuccess
        self.resultMsg = msg
    }

    init(msg: String) {
        self.requestId = Date().timeStamp
        self.resultCode = "600000"
        self.resultMsg = msg
    }

    var json: [String: Any] {
        let jsonObject = try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))
        return jsonObject as? [String: Any] ?? [:]
    }
}

extension Date {
    var timeStamp: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return String(timeInterval).replacingOccurrences(of: ".", with: "")
    }
}

// import Foundation

// struct ResponseModel: Codable {
//   var templateId: String?
//   var nodeId: String?
//   var resultCode: String?
//   var resultMsg: String?
//   var innerCode: String?
//   var innerMsg: String?
//   var carrierFailedResultData: String?
//   var innerRequestId: String?
//   var requestId: String?
//   var extendData: String?

//   init(_ data: [String: Any]) {
//     self.templateId = data["templateId"] as? String
//     self.nodeId = data["nodeId"] as? String
//     self.resultCode = data["resultCode"] as? String
//     self.resultMsg = data["resultMsg"] as? String
//     self.innerCode = data["innerCode"] as? String
//     self.carrierFailedResultData = data["carrierFailedResultData"] as? String
//     self.innerRequestId = data["innerRequestId"] as? String
//     self.requestId = data["requestId"] as? String
//     self.extendData = data["extendData"] as? String
//   }

//   init(_ data: [AnyHashable: Any]?) {
//     self.templateId = data?["templateId"] as? String
//     self.nodeId = data?["nodeId"] as? String
//     self.resultCode = data?["resultCode"] as? String
//     self.resultMsg = data?["resultMsg"] as? String
//     self.innerCode = data?["innerCode"] as? String
//     self.carrierFailedResultData = data?["carrierFailedResultData"] as? String
//     self.innerRequestId = data?["innerRequestId"] as? String
//     self.requestId = data?["requestId"] as? String
//     self.extendData = data?["extendData"] as? String
//   }


//   var json: [String: Any] {
//     let jsonObject = try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))
//     return jsonObject as? [String: Any] ?? [:]
//   }
// }