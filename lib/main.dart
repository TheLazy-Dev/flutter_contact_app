import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:renrakusen/contact_list/controller/contact_controller.dart';
import 'package:renrakusen/contact_list/views/contact_list.dart';
import 'package:renrakusen/routes.dart';
import 'package:renrakusen/utils/db/db_main.dart';
// import 'package:renrakusen/utils/db/db_main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DB db = DB();
  db.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ContactTableController(),
          lazy: true,
          child: const ContactList(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routes: routes,
            initialRoute: "/",
          );
        },
      ),
    );
  }
}
