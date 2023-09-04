package com.example.kakade;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;

import com.alicom.fusion.auth.AlicomFusionAuthCallBack;
import com.alicom.fusion.auth.AlicomFusionBusiness;
import com.alicom.fusion.auth.AlicomFusionConstant;
import com.alicom.fusion.auth.HalfWayVerifyResult;
import com.alicom.fusion.auth.error.AlicomFusionEvent;
import com.alicom.fusion.auth.token.AlicomFusionAuthToken;
import com.alicom.fusion.auth.AlicomFusionLog;

import androidx.annotation.NonNull;

import com.example.kakade.model.AuthModel;
import com.example.kakade.model.AuthResponseModel;
import com.example.kakade.model.AuthUIModel;
import com.example.kakade.utils.Constant;
import com.example.kakade.mask.DecoyMaskActivity;
import com.example.kakade.R;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import java.lang.ref.WeakReference;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class AuthClient {
    private static final String TAG = AuthClient.class.getSimpleName();
    public static final String CALLBACK_EVENT = "onSdkCallbackEvent";
    public static WeakReference<Activity> mActivity;

    public AlicomFusionBusiness mAlicomFusionBusiness;
    private AlicomFusionAuthCallBack mAlicomFusionAuthCallBack;
    private volatile String currentTemplatedId = "100001";

    private AuthModel authModel;

    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    // 超时，默认5000，单位毫秒
    private int mLoginTimeout = 5000;

    private static volatile AuthClient instance;

    private  MethodChannel mChannel;

    private AuthClient() {

    }

    public static Activity decoyMaskActivity;

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

    // 初始化SDK
    public void initSdk(Object arguments, @NonNull MethodChannel.Result result) { 
        try {
            Gson gson = new Gson();
            String jsonBean = gson.toJson(arguments);
            authModel = gson.fromJson(jsonBean, AuthModel.class);
            AuthUIModel authUIModel = gson.fromJson(jsonBean, AuthUIModel.class);
            authModel.setAuthUIModel(authUIModel);
            Log.d(TAG, "initSdk: " + jsonBean);
        } catch (Exception e) {
            Log.e(TAG, "解析AuthModel遇到错误：" + e);
            result.error("100000", "初始化失败: " + e.getMessage(), e.getStackTrace());
            return;
        }
        if (Objects.isNull(authModel) ||
                Objects.isNull(authModel.getTokenStr()) ||
                TextUtils.isEmpty(authModel.getTokenStr())) {
            result.error("100000", "初始化失败,token为空", null);
            return;
        }
        boolean logEnable = authModel.getEnableLog();
        String token = authModel.getTokenStr();
        String schemeCode = authModel.getAndroidSchemeCode();
        mAlicomFusionBusiness = new AlicomFusionBusiness();
        AlicomFusionLog.setLogEnable(logEnable);
        AlicomFusionAuthToken authToken=new AlicomFusionAuthToken();
        Activity activity = mActivity.get();
        Context context = activity.getBaseContext();
        authToken.setAuthToken(token);
        mAlicomFusionBusiness.initWithToken(context, schemeCode,authToken);
        mAlicomFusionAuthCallBack = new AlicomFusionAuthCallBack() {
            @Override
            public AlicomFusionAuthToken onSDKTokenUpdate() {
                Log.d(TAG, "AlicomFusionAuthCallBack---onSDKTokenUpdate");
                AlicomFusionAuthToken token=new AlicomFusionAuthToken();
                return token;
            }

            @Override
            public void onSDKTokenAuthSuccess() {
                Log.d(TAG, "AlicomFusionAuthCallBack---onSDKTokenAuthSuccess");
                AuthResponseModel responseModel = AuthResponseModel.customModel(AlicomFusionConstant.ALICOMFUSION_TOKENVERIFYSUCC,"token鉴权合法");
                mActivity.get().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mChannel.invokeMethod(CALLBACK_EVENT, responseModel.toJson());
                    }
                });
            }

            @Override
            public void onSDKTokenAuthFailure(AlicomFusionAuthToken token1, AlicomFusionEvent alicomFusionEvent) {
                Log.d(TAG, "AlicomFusionAuthCallBack---onSDKTokenAuthFailure " +alicomFusionEvent.getErrorCode());
                AuthResponseModel responseModel = AuthResponseModel.customModel("300006","token鉴权失败");
                mActivity.get().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mChannel.invokeMethod(CALLBACK_EVENT, responseModel.toJson());
                    }
                });
            }

            @Override
            public void onVerifySuccess(String token, String s1,AlicomFusionEvent alicomFusionEvent) {
                Log.d(TAG, "AlicomFusionAuthCallBack---onVerifySuccess  "+token);
                AuthResponseModel responseModel = AuthResponseModel.customModel("400006","一键登录获取token成功",token);
                mActivity.get().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mChannel.invokeMethod(CALLBACK_EVENT, responseModel.toJson());
                    }
                });
            }

            @Override
            public void onHalfWayVerifySuccess(String nodeName, String maskToken,AlicomFusionEvent alicomFusionEvent, HalfWayVerifyResult halfWayVerifyResult) {
                Log.d(TAG, "AlicomFusionAuthCallBack---onHalfWayVerifySuccess  "+maskToken);
            }

            @Override
            public void onVerifyFailed(AlicomFusionEvent alicomFusionEvent, String s) {
                Log.d(TAG, "AlicomFusionAuthCallBack---onVerifyFailed "+alicomFusionEvent.getErrorCode()+"   "+alicomFusionEvent.getErrorMsg());
                mAlicomFusionBusiness.continueSceneWithTemplateId(currentTemplatedId,false);
            }

            @Override
            public void onTemplateFinish(AlicomFusionEvent alicomFusionEvent) {
                Log.d(TAG, "AlicomFusionAuthCallBack---onTemplateFinish  "+alicomFusionEvent.getErrorCode());
                mAlicomFusionBusiness.stopSceneWithTemplateId(currentTemplatedId);
                mAlicomFusionBusiness.destory();
                if (decoyMaskActivity != null) {
                    decoyMaskActivity.finish();
                }
            }

            @Override
            public void onAuthEvent(AlicomFusionEvent alicomFusionEvent) {
                Log.d(TAG, "AlicomFusionAuthCallBack---onAuthEvent"+alicomFusionEvent.getErrorCode()+"   "+alicomFusionEvent.getErrorMsg());
            }


            @Override
            public String onGetPhoneNumberForVerification(String s,AlicomFusionEvent alicomFusionEvent) {
                Log.d(TAG, "AlicomFusionAuthCallBack---onGetPhoneNumberForVerification");
                return "111";
            }

            @Override
            public void onVerifyInterrupt(AlicomFusionEvent alicomFusionEvent) {
                Log.d(TAG, "AlicomFusionAuthCallBack---onVerifyInterrupt"+alicomFusionEvent.toString());
            }
        };
        mAlicomFusionBusiness.setAlicomFusionAuthCallBack(mAlicomFusionAuthCallBack);
    }


    // 登录注册场景
    public void loginRegister(@NonNull MethodChannel.Result result) {
        Activity activity = mActivity.get();
        if (activity == null) {
            result.error("10000", "当前无法获取Flutter Activity,请重启再试", null);
            return;
        }
        Context context = activity.getBaseContext();
        Intent intent = new Intent(context, DecoyMaskActivity.class);
        activity.startActivity(intent);
    }
    
    // 结束登录注册
    public void stopLoginRegisterScene() {
        mAlicomFusionBusiness.continueSceneWithTemplateId(currentTemplatedId,true);
    }

    public AuthModel getAuthModel() {
        return authModel;
    }

    public void setFlutterPluginBinding(FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    public void setActivity(WeakReference<Activity> activity) {
        this.mActivity = activity;
    }

    public void setLoginTimeout(int timeout) {
        this.mLoginTimeout = timeout * 1000;
    }

    public Integer getLoginTimeout() {
        return mLoginTimeout;
    }

    public MethodChannel getChannel() {
        return mChannel;
    }

    public void setChannel(MethodChannel mChannel) {
        this.mChannel = mChannel;
    }
}