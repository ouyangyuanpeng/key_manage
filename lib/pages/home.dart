import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:key_manage/model/key_model.dart';
import 'package:key_manage/routes/routes.dart';
import 'package:key_manage/pages/home_left_drawer.dart';
import 'package:key_manage/pages/home_search.dart';
import 'package:key_manage/widget/key_model_dialog.dart';
import 'package:key_manage/widget/key_input_dialog.dart';
import 'dart:math';




class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取全局设置的主题数据
    final theme = Theme.of(context);
    // Scaffold 实现了基本的 Material 布局
    return Scaffold(
        // 头部导航条区域
        appBar: AppBar(
          title: const Text(
            "密码管理",
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // 搜索
                  showSearch(
                    context: context,
                    delegate: HomeSearch(),
                  );
                },
                icon: const Icon(Icons.search))
          ],
          // backgroundColor: theme.primaryColor,
        ),
        // 页面主题内容区域
        body: MyBody(),
        // 右下角悬浮按钮
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.add);
          },
          child: const Icon(Icons.add),
        ),
        // 悬浮按钮位置 配合底部应用栏使用
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        drawer: const HomeLeftDrawer(),
        // 底部应用栏
        bottomNavigationBar: BottomAppBar(
          // 定义底部应用栏的形状，CircularNotchedRectangle=创建一个带有圆形缺口的底部导航栏，通常用于容纳 FloatingActionButton。
          shape: const CircularNotchedRectangle(),
          child: IconTheme(
            data: IconThemeData(),
            child: Row(
              children: [
                IconButton(
                  tooltip: '设置密钥',
                  icon: const Icon(Icons.key),
                  onPressed: () {
                    showKeyInputDialog(context);
                  },
                ),
              ],
            ),
          ),
        ));
  }

}

/// 使用Getx状态管理，当前类处理数据更新操作
class KeysController extends GetxController {
  /// 添加这个可以直接通过静态变量访问
  static KeysController get to => Get.find();

  final KeyModelHelper dbHelper = KeyModelHelper();

  List<KeyModel> keys = <KeyModel>[].obs;

  /// 初始化方法
  @override
  void onInit() async {
    super.onInit();
    List<KeyModel> list = await dbHelper.getKeys();
    keys.addAll(list);
  }

  /// 删除方法
  @override
  void onClose() {
    keys.clear();
    super.onClose();
  }

  Future<void> refreshKeys() async {
    keys.clear();
    // await Future.delayed(
    //     Duration(milliseconds: 200));
    // 可以在这里添加刷新逻辑
    keys.addAll(await dbHelper.getKeys());
  }

  Future<void> removeKeys(int id) async {
    await dbHelper.removeKey(id);
    keys.clear();
    keys.addAll(await dbHelper.getKeys());
  }
}

class MyBody extends StatelessWidget {
  // 添加状态控制器到
  final KeysController keysController = Get.put(KeysController());

  @override
  Widget build(BuildContext context) {
    // 下拉刷新
    return RefreshIndicator(
      onRefresh: KeysController.to.refreshKeys,
      child: Obx(() => ListView(
            children: KeysController.to.keys
                .map((k) => Card(
                    margin: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: _getLetterIcon(k.domain),
                      title: Text(k.domain),
                      subtitle: Text(k.username),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => KeysController.to.removeKeys(k.id!),
                      ),
                      onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => KeyModelDialog(
                                k: k,
                              )),
                    )))
                .toList(),
          )),
    );
  }
}


/// 首字母生成图标
Widget _getLetterIcon(String title) {
  // 获取标题的首字母并转换为大写
  String firstLetter = title[0].toUpperCase();

  // 生成随机颜色
  Color randomColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);


  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: randomColor, // 背景色
      shape: BoxShape.circle, // 圆形
    ),
    child: Center(
      child: Text(
        firstLetter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
