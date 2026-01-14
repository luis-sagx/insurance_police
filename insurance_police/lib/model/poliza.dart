class Poliza {
  final String propietario;
  final String modeloAuto;
  final double valorSeguroAuto; // This seems to be "valor" in AutomovilDTO
  final int edadPropietario;
  final int accidentes;
  final double costoTotal; // Calculated cost from SeguroDTO

  Poliza({
    required this.propietario,
    required this.modeloAuto,
    required this.valorSeguroAuto,
    required this.edadPropietario,
    required this.accidentes,
    required this.costoTotal,
  });

  factory Poliza.fromJson(Map<String, dynamic> json) {
    return Poliza(
      propietario: json['propietario'],
      modeloAuto: json['modeloAuto'],
      valorSeguroAuto: (json['valorSeguroAuto'] as num).toDouble(),
      edadPropietario: json['edadPropietario'],
      accidentes: json['accidentes'],
      costoTotal: (json['costoTotal'] as num).toDouble(),
    );
  }
}
