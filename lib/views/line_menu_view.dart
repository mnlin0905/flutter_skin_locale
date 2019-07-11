import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skin_locale/utils/custom_utils.dart';


/// [LineMenuView] 控件的 plugin 类型
/// [LineMenuViewPlugin.LMV_TEXT] text : 包含文本样式,可以包含箭头,badge等控件
/// [LineMenuViewPlugin.LMV_SELECT] select: 包含右侧选中图标,或者无图标
/// [LineMenuViewPlugin.LMV_SWITCH] switch: 官方switch 样式
/// [LineMenuViewPlugin.LMV_TRANSITION] transition: 两种样式进行变换
enum LineMenuViewPlugin {
  LMV_TEXT,
  LMV_SELECT,
  LMV_SWITCH,
  LMV_TRANSITION,
}

/// LineMenuView 参数集合,用于控制显示效果
class LmvParams {
  ///插件类型: 确定则无法再次改变
  LineMenuViewPlugin plugin;

  /// 左侧图标
  Widget icon;

  /// menu: 文本 ; 文字颜色 ; 文字大小
  String menuText;
  Color menuTextColor;
  double menuTextSize;

  /// menuTextStyle 该值存在时,会导致  [menuTextColor] , [menuTextSize] 失效
  TextStyle menuTextStyle;

  /// brief: 文本 ; 文字颜色 ; 文字大小
  String briefText;
  Color briefTextColor;
  double briefTextSize;

  /// briefTextStyle 该值存在时,会导致  [briefTextColor] , [briefTextSize] 失效
  TextStyle briefTextStyle;

  /// 当 [plugin] 为 select 时,控制右侧按钮是否显示
  bool rightSelect;

  /// 当 [plugin] 为 text 时,控制两个图标(最大宽高为36),一个文本
  Widget badge;
  Widget navigation;

  /// 当 [plugin] 为 switch 时,控制右侧按钮打开或关闭
  bool switchValue;

  /// 当 [plugin] 为 transition 时,控制显示某一张图片
  bool transition;

  /// 提供默认构造函数
  LmvParams({
    this.plugin = LineMenuViewPlugin.LMV_TEXT,
    this.icon,
    this.menuText,
    this.menuTextColor,
    this.menuTextSize,
    this.menuTextStyle,
    this.briefText,
    this.briefTextColor,
    this.briefTextSize,
    this.briefTextStyle,
    this.rightSelect = false,
    this.badge,
    this.navigation,
    this.switchValue = false,
    this.transition = false,
  }) {
    briefText = briefText ?? "";
    menuText = menuText ?? "";
  }
}

/// [LineMenuView] 添加监听事件
class LmvListener {
  /// 点击左侧menu
  bool Function() onClickLeft;

  /// 点击右侧
  bool Function() onClickRight;

  /// 当点击左侧/右侧,执行相同代码逻辑时
  void Function() onPerformSelf;

  LmvListener({this.onClickLeft, this.onClickRight, this.onPerformSelf});
}

/// line 布局菜单项
class LineMenuView extends StatefulWidget {
  ///插件参数列表:初始值
  final LmvParams _initParams;
  final LmvListener _initListener;

  /// 可添加自定义的属性信息
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(IntProperty("测试属性", 465, ifNull: "null ; LineMenuView IntProperty"));
    properties.add(ObjectFlagProperty("假数据属性", "哈哈哈", ifNull: "null ; LineMenuView ObjectFlagProperty"));
    super.debugFillProperties(properties);
  }

  @override
  State createState() => _State();

  /// 默认: 插件为 text 类型
  LineMenuView({
    Key key,
    LmvParams initParams,
    LmvListener initListener,
  })  : this._initParams = initParams != null ? initParams : LmvParams(),
        this._initListener = initListener,
        super(key: key);
}

/// 状态控制
class _State extends State<LineMenuView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkResponse(
        highlightColor: Colors.transparent,
        containedInkWell: true,
        focusColor: Colors.transparent,
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Offstage(
                offstage: widget._initParams.icon == null,
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: widget._initParams.icon,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  padding: EdgeInsets.only(right: 8),
                  constraints: BoxConstraints(minHeight: 48, maxHeight: 64),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      Text(
                        widget._initParams.menuText == null ? "" : widget._initParams.menuText,
                        style: widget._initParams.menuTextStyle != null
                            ? widget._initParams.menuTextStyle
                            : TextStyle(
                                fontSize: widget._initParams.menuTextSize,
                                color: widget._initParams.menuTextColor,
                              ),
                        maxLines: 1,
                        softWrap: true,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  //点击左侧
                  if ((widget._initListener?.onClickLeft != null ? widget._initListener?.onClickLeft() : true) && widget._initListener?.onPerformSelf != null) {
                    widget._initListener?.onPerformSelf();
                  }
                },
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 16),
                constraints: BoxConstraints(
                  minHeight: 48,
                  maxHeight: 64,
                ),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    getRightWidget(),
                  ],
                ),
              ),
              onTap: () {
                //点击右侧
                if ((widget._initListener?.onClickRight != null ? widget._initListener?.onClickRight() : true) && widget._initListener?.onPerformSelf != null) {
                  widget._initListener?.onPerformSelf();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 获取右侧插件布局,由于需要控制的是,在view不可见时,仍需要占用之前位置,因此,这里不能使用 [Offstage]
  Widget getRightWidget() {
    switch (widget._initParams.plugin) {
      case LineMenuViewPlugin.LMV_TEXT: // badge , brief , navigation
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxHeight: 36, maxWidth: 36),
                margin: EdgeInsets.only(right: 8),
                child: widget._initParams.badge,
              ),
              Container(
                child: Text(
                  widget._initParams.briefText,
                  style: widget._initParams.briefTextStyle ??
                      Theme.of(context).textTheme.body1.copyWith(
                            color: widget._initParams.briefTextColor,
                            fontSize: widget._initParams.briefTextSize,
                          ),
                ),
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 36, maxWidth: 36),
                margin: EdgeInsets.only(left: 8),
                child: widget._initParams.navigation,
              ),
            ],
          ),
          opacity: 1,
        );
      case LineMenuViewPlugin.LMV_SELECT: // rightSelect
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          child: Image.asset(dispatcherPictureByName("icon_right_select", useDefault: true)),
          opacity: widget._initParams.rightSelect == true ? 1 : 0,
        );
      case LineMenuViewPlugin.LMV_SWITCH:
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          child: Platform.isIOS
              ? CupertinoSwitch(
                  value: widget._initParams.switchValue == true,
                  onChanged: null,
                  activeColor: Theme.of(context).accentColor,
                )
              : Switch(
                  value: widget._initParams.switchValue == true,
                  onChanged: (value) {
                    if ((widget._initListener?.onClickRight != null ? widget._initListener?.onClickRight() : true) && widget._initListener?.onPerformSelf != null) {
                      widget._initListener?.onPerformSelf();
                    }
                  },
                  activeColor: Theme.of(context).accentColor,
                ),
          opacity: 1,
        );
      case LineMenuViewPlugin.LMV_TRANSITION:
        return Stack(
          children: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              child: Image.asset(dispatcherPictureByName("icon_transtion_close")),
              opacity: widget._initParams.transition != true ? 1 : 0,
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              child: Image.asset(dispatcherPictureByName("icon_transtion_open")),
              opacity: widget._initParams.transition == true ? 1 : 0,
            ),
          ],
        );
      default:
        throw UnsupportedError("have not support this plugin");
    }
  }
}
