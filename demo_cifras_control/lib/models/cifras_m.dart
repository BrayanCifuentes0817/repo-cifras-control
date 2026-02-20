// Modelo que representa las cifras obtenidas del backend.
class CifrasControlM {
  final int cantidadDocumentos; // Cantidad de documentos procesados.
  final double granTotal;
  final double iva;

  const CifrasControlM({
    required this.cantidadDocumentos,
    required this.granTotal,
    required this.iva,
  });

  factory CifrasControlM.fromJson(Map<String, dynamic> json) {
    return CifrasControlM(
      cantidadDocumentos: json['cantidadDocumentos'] ?? 0,
      granTotal: _toDouble(json['granTotal']),
      iva: _toDouble(json['iva']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
