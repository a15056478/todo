import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:todo_list/components/datetime.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List todoListItmes = [];
  List reminderItems = [];
  String input = "";
  DateTime reminderTime;
  final format = DateFormat("yyyy-MM-dd HH:mm");

  void scheduleAlarm(String input, DateTime reminder) async {
    var scheduleNotificationDateTime = reminder;
    var androidPlatformChannelSpec = AndroidNotificationDetails(
        'id', 'name', 'reminder',
        icon: "@mipmap/ic_launcher");
    var platfromChannleSpecics =
        NotificationDetails(android: androidPlatformChannelSpec);
    await flutterLocalNotificationsPlugin.schedule(0, 'Reminder', input,
        scheduleNotificationDateTime, platfromChannleSpecics);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text("Add totdo list"),
                  content: Container(
                    height: 400,
                    width: 400,
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              input = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter Your TODO',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(children: <Widget>[
                          DateTimeField(
                            onChanged: (value) {
                              setState(() {
                                reminderTime = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Set Reminder',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            format: format,
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );

                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                        ]),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            todoListItmes.add(input);
                            reminderItems.add(reminderTime);
                          });
                          Navigator.of(context).pop();
                          scheduleAlarm(input, reminderTime);
                        },
                        child: Text("ADD")),
                  ],
                );
              });
        },
      ),
      body: ListView.builder(
        itemCount: todoListItmes.length,
        itemBuilder: (context, index) {
          return Dismissible(
              onDismissed: (direction) => print("dismissed"),
              key: Key(todoListItmes[index]),
              child: Container(
                child: Card(
                    elevation: 2,
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    todoListItmes.remove(todoListItmes[index]);
                                    reminderItems.remove(reminderItems[index]);
                                  });
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.share_outlined,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Share.share(
                                      "Hi Please here is my reminder at " +
                                          reminderItems[index].toString() +
                                          " For " +
                                          todoListItmes[index]);
                                }),
                          ],
                        ),
                        ListTile(
                          title: Text(
                            todoListItmes[index],
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: Text(
                              reminderItems[index].toString().split('.').first),
                        ),
                      ],
                    )),
              ));
        },
      ),
    );
  }
}
