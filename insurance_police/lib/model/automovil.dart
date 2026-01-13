class Automovil {
  final int? id;
  final String modelo;
  final double valor;
  final int accidentes;
  final int propietarioId;
  final String? propietarioNombreC;
  Automovil({
    this.id,
    required this.modelo,
    required this.valor,
    required this.accidentes,
    required this.propietarioId,
    this.propietarioNombreC,
  });
  factory Automovil.fromJson(Map<String, dynamic> json) {
    return Automovil(
      id: json['id'],
      modelo: json['modelo'],
      valor: (json['valor'] as num).toDouble(),
      accidentes: json['accidentes'],
      propietarioId: json['propietarioId'],
      propietarioNombreC: json['propietarioNombreC'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'modelo': modelo,
    'valor': valor,
    'accidentes': accidentes,
    'propietarioId': propietarioId,
  };
}
