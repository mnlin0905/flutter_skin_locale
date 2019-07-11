import 'package:flutter/material.dart';
import 'package:flutter_skin_locale/configs/app_locale_config.dart';
import 'package:flutter_skin_locale/configs/app_status_holder.dart';
import 'package:flutter_skin_locale/configs/const_value_key_config.dart';
import 'package:flutter_skin_locale/generated/i18n.dart';
import 'package:flutter_skin_locale/plugins/plugin_event_bus.dart';
import 'package:flutter_skin_locale/utils/support_models.dart';
import 'package:flutter_skin_locale/views/common_lmv_rs_group.dart';
import 'package:flutter_skin_locale/views/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 枚举: 主题模式
/// [ThemeMode.LIGHT]  白天模式
/// [ThemeMode.DARK] 夜间模式
enum ThemeMode {
  LIGHT,
  DARK,
}

///ThemeMode 对应的含义
Map<ThemeMode, String> get mapThemeMode => {
      ThemeMode.LIGHT: SS.activity_switch_theme_mode_light,
      ThemeMode.DARK: SS.activity_switch_theme_mode_dark,
    };

/// 主界面内容
class SwitchThemeModeActivity extends StatefulWidget {
  @override
  State createState() => _State();
}

class _State extends State<SwitchThemeModeActivity> {
  /// 初始状态
  ThemeMode _initS;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _initS = ThemeMode.values[gCurrentThemeIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).label_switch_theme_mode,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 10,
          ),
          CommonLmvRsGroup<ThemeMode>(
            currentMode: _initS,
            menus: () {
              return ThemeMode.values.map((it) {
                return Pair(it, mapThemeMode[it]);
              });
            }(),
            callback: switchTS,
          ),
        ],
      ),
    );
  }

  /// 切换
  Future<bool> switchTS(ThemeMode old, ThemeMode news) async {
    await (await SharedPreferences.getInstance()).setInt(KEY_THEME_MODE, news.index);
    eventBus.fire(SystemThemeSwitch(currentThemeIndex: news.index));
    setState(() {});
    return true;
  }
}
