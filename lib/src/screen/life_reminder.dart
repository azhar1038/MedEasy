import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medeasy/src/model/notification_model.dart';
import 'package:medeasy/src/resource/database_helper.dart';
import 'package:medeasy/src/resource/notification_helper.dart';
import 'package:medeasy/src/widget/loader.dart';

class LifeReminder extends StatefulWidget {
  @override
  _LifeReminderState createState() => _LifeReminderState();
}

class _LifeReminderState extends State<LifeReminder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('image/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('Life Reminder')),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return NewNotification(
                  onSubmit: (title, dateTime) async {
                    int id = await DatabaseHelper.instance.insert(
                      NotificationModel(
                        title: 'Life Reminder',
                        body: title,
                        dateTime: dateTime.millisecondsSinceEpoch,
                        type: 1,
                      ),
                    );
                    await NotificationHelper()
                        .showDailyAtTime(id, 'Life Reminder', title, dateTime);
                    setState(() {});
                  },
                );
              },
            );
          },
        ),
        body: FutureBuilder<List<NotificationModel>>(
          future: DatabaseHelper.instance.queryAllRows(1),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Center(child: Text('Failed to load Reminders'));
              else if (snapshot.hasData) {
                if (snapshot.data.length == 0)
                  return Center(child: Text('No Reminders'));
                else
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(snapshot.data[i].body),
                        subtitle: Text(
                          DateFormat("hh:mm a").format(
                            DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data[i].dateTime),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            int id = snapshot.data[i].id;
                            await DatabaseHelper.instance
                                .deleteNotification(id);
                            await NotificationHelper().cancelNotification(id);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  );
              } else
                return Loader();
            } else
              return Loader();
          },
        ),
      ),
    );
  }
}

class NewNotification extends StatefulWidget {
  final Function(String title, DateTime dateTime) onSubmit;

  const NewNotification({Key key, this.onSubmit}) : super(key: key);

  @override
  _NewNotificationState createState() => _NewNotificationState();
}

class _NewNotificationState extends State<NewNotification> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  DateTime _dateTime = DateTime.now();
  TextStyle _header = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.teal,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.all(24),
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Medicine Name', style: _header),
              SizedBox(height: 8),
              TextFormField(
                controller: _title,
                validator: (s) {
                  if (s.isEmpty) return 'Name cannot be empty';
                  return null;
                },
              ),
              SizedBox(height: 24),
              Text('Choose Time', style: _header),
              SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(DateFormat('hh : mm a').format(_dateTime)),
                  ),
                  IconButton(
                    icon: Icon(Icons.schedule),
                    onPressed: () async {
                      TimeOfDay time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: _dateTime.hour, minute: _dateTime.minute));
                      setState(() {
                        _dateTime = DateTime(_dateTime.year, _dateTime.month,
                            _dateTime.day, time.hour, time.minute, 0);
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
              Center(
                child: RaisedButton(
                  color: Colors.teal,
                  textColor: Colors.white,
                  child: Text('Add'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      widget.onSubmit(_title.text, _dateTime);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
