import 'dart:convert';

class ApiResponseM<T> {
  bool status;
  String message;
  String error;
  String storedProcedure;
  Map<String, dynamic>? parameters;
  T data;
  DateTime timestamp;
  String version;
  DateTime? releaseDate;
  String errorCode;

  ApiResponseM({
    required this.status,
    required this.message,
    required this.error,
    required this.storedProcedure,
    this.parameters,
    required this.data,
    required this.timestamp,
    required this.version,
    this.releaseDate,
    required this.errorCode,
  });

  factory ApiResponseM.fromJson(
    String str,
    T Function(dynamic json) fromData,
  ) =>
      ApiResponseM.fromMap(json.decode(str), fromData);

  factory ApiResponseM.fromMap(
    Map<String, dynamic> json,
    T Function(dynamic json) fromData,
  ) =>
      ApiResponseM(
        status: json["status"],
        message: json["message"],
        error: json["error"] ?? '',
        storedProcedure: json["storedProcedure"] ?? '',
        parameters: json["parameters"],
        data: fromData(json["data"]),
        timestamp: DateTime.parse(json["timestamp"]),
        version: json["version"],
        releaseDate: json["releaseDate"] != null
            ? DateTime.parse(json["releaseDate"])
            : null,
        errorCode: json["errorCode"] ?? '',
      );

  String toJson(Object Function(T value) toData) => json.encode(toMap(toData));

  Map<String, dynamic> toMap(Object Function(T value) toData) => {
        "status": status,
        "message": message,
        "error": error,
        "storedProcedure": storedProcedure,
        "parameters": parameters,
        "data": toData(data),
        "timestamp": timestamp.toIso8601String(),
        "version": version,
        "releaseDate": releaseDate?.toIso8601String(),
        "errorCode": errorCode,
      };

  Map<String, dynamic> toErrorMap() {
    return {
      "status": status,
      "message": message,
      "error": error,
      "storedProcedure": storedProcedure,
      "parameters": parameters,
      "data": data,
      "timestamp": timestamp.toIso8601String(),
      "version": version,
      "releaseDate": releaseDate?.toIso8601String(),
      "errorCode": errorCode,
    };
  }

  String toErrorJson() => json.encode(toErrorMap());
}
