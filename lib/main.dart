import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quizapp/routes/route_helper.dart';
import 'helpers/dependencies.dart' as dep;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white,
    ));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      getPages: RouteHelper.routes,
      initialRoute: RouteHelper.getInitialPage(),
    );
  }
}
