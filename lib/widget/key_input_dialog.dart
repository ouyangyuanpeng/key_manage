import 'package:flutter/material.dart';
import 'package:key_manage/utils/aes_utils.dart';
/// 密钥输入框弹窗
void showKeyInputDialog(BuildContext context) {
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
