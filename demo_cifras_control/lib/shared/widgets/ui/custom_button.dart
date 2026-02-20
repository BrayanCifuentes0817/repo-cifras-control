import 'package:flutter/material.dart';

/// **********************************************************************************************
/// WIDGET: BotonGenerico
/// **********************************************************************************************
/// Descripción:
/// Este widget representa un botón reutilizable y altamente configurable para Flutter.
/// Permite personalizar su texto, colores, ícono, tamaño, bordes, y estado (activo, cargando o deshabilitado).
///
/// Uso común:
/// ```dart
/// BotonGenerico(
///   texto: 'Guardar',
///   onPressed: () => print('Botón presionado'),
///   icono: Icons.save,
///   colorFondo: Colors.green,
///   estaCargando: false,
/// )
/// ```
///
/// Propósito:
/// Facilitar la creación de botones uniformes dentro de una aplicación, sin necesidad
/// de reescribir estilos o comportamientos comunes.
/// Autor: Brayan Cifuentes
/// **********************************************************************************************

class BotonGenerico extends StatelessWidget {
  final String texto; // Texto que se muestra dentro del botón
  final VoidCallback?
      onPressed; // Callback que se ejecuta al presionar el botón (puede ser null para deshabilitar)
  final bool
      estaCargando; // Indica si se debe mostrar un indicador de carga en lugar del contenido
  final bool
      estaDeshabilitado; // Indica si el botón está deshabilitado (sin interacción)
  final IconData?
      icono; // Icono opcional que se muestra a la izquierda del texto
  final Color? colorFondo; // Color de fondo del botón
  final Color? colorTexto; // Color del texto del botón
  final Color? colorIcono; // Color del icono del botón (si se usa)
  final double? ancho; // Ancho fijo del botón (opcional)
  final double? alto; // Alto fijo del botón (por defecto 48)
  final BorderRadius? bordes; // Bordes redondeados del botón
  final TextStyle? estiloTexto; // Estilo de texto personalizado
  final EdgeInsetsGeometry?
      padding; // Espaciado interior (padding) del contenido del botón

  const BotonGenerico({
    Key? key,
    required this.texto,
    this.onPressed,
    this.estaCargando = false,
    this.estaDeshabilitado = false,
    this.icono,
    this.colorFondo,
    this.colorTexto,
    this.colorIcono,
    this.ancho,
    this.alto,
    this.bordes,
    this.estiloTexto,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determina si el botón es interactivo:
    // debe tener callback, no estar deshabilitado ni en carga
    final bool interactivo =
        onPressed != null && !estaDeshabilitado && !estaCargando;

    return SizedBox(
      width: ancho, // Aplica el ancho definido o usa el tamaño del contenido
      height: alto ?? 48, // Altura por defecto de 48 si no se especifica
      child: ElevatedButton(
        onPressed: interactivo
            ? onPressed
            : null, // Si no es interactivo, el botón se desactiva (onPressed: null)
        // Estilos visuales del botón (color, bordes, padding, etc.)
        style: ElevatedButton.styleFrom(
          backgroundColor: colorFondo ?? Theme.of(context).primaryColor,
          foregroundColor: colorTexto ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: bordes ?? BorderRadius.circular(12),
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          elevation: 2, // Sombra leve para resaltar el botón
        ),
        // Si está cargando, muestra un spinner; si no, el contenido normal (texto + ícono)
        child: estaCargando
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Si hay ícono, se muestra a la izquierda del texto
                  if (icono != null) ...[
                    Icon(icono,
                        color: colorIcono ?? colorTexto ?? Colors.white),
                    const SizedBox(width: 8), // Espaciado entre ícono y texto
                  ],
                  // Texto del botón
                  Flexible(
                    child: Text(
                      texto,
                      style: estiloTexto ??
                          const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
