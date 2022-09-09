import 'package:flutter/material.dart';
import 'package:flutter_db/consts/consts.dart';
import 'package:flutter_db/models/user_model.dart';
import 'package:flutter_db/pages/first/first_page.dart';
import 'package:flutter_db/pages/home/home_page.dart';
import 'package:flutter_db/service/hive_db/hv_service.dart';
import 'package:flutter_db/utils/route/app_router.dart';
import 'package:hive/hive.dart';
/*
Created by Axmadjon Isaqov on 15:34:02 09.09.2022
© 2022 @axi_dev 
*/

/*
Mavzu:::Shared Preferences,Hive 
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hive = HiveServiceRepo();
  Hive.registerAdapter(UserModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      scaffoldMessengerKey: Consts.scaffoldKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        AppRouter.home: (context) => const HomePage(),
        AppRouter.first: (context) => const FirstPage()
      },
      initialRoute: AppRouter.first,
    );
  }
}
