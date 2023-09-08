package com.example.kakade;

import android.app.Activity;
import android.content.Context;
import android.content.res.AssetManager;
import android.util.Log;

import androidx.annotation.NonNull;

import com.example.kakade.model.AuthResponseModel;
import com.alicom.fusion.auth.AlicomFusionBusiness;

import java.lang.ref.WeakReference;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** KakadePlugin */
public class KakadePlugin implements FlutterPlugin, MethodCallHandler ,ActivityAware{

    private static final String TAG = "KakadePlugin";

    private AuthClient authClient;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        MethodChannel methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "kakade");
        authClient = AuthClient.getInstance();
        authClient.setChannel(methodChannel);
        methodChannel.setMethodCallHandler(this);
        authClient.setFlutterPluginBinding(flutterPluginBinding);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
         switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "getSDKVersion":
                getSDKVersion(result);
                break;
             case "initSdk":
                authClient.initSdk(call.arguments, result);
                break;
            case "startScene":
                // 开始拉起场景
                authClient.startScene(result);
                break;
            case "continueScene":
                // 继续场景
                authClient.continueScene(call.arguments);
                break;
            case "stopScene":
                // 结束登录注册
                authClient.stopScene();
                break;
            case "destroy":
                // 销毁服务
                authClient.destroy();
                break;
            default:
                result.notImplemented();
        }
    }

    private void getSDKVersion(@NonNull Result result) {
        String version = AlicomFusionBusiness.getSDKVersion();
        result.success("阿里云一键登录版本:" + version);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "onDetachedFromEngine");
        authClient.setFlutterPluginBinding(null);
        authClient.getChannel().setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        WeakReference<Activity> activityWeakReference = new WeakReference<>(binding.getActivity());
        authClient.setActivity(activityWeakReference);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivity() {
        Log.d(TAG, "onDetachedFromActivity");
        authClient.setFlutterPluginBinding(null);
        authClient.getChannel().setMethodCallHandler(null);
        authClient.setActivity(null);
    }
}
