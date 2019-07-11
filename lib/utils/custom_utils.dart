import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_skin_locale/configs/app_status_holder.dart';

/// 获取图片路径(中转,用于多环境等情况) [PlatformAssetBundle] 类查看资源获取逻辑
///
/// [useDefault] 是否使用默认的主题资源(当多theme使用相同image时,会有这种情况)
/// [picFormat] 图片格式,默认为png,
String dispatcherPictureByName(String picName, {bool useDefault = false, String picFormat = "png"}) {
  RegExp filter = RegExp("^[^.]+\.(png)|(jpg)|(jpeg)|(gif)|(webp)|(bmp)|(wbmp)\$", caseSensitive: false, multiLine: false);

  // 添加后缀
  picName = filter.hasMatch(picName) ? picName : "$picName.$picFormat";

  // 取系统主题颜色
  String pathName = "assets/images-$gCurrentThemeIndex/$picName";

  // 返回需要的路径
  return useDefault ? "assets/images-1/$picName" : pathName;

  /*return _judgeResourceExist(pathName).then((it) {
      // 根据判断返回正确的资源文件
      return it ? pathName : "assets/images-0/$picName";
  });*/
}

/// 判断某个资源文件是否存在
Future<bool> _judgeResourceExist(String pathName) async {
  final Uint8List encoded = utf8.encoder.convert(Uri(path: Uri.encodeFull(pathName)).path);
  final ByteData asset = await BinaryMessages.send('flutter/assets', encoded.buffer.asByteData());
  return asset != null;
}

/// 底部一条线,背景为透明
BoxDecoration decoration_bg_trans_bottom_divider_1(BuildContext ctx) => BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Theme.of(ctx).dividerColor,
        ),
      ),
    );

/// 底部一条线,背景为默认背景颜色
BoxDecoration decoration_bg_color_bottom_divider_1(BuildContext ctx) => BoxDecoration(
      color: Theme.of(ctx).backgroundColor,
      border: Border(
        bottom: BorderSide(
          color: Theme.of(ctx).dividerColor,
        ),
      ),
    );
