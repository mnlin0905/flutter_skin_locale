//事件class ,event-bus

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

///创建事件(异步)
EventBus eventBus = EventBus();

/// 1. 系统主题切换
class SystemThemeSwitch {
  /// 当前系统的 ui 颜色值(测试使用)
  int currentThemeIndex;

  SystemThemeSwitch({
    @required this.currentThemeIndex,
  }) : assert(currentThemeIndex != null);
}

/// 1. 当前语言切换
class SupportLocaleSwitch {
  /// 当前系统的 ui 颜色值(测试使用)
  int currentSupportLocale;

  SupportLocaleSwitch({
    @required this.currentSupportLocale,
  }) : assert(currentSupportLocale != null);
}
