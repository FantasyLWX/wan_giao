import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';
import 'package:wan_android/app/app_state.dart';
import 'package:wan_android/bean/user_data.dart';
import 'package:wan_android/compents/contrants_info.dart';
import 'package:wan_android/controller/theme_controller.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/theme/app_theme.dart';

class Global {
  static User userProfile = User();
  ///在项目启动前做一些初始化操作
  static Future init() async {
    var appState = Get.put<AppState>(AppState());
    var themeController = Get.put<ThemeController>(ThemeController());
    //初始化持久工具
    await SpUtil.getInstance();
    //出丝滑Cookie管理
    await HttpManager.initCookieJar();
    //初始化状态栏
    initStatusBar();

    Map userMap = SpUtil.getObject(ConstantInfo.KEY_USER);
    if (userMap != null) {
      userProfile = User.fromJson(userMap);
      appState.setIsLogin(LoginState.LOGIN);
    }
    //初始化默认主题
    themeController.setThemeData(SpUtil.getString(ThemeKey.KEY_APP_THEME,defValue: ThemeKey.LIGHT));

  }

  static initStatusBar(){
    if (Platform.isAndroid) {
      //如果是android设备，状态栏设置为透明沉浸
      SystemUiOverlayStyle _style = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent
      );
      SystemChrome.setSystemUIOverlayStyle(_style);
    }
  }
  /// 登录后保存用户信息
  static saveUserProfile(User user) {
    SpUtil.putObject(ConstantInfo.KEY_USER, user);
    userProfile = user;
  }
}


