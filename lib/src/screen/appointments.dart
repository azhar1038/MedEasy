import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medeasy/src/model/notification_model.dart';
import 'package:medeasy/src/resource/database_helper.dart';
import 'package:medeasy/src/resource/notification_helper.dart';
import 'package:medeasy/src/widget/loader.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
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
        appBar: AppBar(title: Text('Appointments')),
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
                        title: 'Appointment',
                        body: title,
                        dateTime: dateTime.millisecondsSinceEpoch,
                        type: 0,
                      ),
                    );
                    await NotificationHelper()
                        .scheduleNotification(id, 'Appointment', title, dateTime);
                    setState(() {});
                  },
                );
              },
            );
          },
        ),
        body: FutureBuilder<List<NotificationModel>>(
          future: DatabaseHelper.instance.queryAllRows(0),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Center(child: Text('Failed to load Appointments'));
              else if (snapshot.hasData) {
                if (snapshot.data.length == 0)
                  return Center(child: Text('No Appointments'));
                else
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(snapshot.data[i].body),
                        subtitle: Text(
                          DateFormat("d MMM yy, hh:mm a").format(
                            DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data[i].dateTime),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            int id = snapshot.data[i].id;
                            await DatabaseHelper.instance.deleteNotification(id);
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
              Text('Title', style: _header),
              SizedBox(height: 8),
              TextFormField(
                controller: _title,
                validator: (s) {
                  if (s.isEmpty) return 'Title cannot be empty';
                  return null;
                },
              ),
              SizedBox(height: 24),
              Text('Choose Date', style: _header),
              SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(DateFormat('d MMM yyyy').format(_dateTime)),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime date = await showDatePicker(
                        context: context,
                        initialDate: _dateTime,
                        firstDate: DateTime(2020, 1, 1),
                        lastDate: DateTime(2020, 12, 31),
                      );
                      setState(() {
                        _dateTime = DateTime(date.year, date.month, date.day,
                            _dateTime.hour, _dateTime.minute, 0);
                      });
                    },
                  ),
                ],
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
                  child: Text('Add'),
                  color: Colors.teal,
                  textColor: Colors.white,
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
