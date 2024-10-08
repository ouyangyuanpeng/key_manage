import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:key_manage/utils/aes_utils.dart';
import 'package:key_manage/model/key_model.dart';

class KeyModelDialogController extends GetxController {
  static KeyModelDialogController get to => Get.find();

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
class KeyModelDialog extends StatelessWidget {

  bool isPasswordVisible = false;
  final KeyModel k;

  KeyModelDialog({required this.k});

  // 添加状态控制器到
  @override
  Widget build(BuildContext context) {
    Get.put(KeyModelDialogController());

    final controller = KeyModelDialogController.to; // 获取控制器实例
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
