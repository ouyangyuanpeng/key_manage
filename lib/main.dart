import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:key_manage/routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = '密码管理器';
    // 界面采用Material风格
    return GetMaterialApp(
        title: appTitle,
        themeMode: ThemeMode.system,
        locale: const Locale('zh', 'CN'),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          // 设置AppBar的默认主题色
          appBarTheme: const AppBarTheme(
              color: Colors.blue,
              iconTheme: IconThemeData(color: Colors.white)),
          // 设置默认文本颜色为
          textTheme:
              const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Colors.white,
          ),
        ),
        // 指定应用程序的主界面
        getPages: Routes.pages);
  }
}
