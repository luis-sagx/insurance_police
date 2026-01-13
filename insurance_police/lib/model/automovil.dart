class Automovil {
  final String modelo;
  final double valor;
  final int accidentes;
  final int propietarioId;

  Automovil({
    required this.modelo,
    required this.valor,
    required this.accidentes,
    required this.propietarioId,
  });

  Map<String, dynamic> toJson() => {
    'modelo': modelo,
    'valor': valor,
    'accidentes': accidentes,
    'propietarioId': propietarioId,
  };
}
