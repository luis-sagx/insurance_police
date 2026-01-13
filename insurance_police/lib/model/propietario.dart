class Propietario {
  final int? id;
  final String nombreCompleto;
  final int edad;

  Propietario({this.id, required this.nombreCompleto, required this.edad});

  factory Propietario.fromJson(Map<String, dynamic> json) {
    return Propietario(
      id: json['id'],
      nombreCompleto: json['nombreCompleto'],
      edad: json['edad'],
    );
  }

  Map<String, dynamic> toJson() => {
    'nombreCompleto': nombreCompleto,
    'edad': edad,
  };
}
