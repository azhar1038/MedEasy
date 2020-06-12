class NotificationModel{
  int id;
  String title;
  String body;
  int type;
  int dateTime;

  NotificationModel({this.title, this.body, this.type, this.dateTime});

  NotificationModel.fromMap(Map<String, dynamic> m){
    id = m['id'];
    title = m['title'];
    body = m['body'];
    type = m['type'];
    dateTime = m['dateTime'];
  }
}