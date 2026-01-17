class Users {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String nim;
  final String phone;

  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.nim,
    required this.phone,
    required this.role,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      nim: json['nim'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'nim': nim,
      'phone': phone,
      'role': role,
    };
  }
}
