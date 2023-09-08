package com.example.kakade.model;

public class AuthModel {
    private String currentTemplatedId;

    private String androidSchemeCode;

    private String tokenStr;

    private Boolean enableLog;

    private AuthUIModel authUIModel;

    public void setCurrentTemplatedId(String currentTemplatedId) {
        this.currentTemplatedId = currentTemplatedId;
    }

    public String getCurrentTemplatedId() {
        return currentTemplatedId;
    }

    public void setAndroidSchemeCode(String androidSchemeCode) {
        this.androidSchemeCode = androidSchemeCode;
    }

    public String getAndroidSchemeCode() {
        return androidSchemeCode;
    }

    public void setTokenStr(String tokenStr) {
        this.tokenStr = tokenStr;
    }

    public String getTokenStr() {
        return tokenStr;
    }

    public void setEnableLog(Boolean enableLog) {
        this.enableLog = enableLog;
    }

    public Boolean getEnableLog() {
        return enableLog;
    }

    public void setAuthUIModel(AuthUIModel authUIModel) {
        this.authUIModel = authUIModel;
    }

    public AuthUIModel getAuthUIModel() {
        return authUIModel;
    }
}
