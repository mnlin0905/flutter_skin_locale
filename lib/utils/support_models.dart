import 'package:flutter/widgets.dart';

/// pair 键值对
class Pair<S, T> {
  S first;
  T second;

  Pair(this.first, this.second);
}

/// Triple 键值对
class Triple<FIRST, SECOND, THIRD> {
  FIRST first;
  SECOND second;
  THIRD third;

  Triple(this.first, this.second, this.third);
}

/// 跳转界面时,获取需要的参数
mixin GetJumpParam<T extends StatefulWidget> implements State<T> {
  Map<String, dynamic> get jumpKeyValues {
    return ModalRoute.of(context).settings.arguments;
  }
}

/// TODO 表示未完成的方法,会直接抛出异常
void TODO({Object obj}) {
  throw Exception("not implement this module : $obj");
}
