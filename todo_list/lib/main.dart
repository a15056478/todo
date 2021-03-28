import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_list/screens.dart/home_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializeSettingAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  var initializeSettings =
      InitializationSettings(android: initializeSettingAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializeSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload:' + payload);
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}
