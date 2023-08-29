package com.example.kakade;

import android.util.Log;

import com.alicom.fusion.auth.AlicomFusionBusiness;

import androidx.annotation.NonNull;

import com.example.kakade.model.AuthModel;
import com.example.kakade.model.AuthResponseModel;
import com.example.kakade.model.AuthUIModel;
import com.example.kakade.utils.Constant;
import com.google.gson.Gson;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class AuthClient {
    private static final String TAG = AuthClient.class.getSimpleName();

    public static final String CALLBACK_EVENT = "onSdkCallbackEvent";

    private AlicomFusionBusiness mAlicomFusionBusiness;

    private AuthModel authModel;

    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    private static volatile AuthClient instance;

    private MethodChannel mChannel;

    public static AuthClient getInstance() {
        if (instance == null) {
            synchronized (AuthClient.class) {
                if (instance == null) {
                    instance = new AuthClient();
                }
            }
        }
        return instance;
    }

    public void initSdk(Object arguments, @NonNull MethodChannel.Result result) { 
        // Log.d(TAG, "initSdk: 1111");
        // try {
        //     Gson gson = new Gson();
        //     String jsonBean = gson.toJson(arguments);
        //     authModel = gson.fromJson(jsonBean, AuthModel.class);
        //     AuthUIModel authUIModel = gson.fromJson(jsonBean, AuthUIModel.class);
        //     authModel.setAuthUIModel(authUIModel);
        //     Log.d(TAG, "initSdk: " + jsonBean);
        // } catch (Exception e) {
        //     Log.e(TAG, "解析AuthModel遇到错误：" + e);
        //     // result.error(ResultCode.CODE_ERROR_INVALID_PARAM, errorArgumentsMsg + ": " + e.getMessage(), e.getStackTrace());
        //     return;
        // }
        // if (Objects.isNull(authModel) ||
        //         Objects.isNull(authModel.getTokenStr()) ||
        //         TextUtils.isEmpty(authModel.getTokenStr())) {
        //     AuthResponseModel authResponseModel = AuthResponseModel.nullSdkError();
        //     result.error(authResponseModel.getResultCode(), authResponseModel.getMsg(), null);
        //     return;
        // }

    }

    public void setFlutterPluginBinding(FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    public MethodChannel getChannel() {
        return mChannel;
    }

    public void setChannel(MethodChannel mChannel) {
        this.mChannel = mChannel;
    }
}