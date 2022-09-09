import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? email;
  @HiveField(2)
  int? age;
  @HiveField(3)
  String? password;

  UserModel(
      {required this.name,
      required this.age,
      required this.email,
      required this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'],
      age: json['age'],
      email: json['email'],
      password: json['email']);

  Map<String, dynamic> toJson() =>
      {'name': name, 'age': age, 'email': email, 'password': password};

  UserModel copyWith({
    String? name,
    String? email,
    int? age,
    String? password,
  }) {
    return UserModel(
        name: name ?? this.name,
        age: age ?? this.age,
        email: email ?? this.email,
        password: password ?? this.password);
  }
}
