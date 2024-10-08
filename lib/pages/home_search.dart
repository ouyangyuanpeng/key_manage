import 'package:flutter/material.dart';
import 'package:key_manage/model/key_model.dart';
import 'package:key_manage/widget/key_model_dialog.dart';

class HomeSearch extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // 清空搜索框
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // 关闭搜索
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 可以实现点击建议后显示的内容
    return Center(child: Text("选择了: $query"));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // FutureBuilder 是 Flutter 提供的一个小部件，用于构建基于 Future 的异步数据。它的主要作用是根据异步操作的状态来构建不同的 UI。
    return FutureBuilder<List<KeyModel>>(
      future: KeyModelHelper().searchKeys(query), // 调用搜索方法
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("错误: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("没有找到记录"));
        } else {
          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final key = results[index];
              return ListTile(
                title: Text(key.domain),
                subtitle: Text(key.username),
                onTap: () {
                  showDialog(context: context, builder: (BuildContext context) => KeyModelDialog(
                    k: key,
                  ));

                  // close(context, key.username); // 选择后关闭搜索
                },
              );
            },
          );
        }
      },
    );
  }
}
