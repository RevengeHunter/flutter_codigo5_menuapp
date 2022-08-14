class UserModel {
  UserModel({
    this.id,
    required this.role,
    required this.email,
    required this.nombre,
    required this.status,
  });

  String? id;
  String role;
  String email;
  String nombre;
  bool status;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    role: json["role"],
    email: json["email"],
    nombre: json["nombre"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role": role,
    "email": email,
    "nombre": nombre,
    "status": status,
  };
}