package com.example.kakade.mask;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;

import com.example.kakade.AuthClient;
import com.example.kakade.utils.Constant;
import com.example.kakade.R;
import com.alicom.fusion.auth.AlicomFusionBusiness;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class DecoyMaskActivity extends Activity {

    public static final String TAG = DecoyMaskActivity.class.getSimpleName();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        Log.i(TAG, "onCreate");
        AuthClient authClient = AuthClient.getInstance();
        AuthClient.decoyMaskActivity = this;
        overridePendingTransition(R.anim.slide_up, R.anim.stay_animation);
        AlicomFusionBusiness mAlicomFusionBusiness = authClient.mAlicomFusionBusiness;
        mAlicomFusionBusiness.startSceneWithTemplateId(this.getBaseContext(), authClient.getCurrentTemplatedId(),authClient.uiCallBack);
        super.onCreate(savedInstanceState);
    }

    boolean isPause = false;

    @Override
    protected void onPause() {
        Log.i(TAG, "onPause");
        isPause = true;
        super.onPause();
    }

    @Override
    protected void onResume() {
        Log.i(TAG, "onResume");

        if (isPause) {
            Log.i(TAG, "onPause2");
            //TopActivityBack
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    Log.i(TAG, "onResumefinish");
                    finish();
                }
            };
            ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(1);
            scheduledExecutorService.schedule(runnable, 0, TimeUnit.MILLISECONDS);
        }
        super.onResume();
    }


    @Override
    public void finish() {
        Log.i(TAG, "finish");
        AuthClient.decoyMaskActivity = null;
        super.finish();
    }

    @Override
    protected void onDestroy() {
        Log.i(TAG, "onDestroy");
        super.onDestroy();
    }
}
