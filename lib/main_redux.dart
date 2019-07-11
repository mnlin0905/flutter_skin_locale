import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_skin_locale/plugins/plugin_page_routes.dart';
import 'package:flutter_skin_locale/utils/support_models.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'activitys/switch_support_locale_activity.dart';
import 'configs/app_status_holder.dart';
import 'configs/app_theme_config.dart';
import 'configs/const_value_key_config.dart';
import 'generated/i18n.dart';
import 'plugins/plugin_event_bus.dart';

/// 支持redux状态更改的事件
enum StatusEvents {
  /// 主题改变
  ThemeChange,

  /// 本地locale变化
  LocaleChange,
}

/// 状态集合类,包含应用中所有需要使用的状态信息
class StatusCombine {
  final int currentTheme;
  final Locale currentLocale;

  StatusCombine({this.currentTheme = 0, this.currentLocale});

  StatusCombine.copy(
    StatusCombine oldState, {
    int currentTheme,
    Locale currentLocale,
  })  : this.currentTheme = currentTheme ?? oldState.currentTheme,
        this.currentLocale = currentLocale ?? oldState.currentLocale;
}

//创建store,action类型为 Pair<StatusEvents,dynamic>
final singleStore = Store<StatusCombine>(
  (state, action) {
    print("$state    $action");
    if (action is Pair && action.first is StatusEvents) {
      //提供状态转换的方式 ,根据 action 从 oldState -> newState
      print("${action.first}");
      switch (action.first) {
        case StatusEvents.ThemeChange: // theme
          return StatusCombine.copy(state, currentTheme: state.currentTheme + action.second);
          break;
        case StatusEvents.LocaleChange: // locale
          return StatusCombine.copy(state, currentLocale: action.second);
          break;
      }
    }
  },
  initialState: StatusCombine(),
);

/// 程序入口,默认native执行 /lib/main.dart 文件
void main() {
  //保证顶部有状态类
  runApp(StoreProvider<StatusCombine>(
    store: singleStore,
    child: FlutterReduxApp(),
  ));
}

/// 自定义包裹 app, 实现换肤等功能
class CustomApp extends StatefulWidget {
  @override
  State createState() => _CustomAppState();
}

class _CustomAppState extends State<CustomApp> {
  @override
  void initState() {
    super.initState();
    // 初始化皮肤取值等全局 所需 参数
    SharedPreferences.getInstance().then((it) {
      setState(() {
        gCurrentThemeIndex = it.getInt(KEY_THEME_MODE) ?? 0;
        gCurrentSupportLocale = it.getInt(KEY_SUPPORT_LOCALE) ?? 0;
      });
    });

    // 当通知系统时,刷新一下状态(换肤/切换语言/涨跌颜色)
    eventBus.on<SystemThemeSwitch>().listen((it) {
      setState(() {
        // 修改皮肤
        gCurrentThemeIndex = it.currentThemeIndex;
      });
    });
    eventBus.on<SupportLocaleSwitch>().listen((it) {
      setState(() {
        gCurrentSupportLocale = it.currentSupportLocale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'USDP Flutter Mudule',
      debugShowCheckedModeBanner: false,
      theme: themes[gCurrentThemeIndex],
      routes: gActivityRoutes,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate, //Material 组件库所使用的字符串
        GlobalWidgetsLocalizations.delegate, // 在当前的语言中，文字默认的排列方向
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: S.delegate.resolution(fallback: const Locale('zh', 'CN')), // 不存对应locale时,默认取值英文
      locale: mapLocales[SupportLocale.values[gCurrentSupportLocale]],
    );
  }
}

class FlutterReduxApp extends StatelessWidget {
  final String title;

  FlutterReduxApp({Key key, this.title = "text"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The StoreProvider should wrap your MaterialApp or WidgetsApp. This will
    // ensure all routes have access to the store.
    return new MaterialApp(
      theme: new ThemeData.dark(),
      title: title,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text(
                'You have pushed the button this many times:',
              ),
              Listener(
                onPointerDown: (e){
                  print("down1");
                },
                child: GestureDetector(
                  onTap: (){
                    print("tap1");
                  },
                  child: new Container(
                    color: Colors.red,
                    constraints: BoxConstraints.tightFor(width: 300, height: 300),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16),
                    child: Listener(
                      onPointerDown: (e){
                        print("down2");
                      },
                      child: GestureDetector(
                        onTap: (){
                          print("tap2");
                        },
                        child: new Container(
                          color: Colors.blue,
                          padding: EdgeInsets.all(16),
                          constraints: BoxConstraints.tightFor(width: 200, height: 200),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Connect the Store to a Text Widget that renders the current
              // count.
              //
              // We'll wrap the Text Widget in a `StoreConnector` Widget. The
              // `StoreConnector` will find the `Store` from the nearest
              // `StoreProvider` ancestor, convert it into a String of the
              // latest count, and pass that String  to the `builder` function
              // as the `count`.
              //
              // Every time the button is tapped, an action is dispatched and
              // run through the reducer. After the reducer updates the state,
              // the Widget will be automatically rebuilt with the latest
              // count. No need to manually manage subscriptions or Streams!
              new StoreConnector<StatusCombine, String>(
                converter: (store) => store.state.currentTheme.toString(),
                builder: (context, count) {
                  return Column(
                    children: <Widget>[
                      new Text(
                        count,
                        style: Theme.of(context).textTheme.display1,
                      ),
                      ShareDataWidget(
                        data: singleStore.state.currentTheme,
                        child: Builder(builder: (ctx) {
                          return Text(ShareDataWidget.of(ctx).data.toString());
                        }),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
        // Connect the Store to a FloatingActionButton. In this case, we'll
        // use the Store to build a callback that with dispatch an Increment
        // Action.
        //
        // Then, we'll pass this callback to the button's `onPressed` handler.
        floatingActionButton: new FloatingActionButton(
          // Attach the `callback` to the `onPressed` attribute
          onPressed: () {
            singleStore.dispatch(Pair(StatusEvents.ThemeChange, 1));
          },
          tooltip: 'Increment',
          child: new Icon(Icons.add),
        ),
      ),
    );
  }
}

class ShareDataWidget extends InheritedWidget {
  ShareDataWidget({@required this.data, Widget child}) : super(child: child);

  int data; //需要在子树中共享的数据，保存点击次数

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static ShareDataWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ShareDataWidget);
  }

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget
  @override
  bool updateShouldNotify(ShareDataWidget old) {
    //如果返回true，则子树中依赖(build函数中有调用)本widget
    //的子widget的`state.didChangeDependencies`会被调用

    return old.data != data;
  }

}

class AA{
  AA.aa();

  factory AA() => AA.aa();
}
