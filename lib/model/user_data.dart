class UserData {
  final String name;
  final String email;
  final String phone;
  final String password;

  UserData({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  String toString() {
    return 'UserData(name: $name, email: $email, phone: $phone)';
  }
} 