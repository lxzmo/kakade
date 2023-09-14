package com.example.kakade;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;
import android.widget.RelativeLayout;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.widget.CheckBox;

import com.alicom.fusion.auth.AlicomFusionAuthCallBack;
import com.alicom.fusion.auth.AlicomFusionBusiness;
import com.alicom.fusion.auth.AlicomFusionConstant;
import com.alicom.fusion.auth.HalfWayVerifyResult;
import com.alicom.fusion.auth.error.AlicomFusionEvent;
import com.alicom.fusion.auth.token.AlicomFusionAuthToken;
import com.alicom.fusion.auth.AlicomFusionLog;
import com.alicom.fusion.auth.AlicomFusionAuthUICallBack;
import com.alicom.fusion.auth.numberauth.FusionNumberAuthModel;
import com.alicom.fusion.auth.smsauth.AlicomFusionInputView;
import com.alicom.fusion.auth.smsauth.AlicomFusionVerifyCodeView;
import com.alicom.fusion.auth.upsms.AlicomFusionUpSMSView;
import com.alicom.fusion.auth.numberauth.AlicomFusionSwitchLogin;
import com.alicom.fusion.auth.numberauth.OtherPhoneLoginCallBack;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig;
import com.mobile.auth.gatewayauth.CustomInterface;
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate;

import androidx.annotation.NonNull;

import com.example.kakade.model.AuthModel;
import com.example.kakade.model.AuthResponseModel;
import com.example.kakade.model.AuthUIModel;
import com.example.kakade.utils.Constant;
import com.example.kakade.mask.DecoyMaskActivity;
import com.example.kakade.utils.AppUtils;
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
        currentTemplatedId = authModel.getCurrentTemplatedId();
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
                        mChannel.invokeMethod("onSDKTokenAuthSuccess", responseModel.toJson());
                    }
                });
            }

            @Override
            public void onSDKTokenAuthFailure(AlicomFusionAuthToken token1, AlicomFusionEvent alicomFusionEvent) {
                Log.d(TAG, "AlicomFusionAuthCallBack---onSDKTokenAuthFailure " +alicomFusionEvent.getErrorCode());
                AuthResponseModel responseModel = AuthResponseModel.customModel(alicomFusionEvent.getErrorCode(),alicomFusionEvent.getErrorMsg());
                mActivity.get().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mChannel.invokeMethod("onSDKTokenAuthFailure", responseModel.toJson());
                    }
                });
            }

            @Override
            public void onVerifySuccess(String token, String s1,AlicomFusionEvent alicomFusionEvent) {
                Log.d(TAG, "AlicomFusionAuthCallBack---onVerifySuccess  "+token);
                AuthResponseModel responseModel = AuthResponseModel.customModel(alicomFusionEvent.getErrorCode(),alicomFusionEvent.getErrorMsg(),token);
                mActivity.get().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mChannel.invokeMethod("onVerifySuccess", responseModel.toJson());
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
                stopScene();
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
        result.success(true);
    }


    public AlicomFusionAuthUICallBack uiCallBack = new AlicomFusionAuthUICallBack() {
        @Override
        public void onPhoneNumberVerifyUICustomView(String templateId,String nodeId, FusionNumberAuthModel fusionNumberAuthModel) {
            AuthUIModel authUIModel = authModel.getAuthUIModel();
            fusionNumberAuthModel.getBuilder()
            .setNavHidden(false)
            .setLogoImgPath(authUIModel.getLogoImage())
            .setLogoWidth(authUIModel.getLogoWidth())
            .setLogoHeight(authUIModel.getLogoHeight())
            .setLogBtnText(authUIModel.getLoginBtnText())
            .setPrivacyConectTexts(new String[]{"&", "&", "&"} )
            .setVendorPrivacyPrefix("《")
            .setVendorPrivacySuffix("》")
            .setAppPrivacyOne("《隐私协议》","https://test.h5.app.tbmao.com/user")
            .setAppPrivacyTwo("","")
            .setPrivacyOneColor(Color.BLACK)
            .setPrivacyOperatorColor(Color.BLACK)
            .setCheckBoxWidth(14)
            .setCheckBoxHeight(14)
            .setPrivacyAlertBtnHeigth(45)
            .setPrivacyAlertHeight(250)
            .setPrivacyAlertBtnBackgroundImgPath("login_btn_bg")
            .setPrivacyAlertBtnTextSize(14)
            .setLogBtnBackgroundPath("login_btn_bg");
            fusionNumberAuthModel.removeAuthRegisterViewConfig();
            fusionNumberAuthModel.addAuthRegistViewConfig("number",new AuthRegisterViewConfig.Builder()
                    .setView(initNumberView())
                    .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_NUMBER)
                    .build());
        }

        @Override
        public void onSMSCodeVerifyUICustomView(String templateId,String s,boolean isAutoInput, AlicomFusionVerifyCodeView alicomFusionVerifyCodeView) {
            // mActivity.get().runOnUiThread(new Runnable() {
            //     @Override
            //     public void run() {
            //         AlicomFusionInputView inputView = alicomFusionVerifyCodeView.getInputView();
                    // RelativeLayout inputNumberRootRL = inputView.getInputNumberRootRL();
                    // View inflate = LayoutInflater.from(mActivity.get().getBaseContext()).inflate(R.layout.sms_title_content, null);
                    // TextView otherLogin = inflate.findViewById(R.id.tv_test);
                    // otherLogin.setOnClickListener(new View.OnClickListener() {
                    //     @Override
                    //     public void onClick(View v) {
                    //         mAlicomFusionBusiness.destory();
                    //     }
                    // });
                    // RelativeLayout.LayoutParams rl=new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
                    // rl.addRule(RelativeLayout.CENTER_IN_PARENT,RelativeLayout.TRUE);
                    // inflate.setLayoutParams(rl);
                    // inputNumberRootRL.addView(inflate);
                    // RelativeLayout privacyRL = inputView.getPrivacyRL();
                    // View inflate = LayoutInflater.from(mActivity.get().getBaseContext()).inflate(R.layout.fusion_sms_inputnumber, null);
                    // TextView otherLogin = inflate.findViewById(R.id.fusion_getsms_privacytext);
                    // otherLogin.setText("555");
                    // RelativeLayout.LayoutParams rl=new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
                    // rl.addRule(RelativeLayout.CENTER_IN_PARENT,RelativeLayout.TRUE);
                    // inflate.setLayoutParams(rl);
                    
            //         privacyRL.addView(inflate);
                    
            //     }
            // });

        }

        @Override
        public void onSMSSendVerifyUICustomView(String templateId, String nodeId, AlicomFusionUpSMSView view, String receivePhoneNumber, String verifyCode) {
            

        }
        
    };

    protected View initNumberView() {
        TextView var10000 = new TextView(mActivity.get());
        var10000.setText("+86 ");
        var10000.setTextColor(-16777216);
        var10000.setTextSize((float)AppUtils.dp2px(mActivity.get(), 10.0F));
        RelativeLayout.LayoutParams var10002 = new RelativeLayout.LayoutParams(-2, -2);
        var10002.setMargins(AppUtils.dp2px(mActivity.get(), (float)((int)((double)AppUtils.getPhoneWidthPixels(mActivity.get()) * 0.075))), 0, 0, 0);
        var10000.setLayoutParams(var10002);
        return var10000;
    }

    // 开始拉起场景
    public void startScene(@NonNull MethodChannel.Result result) {
        Activity activity = mActivity.get();
        if (activity == null) {
            result.error("10000", "当前无法获取Flutter Activity,请重启再试", null);
            return;
        }
        Context context = activity.getBaseContext();
        Intent intent = new Intent(context, DecoyMaskActivity.class);
        activity.startActivity(intent);
    }

    // 继续场景
    public void continueScene(Object arguments) {
        mAlicomFusionBusiness.continueSceneWithTemplateId(currentTemplatedId,true);
    }
    
    // 结束场景
    public void stopScene() {
        mAlicomFusionBusiness.stopSceneWithTemplateId(currentTemplatedId);
        if (decoyMaskActivity != null) {
            decoyMaskActivity.finish();
        }
    }

    // 销毁服务
    public void destroy() {
        if(mAlicomFusionBusiness != null){
            mAlicomFusionBusiness.destory();
            mAlicomFusionBusiness = null;
        }
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

    public String getCurrentTemplatedId(){
        return currentTemplatedId;
    }
}