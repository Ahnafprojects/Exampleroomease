class UserModel {
  String name;
  String initials;
  String role;
  String dept;
  String email;
  String phone;
  String floor;
  bool isAdmin;

  UserModel({
    required this.name,
    required this.initials,
    required this.role,
    required this.dept,
    required this.email,
    required this.phone,
    required this.floor,
    required this.isAdmin,
  });
}
