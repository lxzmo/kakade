package com.example.kakade;

import androidx.annotation.NonNull;

import com.alicom.fusion.auth.AlicomFusionBusiness;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** KakadePlugin */
public class KakadePlugin implements FlutterPlugin, MethodCallHandler {

    private static final String TAG = "KakadePlugin";

     private AuthClient authClient;
    
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity

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
        authClient.setFlutterPluginBinding(null);
        authClient.getChannel().setMethodCallHandler(null);
    }
}
