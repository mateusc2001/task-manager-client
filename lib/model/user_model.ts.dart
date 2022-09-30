class UserModel {
  late String id;
  late String firstName;
  late String lastName;
  late String username;

  UserModel(String id, String firstName, String lastName, String username) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.username = username;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    id = json['_id'];
  }
}
