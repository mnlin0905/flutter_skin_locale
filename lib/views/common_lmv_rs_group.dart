import 'package:flutter/material.dart';
import 'package:flutter_skin_locale/utils/support_models.dart';
import 'line_menu_view.dart';

/// <T> 模式类型
class CommonLmvRsGroup<T> extends StatefulWidget {
  ///当前的模式(默认第一个选中的模式),可为 null,表示开始时未能加载 到具体模式(或由于异步,导致变量值还未获取到)
  final T currentMode;

  /// 对应的menu字符串
  final Iterable<Pair<T, String>> menus;

  /// 回调监听器,当点击切换,会传出mode值,(异步调用,防止线程卡顿);
  ///
  /// 如果返回true,表示逻辑成功,会将选中状态进行切换;
  /// 如果返回false,则widget不会主动做改变
  Future<bool> Function(T oldMode, T newMode) callback;

  @override
  State createState() => CommonLmvRsGroupState(currentMode);

  CommonLmvRsGroup({
    Key key,
    this.currentMode,
    this.menus,
    this.callback,
  })  : assert(menus != null && callback != null),
        super(key: key);
}

/// 状态
class CommonLmvRsGroupState<T> extends State<CommonLmvRsGroup<T>> {
  /// 当前被选中的模式
  T currentMode;

  @override
  Widget build(BuildContext context) {
    // 可能 widget 有效创建为两次(第一次为null,表示未获取到数据,第二次为有值情况)
    if (widget.currentMode != null && currentMode == null) {
      currentMode = widget.currentMode;
    }

    return ListView(
      addAutomaticKeepAlives: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: () {
        List<Widget> results = [];
        for (int index = 0; index < widget.menus.length; index++) {
          // 获取需要的item
          results.add(Container(
            color: Theme.of(context).backgroundColor,
            child: LineMenuView(
              initParams: LmvParams(
                plugin: LineMenuViewPlugin.LMV_SELECT,
                rightSelect: widget.menus.elementAt(index).first == currentMode,
                menuText: widget.menus.elementAt(index).second,
              ),
              initListener: LmvListener(onPerformSelf: () {
                // 弹出等待窗口
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (it) {
                    return Center(
                      child: new CircularProgressIndicator(),
                    );
                  },
                );

                // 设置选中的 模式
                widget.callback(currentMode, widget.menus.elementAt(index).first).then((it) {
                  // 成功则进行回调,
                  if (it) {
                    setState(() {
                      currentMode = widget.menus.elementAt(index).first;
                    });
                  } else {
                    //逻辑未通过,界面不刷新
                    print("逻辑未通过,界面不刷新");
                  }
                  Navigator.pop(context);
                }, onError: (err) {
                  // 异常时不处理逻辑
                  print("$err");
                  Navigator.pop(context);
                });
              }),
            ),
          ));

          //分割线
          if (index != widget.menus.length - 1) {
            results.add(Divider(
              height: 1,
            ));
          }
        }
        return results;
      }(),
    );
  }

  /// 第一次赋值后,界面可以显示首先选中的条目
  CommonLmvRsGroupState(this.currentMode);
}
