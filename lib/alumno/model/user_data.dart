// Archivo del alumno
// Este archivo es parte del trabajo realizado por el alumno y puede contener modificaciones.

class UserData {
  final String id;
  final String nombre;
  final String email;
  final String telefono;
  final String password; // Considerar hashing en una aplicación real

  UserData({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.password,
  });

  @override
  String toString() {
    return 'UserData(id: $id, nombre: $nombre, email: $email, telefono: $telefono)';
  }

  // Métodos opcionales como toJson/fromJson si son necesarios para persistencia
} 