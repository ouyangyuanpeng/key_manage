import 'package:flutter/material.dart';
import 'package:key_manage/utils/aes_utils.dart';
import 'package:key_manage/utils/password_generator.dart';
import 'package:key_manage/model/key_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddKey extends StatefulWidget {
  const AddKey({super.key});

  @override
  _AddKeyState createState() => _AddKeyState();
}

class _AddKeyState extends State<AddKey> {
  final KeyModelHelper dbHelper = KeyModelHelper();
  final TextEditingController domainController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController keyController = TextEditingController();
  bool _obscureTextPassword = true; // 密码可见性状态

  void _submit() {
    String username = usernameController.text;
    String password = passwordController.text;
    String aesKey = keyController.text;
    String domain = domainController.text;

    if (username.isEmpty ||
        password.isEmpty ||
        aesKey.isEmpty ||
        domain.isEmpty) {
      Fluttertoast.showToast(
        msg: '用户名、密码、厂商和密钥不能为空',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    final encrypted = AesUtils.encryptPassword(password, aesKey);

    print('用户名: $username');
    print('密码: $encrypted');
    print('密钥: $aesKey');

    // 清空输入框
    usernameController.clear();
    passwordController.clear();
    keyController.clear();
    domainController.clear();
    dbHelper.insertKey(KeyModel(null, domain, username, encrypted));

    Fluttertoast.showToast(
      msg: '提交成功',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );


  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '新增密码',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.assistant_navigation),
                  labelText: "厂商",
                  border: OutlineInputBorder(),
                  counterText: "", // 隐藏计数器文本
                ),
                controller: domainController,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "用户名",
                    border: OutlineInputBorder(),
                    counterText: "", // 隐藏计数器文本
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: "密码",
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureTextPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureTextPassword = !_obscureTextPassword;
                              });
                            },
                          ),
                          counterText: "",
                        ),
                        obscureText: _obscureTextPassword,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          String newPassword =
                              PasswordGenerator.generateRandomPassword();
                          passwordController.text = newPassword;
                        },
                        child: Text('生成'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: keyController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key),
                          labelText: "密钥",
                          border: OutlineInputBorder(),
                          counterText: "",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          keyController.text = AesUtils.generateAesKey();
                        },
                        child: Text('生成'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text('提交'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
