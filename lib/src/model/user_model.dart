class UserModel{
  String name;
  String blood;
  String address;
  String photoUrl;
  String email;
  String identification;
  List<String> allergy;
  List<String> medicalHistory;
  List<String> ongoingMedication;

  UserModel.fromMap(Map<String, dynamic> m){
    name = m['name']??'Unknown';
    email = m['email']??'unknown';
    blood = m['blood']??'Unknown';
    address = m['address']??'';
    photoUrl = m['photoUrl']??'';
    identification = m['identification']??'';
    allergy = m['allergy']?.cast<String>()??[];
    medicalHistory = m['medicalHistory']?.cast<String>()??[];
    ongoingMedication = m['ongoingMedication']?.cast<String>()??[];
  }
}