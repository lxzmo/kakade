package com.example.kakade.model;

import android.content.Context;

public class AuthModel {
    private String androidSchemeCode;

    private String tokenStr;

    private Boolean enableLog;

    private AuthUIModel authUIModel;

    private Context mContext;

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

    public void setContext(Context context) {
        this.mContext = context;
    }
    
    public Context getContext() {
        return mContext;
    }
}
