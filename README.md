# repo-cifras-control - Demo Cifras Control – Documentación Técnica

## Índice
1. [Descripción General](#descripción-general)
2. [Arquitectura de la Demo](#-arquitectura-de-la-demo)
3. [Estructura del Proyecto](#-estructura-del-proyecto)
4. [Dependencias](#-dependencias)
5. [Modelo de Datos](#-modelo-de-datos)
6. [Modelo de Respuesta Genérica (ApiResponseM)](#modelo-de-respuesta-genérica-apiresponsem)
7. [Servicios Utilizados](#-servicio-utilizados)
8. [Pantalla Principal – Dashboard](#-pantalla-principal--dashboard)
9. [Widgets Reutilizables](#-widgets-reutilizables)
10. [Instalar dependencias](#instalar-dependencias)
11. [Extensión a Producción](#-extensión-a-producción)

## Descripción General
La demo Cifras Control es una aplicación Flutter que simula la consulta de cifras financieras desde un backend.
El objetivo principal es demostrar:
- Manejo de filtros por fecha
- Consumo de servicios (simulados)
- Uso de modelo de respuesta genérico
- Manejo de estado en Flutter
- Separación de responsabilidades (UI / Modelo / Servicio)

⚠ Esta demo no consume un backend real, sino que simula la respuesta para fines demostrativos.

## 🏗 Arquitectura de la Demo
Separación de responsabilidades:

UI → Presentación y eventos
Service → Lógica de obtención de datos
Models → Representación tipada del JSON
Shared Widgets → Componentes reutilizables

## 📁 Estructura del Proyecto

```text
lib/
│
├── main.dart
│
├── widgets/
│   └── dashboard.dart
│
├── models/
│   ├── cifras_m.dart
│   └── api_response_m.dart
│
├── services/
│   ├── cifras_service.dart
│   └── utilities_service.dart
│
└── shared/
    └── widgets/
        └── ui/
            ├── custom_button.dart
            ├── custom_input_field.dart
            └── total_card.dart
```

## 📦 Dependencias

La demo utiliza únicamente dependencias base de Flutter:
``` yaml
dependencies:
  flutter:
    sdk: flutter
```

## 📊 Modelo de Datos
#### CifrasControlM

Representa la información principal del módulo.

``` dart
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
```

### Responsabilidad 
- Convertir JSON a modelo tipado
- Manejar conversión segura a double

## Modelo de Respuesta Genérica (ApiResponseM)

Modelo reutilizable para estandarizar respuestas del backend.

``` dart
class ApiResponseM<T>
```

### Características
- Uso de genéricos <T>
- Conversión flexible de data
- Manejo de metadata:
  - status
  - message
  - storedProcedure
  - parameters
  - timestamp
  - version
  - errorCode

**Ventajas**

✔ Reutilizable en cualquier módulo
✔ Tipado fuerte
✔ Escalable
✔ Compatible con arquitectura empresarial

## 🌐 Servicio Utilizados

### Servicio CifrasControlService
Clase encargada de simular la obtención de las cifras consumiendo Api.

``` dart
class CifrasControlService
```
#### Método Principal

``` dart
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
```

**Qué hace**
- Construye una URL simulada
- Simula el consumo del endpoint
- Recibe un JSON
- Convierte el JSON a ApiResponseM<CifrasControlM>
- Retorna la respuesta tipada

### Servicio UtilitiesService
Es una clase utilitaria que centraliza funciones reutilizables.
En esta demo, contiene:

``` dart
// Método que recibe un número decimal y lo devuelve
  // formateado como moneda personalizada.
  String formatNumberCustom(double number) {
    // Aquí se podría obtener el símbolo dinámicamente desde la empresa.
    // var empresa = await loginService.getEmpresa();
    // String simbolo = empresa.monedaSimbolo;
    String simbolo = "Q";
    // Convierte el número a string con exactamente 2 decimales.
    // Ejemplo: 25 -> 25.00
    String num = number.toStringAsFixed(2); // Asegura 2 decimales
    List<String> parts = num.split('.'); // Separa enteros de decimales
    String integerPart = parts[0]; // Parte entera antes del punto decimal.
    String decimalPart = parts[1]; // Parte decimal después del punto.

    // Añade comas cada 3 dígitos (por la derecha)
    RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    String formattedInteger = integerPart.replaceAllMapped(
      reg,
      (match) => ',${match.group(0)}',
    );

    //Retorna el número formateado con:
    // - símbolo de moneda
    // - separador de miles
    // - dos decimales
    //Ejemplo final: "Q 1,234.50"
    return '$simbolo $formattedInteger.$decimalPart';
  }
```

## 🖥 Pantalla Principal – Dashboard

Archivo:
```
widgets/dashboard.dart
```
### Es un StatefulWidget.

### Responsabilidades
-  Manejo de filtros de fecha
-  Validación de fechas
-  Manejo de estado (isLoading)
-  Llamado al servicio
-  Renderizado condicional de datos

### Métodos Clave

`_validarFechas()`
Valida que la fecha inicial no sea mayor que la final.
``` dart
  // Método que valida que la fecha inicial no sea mayor que la final.
  bool _validarFechas() {
    final fechaDesdeText = _fechaDelController.text;
    final fechaHastaText = _fechaAlController.text;
    // Solo valida si ambos campos tienen valor.
    if (fechaDesdeText.isNotEmpty && fechaHastaText.isNotEmpty) {
      final fechaDesde = DateTime.parse(fechaDesdeText);
      final fechaHasta = DateTime.parse(fechaHastaText);

      // Si la fecha desde es mayor que la fecha hasta, retorna false.
      if (fechaDesde.isAfter(fechaHasta)) {
        //Mostrar mensaje de error indicando  "La fecha desde no puede ser mayor que la fecha hasta."

        return false;
      }
    }
    return true;
  }
```

`_seleccionarFecha()`
Encapsula la lógica del showDatePicker.
``` dart
//Método reutilizable para mostrar el DatePicker.
  Future<void> _seleccionarFecha({
    required TextEditingController controller,
    required FocusNode focusNode,
  }) async {
    //Muestra el selector de fecha.
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    // Si el usuario selecciona una fecha.
    if (picked != null) {
      setState(() {
        // Formatea la fecha en formato YYYY-MM-DD.
        controller.text = picked.toIso8601String().split('T')[0];
        // Quita el foco del input.
        focusNode.unfocus();
      });
    }
  }
```

`_cargarCifras()`
1. Llama al validar fechas
2. Activa loading
3. Llama al servicio
4. Guarda resultado en _cifras
5. Desactiva loading

``` dart
  /// Método encargado de consumir el servicio y obtener las cifras.
  Future<void> _cargarCifras() async {
    if (!_validarFechas()) return; // Si la validación falla, no continúa.

    setState(() {
      isLoading = true; // Activa el estado de carga.
    });
    try {
      // Llama al servicio que consume la API.
      final response = await CifrasControlService.getCifrasControl(
        context: context,
        fechaInicio: _fechaDelController.text,
        fechaFin: _fechaAlController.text,
      );
      // Guarda la respuesta en el estado.
      setState(() {
        _cifras = response.data;
      });
    } catch (e) {
      // Aquí se llamaría al servicio de reporte de errores
    } finally {
      // Siempre desactiva el loading al finalizar.
      setState(() {
        isLoading = false;
      });
    }
  }
```

### 🧩 Widgets Reutilizables

#### CustomInputField

Campo de texto personalizado con:
- Label
- Icono prefix
- Soporte para FocusNode
- Eventos personalizados

#### BotonGenerico

Botón reutilizable que soporta:
- Estado de carga
- Colores personalizados
- Callback

#### TotalCard

TotalCard es un widget reutilizable de presentación cuyo objetivo es mostrar:
- Un título descriptivo
- Un valor numérico formateado como moneda
- Estilo visual configurable

Este widget se utiliza para representar cifras financieras

##### 🏗 Responsabilidad Arquitectónica

TotalCard pertenece a la capa de UI (Presentación).
Sin embargo, delega la lógica de formateo monetario a:
`UtilitiesService`

Esto es importante porque:
- El widget no contiene lógica financiera
- Se mantiene separación de responsabilidades
- Se evita duplicación de código
- Se mejora mantenibilidad

##### Parámetros del Constructor
| Parámetro | Tipo | Responsabilidad | Ejemplo de Valor |
| :--- | :--- | :--- | :--- |
| **title** | `String` | Texto descriptivo de la cifra | `'Total Documentos'` |
| **value** | `double` | Valor numérico a mostrar | `1450.50` |
| **textColor** | `Color` | Color para la etiqueta del título | `Colors.grey` |
| **numberColor** | `Color` | Color para el valor resaltado | `Color(0xFF2196F3)` |
| **backgroundColor** | `Color` | Color de fondo del contenedor | `Colors.white` |


##### 🔗 Integración con UtilitiesService
Dentro del método build() ocurre algo clave:
`UtilitiesService utils = UtilitiesService();`

##### 🔎 ¿Por qué es importante?

El widget NO muestra directamente el número.
En vez de eso:
- Recibe un double
- Lo envía al servicio utilitario
- Recibe un string ya formateado
- Lo renderiza en pantalla


## Instalar dependencias

``` bash
flutter pub get
```

## 🚀 Extensión a Producción

Para convertir esta demo en un entorno productivo se recomienda:

Reemplazar Servicio Simulado
Usar:
`http`







