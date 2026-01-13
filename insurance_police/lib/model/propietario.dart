class Propietario {
  final int? id;
  final String nombreCompleto;
  final int edad;

  Propietario({this.id, required this.nombreCompleto, required this.edad});

  Map<String, dynamic> toJson() => {
    'nombreCompleto': nombreCompleto,
    'edad': edad,
  };
}
