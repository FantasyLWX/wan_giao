import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';
import 'package:wan_android/app/app_state.dart';
import 'package:wan_android/compents/contrants_info.dart';
import 'package:wan_android/controller/device_info_controller.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/theme/app_color.dart';
import 'package:wan_android/theme/app_style.dart';
import 'package:wan_android/theme/app_theme.dart';
import 'package:wan_android/util/app_update.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios,size: 20.w,),
          ),
          iconTheme:
              IconThemeData(color: Get.isDarkMode ? Colors.grey : Colors.black),
          title: Text(
            "设置",
            style: TextStyle(
              color: Get.isDarkMode ? Colors.grey : Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        ),
        body: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          padding: EdgeInsets.only(top: 10.h),
          color: Get.isDarkMode ? Colors.black45 : Colors.grey[100],
          child: Column(
            children: [
              _switchThemeDark(context),
              SizedBox(height: 10.h),
              _appVersionText(context),
              SizedBox(height: 10.h),
              _appAuthorText(context),
              //退出登录
              _logoutButton(context),
              SizedBox(height: 10.h),
            ],
          ),
        ));
  }

  Widget _switchThemeDark(BuildContext context) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SwitchListTile(
          dense: true,
          value: Get.isDarkMode,
          activeColor: Colors.white,
          title: Text(
            "夜间模式",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onChanged: (flag) {
            String themeKey = Get.isDarkMode ? ThemeKey.LIGHT : ThemeKey.DARK;
            Get.changeTheme(themeList[themeKey]);
            SpUtil.putString(ThemeKey.KEY_APP_THEME, themeKey);
          },
        ));
  }

  Widget _appVersionText(BuildContext context) {
    return InkWell(
      onTap: () {
        AppUpdate.checkUpdate(context);
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListTile(
          title: Text("检查版本", style: Theme.of(context).textTheme.bodyText1),
          dense: true,
          trailing: Obx(() {
            return Text(Get.find<DeviceInfoController>().versionName.value,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 15.sp));
          }),
        ),
      ),
    );
  }

  Widget _appAuthorText(BuildContext context) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            ListTile(
                title: Text("作者", style: Theme.of(context).textTheme.bodyText1),
                dense: true,
                trailing: Text("Lollipop",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 15.sp))),
            Divider(thickness: 1.h),
            ListTile(
                title: Text("邮箱", style: Theme.of(context).textTheme.bodyText1),
                dense: true,
                trailing: Text("ljs581@163.com",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 15.sp))),
            Divider(thickness: 1.h),
            ListTile(
                title:
                    Text("Gitee", style: Theme.of(context).textTheme.bodyText1),
                dense: true,
                trailing: Text("gitee.com/lambadaace/wan_android",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 15.sp))),
            Divider(thickness: 1.h),
            ListTile(
                title: Text("GitHub",
                    style: Theme.of(context).textTheme.bodyText1),
                dense: true,
                trailing: Text("github.com/wo5813288/wan_giao",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 15.sp))),
          ],
        ));
  }

  Widget _logoutButton(BuildContext context) {
    return loginState == LoginState.LOGIN
        ? Container(
            margin: EdgeInsets.only(top: 10.h),
            width: double.infinity,
            height: 40.h,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TextButton(
              child: Text(
                "退出登录",
                style: TextStyle(color: Colors.red, fontSize: 16.sp),
              ),
              onPressed: () {
                _showIsLogoutDialog(context).then((value) {
                  if (value) {
                    logout();
                    Get.back();
                  }
                });
              },
            ),
          )
        : Container();
  }

  _showIsLogoutDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text("确认退出", style: TextStyle(color: Colors.black)),
                content: Text("退出当前账号，将不能同步收藏，评论，查看积分等",
                    style: TextStyle(color: Colors.black)),
                actions: [
                  TextButton(
                    child: Text("取消",
                        style:
                            TextStyle(color: KColors.kDialogCancelTextColor)),
                    onPressed: () {
                      Get.back(result: false);
                    },
                  ),
                  TextButton(
                    child: Text("确认退出", style: kPrivacyYesTextStyle),
                    onPressed: () {
                      Get.back(result: true);
                    },
                  )
                ]));
  }
}

logout() {
  HttpManager.clearCookie();
  SpUtil.remove(ConstantInfo.KEY_USER);
  appState.setIsLogin(LoginState.LOGO_OUT);
}

///用户确认是否退出
