import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:key_manage/model/key_model.dart';
import 'package:key_manage/routes/routes.dart';
import 'package:key_manage/utils/aes_utils.dart';
import 'package:key_manage/pages/home_left_drawer.dart';

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
          title: Text(
            "密码管理",
            style: const TextStyle(color: Colors.white),
          ),
          // backgroundColor: theme.primaryColor,
        ),
        // 页面主题内容区域
        body: MyBody(),
        // 右下角悬浮按钮
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Get.toNamed(Routes.add);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        // 悬浮按钮位置 配合底部应用栏使用
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        drawer: const HomeLeftDrawer(),
        // 底部应用栏
        bottomNavigationBar: BottomAppBar(
          // 定义底部应用栏的形状，CircularNotchedRectangle=创建一个带有圆形缺口的底部导航栏，通常用于容纳 FloatingActionButton。
          shape: const CircularNotchedRectangle(),
          color: Colors.blue,
          child: IconTheme(
            data: IconThemeData(color: theme.colorScheme.onPrimary),
            child: Row(
              children: [
                IconButton(
                  tooltip: '设置密钥',
                  icon: const Icon(Icons.key),
                  onPressed: () {
                    _showKeyInputDialog(context);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  // 密钥输入框弹窗
  void _showKeyInputDialog(BuildContext context) {
    TextEditingController keyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('设置密钥'),
          content: SizedBox(
            width: double.maxFinite, // 设置对话框宽度为最大
            child: TextField(
              controller: keyController,
              decoration: const InputDecoration(hintText: '请输入密钥'),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                String enteredKey = keyController.text;
                // 在这里处理输入的密钥
                print("输入的密钥: $enteredKey");
                AesUtils.defaultKey = enteredKey;
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
          ],
        );
      },
    );
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
      backgroundColor: Colors.white,
      child: Obx(() => ListView(
            children: KeysController.to.keys
                .map((k) => Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: _getLetterIcon(k.domain),
                      title: Text(k.domain),
                      subtitle: Text(k.username),
                      trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red),onPressed: ()=> KeysController.to.removeKeys(k.id!),),
                      onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => _PasswordDialog(
                                k: k,
                              )),
                    )))
                .toList(),
          )),
    );
  }
}

/// 密码控制
class _PasswordDialogController extends GetxController {
  static _PasswordDialogController get to => Get.find();

  var isPasswordVisible = false.obs;
  var password = "".obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    try {
      password.value = AesUtils.decryptPassword(password.value);
    } catch (e, s) {
      print(s);
    }
  }
}

/// 使用Getx状态管理，当前类处理数据更新操作
class _PasswordDialog extends StatelessWidget {
  bool isPasswordVisible = false;
  final KeyModel k;

  _PasswordDialog({required this.k});

  // 添加状态控制器到
  @override
  Widget build(BuildContext context) {
    final _PasswordDialogController pass = Get.put(_PasswordDialogController());

    final controller = _PasswordDialogController.to; // 获取控制器实例
    controller.password.value = k.password;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('密码详情'),
      content: SizedBox(
        width: double.maxFinite, // 设置对话框宽度为最大
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('厂商'),
              subtitle: SelectableText(k.domain), // 使用 SelectableText
            ),
            ListTile(
              title: const Text('用户名'),
              subtitle: SelectableText(k.username), // 使用 SelectableText
            ),
            ListTile(
                title: const Text('密码'),
                subtitle: Obx(() => SelectableText(
                      controller.isPasswordVisible.value
                          ? controller.password.value
                          : k.password.split(":").length > 1
                              ? k.password.split(":")[1]
                              : '无密码', // 隐藏密码
                      style: TextStyle(color: Colors.red),
                    ))),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => {
            controller.isPasswordVisible.value = false,
            // 关闭弹框
            Navigator.pop(context, '关闭')
          },
          child: const Text('关闭'),
        ),
        TextButton(
          onPressed: () {
            controller.togglePasswordVisibility();
          },
          child: Obx(() => Text(
              controller.isPasswordVisible.value ? '隐藏密码' : '显示密码')), // 按钮文本变化,
        ),
      ],
    );
  }
}

/// 首字母生成图标
Widget _getLetterIcon(String title) {
  // 获取标题的首字母并转换为大写
  String firstLetter = title[0].toUpperCase();

  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: Colors.blue, // 背景色
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
