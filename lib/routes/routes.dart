import 'package:get/get.dart';
import 'package:key_manage/pages/home.dart';
import '../pages/add_key.dart';

class Routes {
  static const String home = "/";
  static const String add = "/add";

  static List<GetPage> pages = <GetPage>[
    GetPage(name: home, page: () => const MyHome(), transition: Transition.zoom),
    GetPage(name: add, page: () => const AddKey())
  ];
}
