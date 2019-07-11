import 'package:flutter/material.dart';
import 'package:flutter_skin_locale/configs/app_status_holder.dart';
import 'package:flutter_skin_locale/configs/const_value_key_config.dart';
import 'package:flutter_skin_locale/generated/i18n.dart';
import 'package:flutter_skin_locale/plugins/plugin_event_bus.dart';
import 'package:flutter_skin_locale/utils/support_models.dart';
import 'package:flutter_skin_locale/views/common_lmv_rs_group.dart';
import 'package:flutter_skin_locale/views/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 枚举: 支持的语言种类
enum SupportLocale {
  FOLLOW_SYSTEM,
  SIMPLIFIED_CHINESE,
  TRADITIONAL_CHINESE_TW,
  TRADITIONAL_CHINESE_HK,
  ENGLISH,
}

/// SupportLocale -> locale
Map<SupportLocale, Locale> mapLocales = {
  SupportLocale.FOLLOW_SYSTEM: null,
  SupportLocale.SIMPLIFIED_CHINESE: Locale("zh", "CN"),
  SupportLocale.TRADITIONAL_CHINESE_TW: Locale("zh", "TW"),
  SupportLocale.TRADITIONAL_CHINESE_HK: Locale("zh", "HK"),
  SupportLocale.ENGLISH: Locale("en", ""),
};

///SupportLocale 对应的含义
Map<SupportLocale, String> get mapSupportLocale => {
      SupportLocale.FOLLOW_SYSTEM: "跟随系统",
      SupportLocale.SIMPLIFIED_CHINESE: "简体中文",
      SupportLocale.TRADITIONAL_CHINESE_TW: "繁體中文(臺灣)",
      SupportLocale.TRADITIONAL_CHINESE_HK: "繁體中文(香港)",
      SupportLocale.ENGLISH: "English",
    };

/// 主界面内容
class SwitchSupportLocaleActivity extends StatefulWidget {
  @override
  State createState() => _State();
}

class _State extends State<SwitchSupportLocaleActivity> with WidgetsBindingObserver {
  /// 初始状态
  SupportLocale _initS = SupportLocale.values[gCurrentSupportLocale];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).label_switch_support_locale,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 10,
          ),
          CommonLmvRsGroup<SupportLocale>(
            currentMode: _initS,
            menus: () {
              return SupportLocale.values.map((it) {
                return Pair(it, mapSupportLocale[it]);
              });
            }(),
            callback: switchTS,
          ),
        ],
      ),
    );
  }

  /// 切换
  Future<bool> switchTS(SupportLocale old, SupportLocale news) async {
    await (await SharedPreferences.getInstance()).setInt(KEY_SUPPORT_LOCALE, news.index);
    eventBus.fire(SupportLocaleSwitch(currentSupportLocale: news.index));
    setState(() {});
    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }
}
