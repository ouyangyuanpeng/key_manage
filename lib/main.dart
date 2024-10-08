import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:key_manage/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = '密码管理器';
    // 界面采用Material风格 使用https://github.com/jonataslaw/getx
    return GetMaterialApp(
        title: appTitle,
        themeMode: ThemeMode.system,
        // 本地化语言配置
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('zh', 'CN'),
          Locale('zh', 'TW'),
          Locale('ko', 'KR'),
          Locale('pt', 'BR'),
        ],
        locale: const Locale('zh', 'CN'),
        theme: ThemeData(
          colorSchemeSeed: Color(0xff6750a4),
          // 设置默认文本颜色为
        ),
        // 路由
        getPages: Routes.pages);
  }
}
