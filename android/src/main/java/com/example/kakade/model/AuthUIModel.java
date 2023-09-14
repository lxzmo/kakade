package com.example.kakade.model;

import static com.example.kakade.utils.Constant.Font_12;
import static com.example.kakade.utils.Constant.Font_14;

import androidx.annotation.NonNull;

import java.util.List;

public class AuthUIModel {
    // logo
    public Boolean logoIsHidden;
    public String logoImage;
    public int logoWidth;
    public int logoHeight;

    // login button
    public String loginBtnText = "一键登录";


    public String getLogoImage() {
        return logoImage;
    }

    public int getLogoWidth() {
        return logoWidth;
    }

    public int getLogoHeight() {
        return logoHeight;
    }

    public String getLoginBtnText(){
        return loginBtnText;
    }
}


