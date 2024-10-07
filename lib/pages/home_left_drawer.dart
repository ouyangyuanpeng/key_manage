import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:key_manage/model/key_model.dart';
import 'package:key_manage/utils/aes_utils.dart';

/// 主页左边抽屉
class HomeLeftDrawer extends StatelessWidget {
  const HomeLeftDrawer({super.key});

  /// 侧边抽屉点击方法
  void handleScreenChanged(int index) async{
    final KeyModelHelper dbHelper = KeyModelHelper();

    // 关闭抽屉
    if (index == 0) {
      Clipboard.getData(Clipboard.kTextPlain).then((data) {
        if (data != null && data.text?.isNotEmpty == true) {
          String jsona;
          try{
             jsona = AesUtils.decryptPassword(data.text!);
          }catch(e){
            Fluttertoast.showToast(
              msg: e.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
            return;
          }
          // 解析 JSON 数据
          List<dynamic> jsonData = json.decode(jsona);

          if (jsonData.isNotEmpty) {
            List<KeyModel> users =
                jsonData.map((itme) => KeyModel.fromJson(itme)).toList();
            for (KeyModel model in users) {
              dbHelper.insertKey(model);
            }

            Fluttertoast.showToast(
              msg: "操作成功",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        }
      });
    }else if(index == 1) { // 导出

      dbHelper.getKeys().then((data){
        print(data);
      });
      String str  = json.encode( await dbHelper.getKeys());
      try{
        print(AesUtils.encryptPassword(str));

        Clipboard.setData(ClipboardData(text: AesUtils.encryptPassword(str))).then((_) {
          Fluttertoast.showToast(
            msg: "数据已复制到剪贴板！",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        });


      }catch(e,c){
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: handleScreenChanged,
      selectedIndex: null,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        NavigationDrawerDestination(
          label: Text("导入"),
          icon: Icon(Icons.upload_rounded),
          selectedIcon: Icon(Icons.upload_rounded),
        ),
        NavigationDrawerDestination(
          label: Text("导出"),
          icon: Icon(Icons.download_rounded),
          selectedIcon: Icon(Icons.download_rounded),
        )
      ],
    );
  }
}
