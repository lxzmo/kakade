package com.example.kakade.model;


import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.Nullable;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.mobile.auth.gatewayauth.ResultCode;
import com.mobile.auth.gatewayauth.model.TokenRet;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class AuthResponseModel {
    private String templateId;
    private String nodeId;
    private String resultCode;
    private String resultMsg;
    private String innerCode;
    private String innerMsg;
    private String carrierFailedResultData;
    private String innerRequestId;
    private String requestId;
    private String maskToken;

    public static AuthResponseModel customModel(String resultCode, String resultMsg) {
        return customModel(resultCode, resultMsg, null); 
    }

    public static AuthResponseModel customModel(String resultCode, String resultMsg, String maskToken) {
        AuthResponseModel authResponseModel = new AuthResponseModel();
        authResponseModel.setResultCode(resultCode);
        authResponseModel.setResultMsg(resultMsg);
        authResponseModel.setMaskToken(maskToken);
        return authResponseModel;
    }

    public void setTemplateId(String templateId) {
        this.templateId = templateId;
    }

    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }

    public void setResultCode(String resultCode) {
        this.resultCode = resultCode;
    }

    public void setResultMsg(String resultMsg) {
        this.resultMsg = resultMsg;
    }

    public void setInnerCode(String innerCode) {
        this.innerCode = innerCode;
    }

    public void setInnerMsg(String innerMsg) {
        this.innerMsg = innerMsg;
    }

    public void setCarrierFailedResultData(String carrierFailedResultData) {
        this.carrierFailedResultData = carrierFailedResultData;
    }

     public void setInnerRequestId(String innerRequestId) {
        this.innerRequestId = innerRequestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    public void setMaskToken(String maskToken) {
        this.maskToken = maskToken;
    }

    public String getTemplateId() {
        return templateId;
    }

    public String getNodeId() {
        return nodeId;
    }

    public String getResultCode() {
        return resultCode;
    }

    public String getResultMsg() {
        return resultMsg;
    }

    public String getInnerCode() {
        return innerCode;
    }

    public String getInnerMsg() {
        return innerMsg;
    }

    public String getCarrierFailedResultData() {
        return carrierFailedResultData;
    }

    public String getInnerRequestId() {
        return innerRequestId;
    }

    public String getRequestId() {
        return requestId;
    }

    public String getMaskToken() {
        return maskToken;
    }

    public Map<String, Object> toJson() {
        Map<String, Object> map = new HashMap<>();
        map.put("templateId", templateId);
        map.put("nodeId", nodeId);
        map.put("resultCode", resultCode);
        map.put("resultMsg", resultMsg);
        map.put("innerCode", innerCode);
        map.put("innerMsg", innerMsg);
        map.put("carrierFailedResultData", carrierFailedResultData);
        map.put("innerRequestId", innerRequestId);
        map.put("requestId", requestId);
        map.put("maskToken", maskToken);
        return map;
    }
}
