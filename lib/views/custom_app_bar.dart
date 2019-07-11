import 'dart:math';

import 'package:flutter/material.dart';


/// 自定义appbar 可弹出窗口
class CustomAppBar extends StatelessWidget  implements PreferredSizeWidget {
  /// 标题
  final String _title;

  ///  手势,当点击返回键时,处理的逻辑,如果不传值,则默认会返回上个界面,且不包含任何返回值
  final void Function(BuildContext ctx) _onReturn;

  CustomAppBar({String title, Function(BuildContext ctx) onReturn})
      : _title = title == null ? "" : title,
        _onReturn = onReturn != null ? onReturn : null;

  @override
  Widget build(BuildContext context) {
    return FixHeightAppBar(
      child: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.title.color,
          ),
          onTap: () {
            //  返回上一页,退栈
            if (_onReturn == null) {
              Navigator.pop(context);
            } else {
              _onReturn(context);
            }
          },
        ),
        centerTitle: true,
        title: Text(
          _title,
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}

/// 固定高度的appbar 模型
class FixHeightAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 布局代理
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }

  /// 传入child
  FixHeightAppBar({@required this.child});
}
