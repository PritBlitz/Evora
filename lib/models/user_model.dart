class User {
  final String name;
  final String email;
  final int age;
  final String password;
  final String teamName;
  final String collegeName;

  User({
    required this.name,
    required this.email,
    required this.age,
    required this.password,
    required this.teamName,
    required this.collegeName,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "age": age,
      "password": password,
      "teamName": teamName,
      "collegeName": collegeName,
    };
  }
}
