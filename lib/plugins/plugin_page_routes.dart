import 'package:flutter/cupertino.dart';
import 'package:flutter_skin_locale/activitys/soft_setting_activity.dart';
import 'package:flutter_skin_locale/activitys/switch_support_locale_activity.dart';
import 'package:flutter_skin_locale/activitys/switch_theme_mode_activity.dart';

/// 当前的所有的Activity (仿 ARouter)
const r_default_activity = "/";
const r_switch_support_locale_activity = "/switch_support_locale_activity";
const r_switch_theme_mode_activity = "/switch_theme_mode_activity";

/// 路由,采用小写模式
const r_main_activity = "/main_activity";

/// 设置跳转的 routes
final Map<String, WidgetBuilder> gActivityRoutes = {
  r_default_activity: (ctx) => SoftSettingActivity(),
  r_switch_support_locale_activity: (ctx) => SwitchSupportLocaleActivity(),
  r_switch_theme_mode_activity: (ctx) => SwitchThemeModeActivity(),
};
