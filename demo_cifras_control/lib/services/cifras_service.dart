import 'dart:async';
import 'package:demo_cifras_control/models/api_response_m.dart';
import 'package:demo_cifras_control/models/cifras_m.dart';
import 'package:flutter/material.dart';

// Cambiar nombre del servicio a nombre del módulo
class CifrasControlService {
  // Nombre del servicio usado para logs y trazabilidad.
  static const String _serviceName = 'CifrasControlService';

  //Método que consulta las cifras del backend.
  static Future<ApiResponseM<CifrasControlM>> getCifrasControl({
    required BuildContext context,
    required String? fechaInicio, // Fecha inicial del filtro.
    required String? fechaFin, // Fecha final del filtro.
  }) async {
    const String methodName =
        'getCifrasControl'; // Nombre del método para logging.
    String baseUrl =
        "https://ds.demosoft.com/host/dev/"; //capturado desde el servicio o sharedPreferences

    // Simulamos construcción de URL
    final url = '$baseUrl/api/cifras-control';
    debugPrint('[$_serviceName - $methodName] GET => $url');

    // Simulamos delay de red
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simulación de latencia de red (2 segundos).

    // Simulación de una respuesta JSON proveniente del backend.
    final Map<String, dynamic> fakeJsonResponse = {
      "status": true,
      "message": "Consulta de cifras exitosa",
      "error": "",
      "storedProcedure": "Pa_ObtenerCifrasControl",
      "parameters": {
        "empresaId": 1,
        "fechaDesde": "2026-01-01",
        "fechaHasta": "2026-01-31",
      },
      "data": {
        "cantidadDocumentos": 145,
        "granTotal": 75230.80,
        "iva": 9027.70,
      },
      "timestamp": DateTime.now().toIso8601String(),
      "version": "1.0.0",
      "releaseDate": DateTime.now().toIso8601String(),
      "errorCode": "",
    };

    // Log de la respuesta.
    debugPrint(
      'Respuesta simulada [$_serviceName - $methodName]: $fakeJsonResponse',
    );

    // Conversión del Map JSON a un modelo tipado ApiResponseM<CifrasControlM>.
    final apiResponse = ApiResponseM<CifrasControlM>.fromMap(
      fakeJsonResponse,
      (data) => CifrasControlM.fromJson(data),
    );

    // Validación de estado.
    // Si la API devuelve status false, se lanza excepción.
    if (!apiResponse.status) {
      throw Exception(apiResponse.message);
    }

    return apiResponse; // Retorna la respuesta tipada.
  }
}
