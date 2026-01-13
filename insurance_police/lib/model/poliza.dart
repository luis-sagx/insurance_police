class Poliza {
  final String propietario;
  final double valorSeguroAuto;
  final String modeloAuto;
  final int accidentes;
  final int edadPropietario;

  Poliza({
    required this.propietario,
    required this.valorSeguroAuto,
    required this.modeloAuto,
    required this.accidentes,
    required this.edadPropietario,
  });

  factory Poliza.fromJson(Map<String, dynamic> json) {
    return Poliza(
      propietario: json['propietario'],
      valorSeguroAuto: (json['valorSeguroAuto'] as num).toDouble(),
      modeloAuto: json['modeloAuto'],
      accidentes: json['accidentes'],
      edadPropietario: json['edadPropietario'],
    );
  }
}
