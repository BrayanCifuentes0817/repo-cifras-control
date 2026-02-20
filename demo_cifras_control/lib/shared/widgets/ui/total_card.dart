import 'package:demo_cifras_control/services/utilities_service.dart';
import 'package:flutter/material.dart';

// Widget que muestra una tarjeta con un título y un valor, con estilo personalizado
class TotalCard extends StatelessWidget {
  final String title; // Título que se muestra en la tarjeta
  final double
  value; // Valor numérico o descriptivo que se muestra debajo del título
  final Color textColor; // Color del texto del título
  final Color numberColor; // Color del número o valor mostrado
  final Color backgroundColor; // Color de fondo de la tarjeta

  // Constructor con parámetros requeridos y un valor por defecto para "mostrar"
  const TotalCard({
    Key? key,
    required this.title,
    required this.value,
    required this.textColor,
    required this.numberColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UtilitiesService utils = UtilitiesService();
    return Card(
      elevation: 4, // Elevación para sombra
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ), // Márgenes exteriores
      color: backgroundColor, // Aplica el color de fondo
      shape: RoundedRectangleBorder(
        // Aplica el color de fondo
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IntrinsicHeight(
        // Asegura que los hijos tengan la misma altura
        child: Row(
          children: [
            // Línea decorativa vertical al lado izquierdo
            Container(
              width: 4, // Grosor de la línea
              decoration: BoxDecoration(
                color: Colors.orange, // Color de la línea
                borderRadius: BorderRadius.only(
                  // Bordes redondeados en las esquinas izquierdas
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
            ),
            // Contenedor principal con el contenido de la tarjeta
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0), // Espaciado interno
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinea a la izquierda
                  children: [
                    // Texto del título, ajustado al tamaño disponible
                    FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown, // Reduce el texto si es necesario
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 0),
                    // Texto del valor o número, también ajustado al ancho disponible
                    FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "${utils.formatNumberCustom(value)}",
                        style: TextStyle(fontSize: 14, color: numberColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
