import 'package:flutter/material.dart';

/*
  ============================================================
  WIDGET: CustomInputField
  ------------------------------------------------------------
  Este widget representa un campo de texto reutilizable y
  personalizable que se adapta al tema claro u oscuro.
  Permite mostrar íconos, etiquetas, texto de ayuda, 
  y manejar estados como "cargando" o "deshabilitado".

  Ideal para formularios o pantallas donde se requiera
  entrada de texto con estilo consistente en toda la app.

  MODO DE USO:
  ------------------------------------------------------------
  CustomInputField(
    label: 'Correo electrónico',
    hintText: 'Ej: usuario@correo.com',
    controller: miController,
    prefixIcon: Icons.email_outlined,
    onChanged: (valor) => print('Nuevo valor: $valor'),
    onSubmitted: (valor) => enviarFormulario(),
    enabled: true,
    cargando: false,
  )

  Autor: Brayan Cifuentes
  ============================================================
*/
class CustomInputField extends StatelessWidget {
  final String label; // Etiqueta principal del campo
  final String? hintText; // Texto de sugerencia cuando el campo está vacío
  final String? helperText; // Texto de ayuda opcional
  final TextEditingController
  controller; // Controlador que maneja el valor del campo
  final FocusNode? focusNode; // FocusNode del controlador
  final String? initialValue; // Valor inicial del campo
  final IconData? icon; // Ícono principal
  final IconData? prefixIcon; // Ícono al inicio del campo (lado izquierdo)
  final VoidCallback?
  onPrefixPressed; // Función cuando se presiona el ícono inicial
  final IconData? suffixIcon; // Ícono al final del campo (lado derecho)
  final VoidCallback?
  onSuffixPressed; // Función cuando se presiona el ícono final
  final void Function(String)? onChanged; // Callback cuando el texto cambia
  final void Function(String)?
  onSubmitted; // Callback cuando se envía el texto (tecla Enter)
  final VoidCallback? onTap; // Callback para cuando se toque el campo
  final TextInputType keyboardType; // Tipo de teclado a mostrar
  final bool enabled; // Determina si el campo está habilitado o no
  final bool cargando; //Cargando HelperText
  final bool obscureText;
  final String obscuringCharacter;
  final bool enableSuggestions;
  final bool autocorrect;
  final Color? textColorClaro;
  final Color? textColorOscuro;

  // ====== CONSTRUCTOR ======
  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
    this.initialValue,
    this.hintText,
    this.helperText,
    this.icon,
    this.prefixIcon,
    this.onPrefixPressed,
    this.suffixIcon,
    this.onSuffixPressed,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.enabled = true, // Campo habilitado por defecto
    this.cargando = false, // Por defecto no está cargando
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.textColorClaro,
    this.textColorOscuro,
  });

  @override
  Widget build(BuildContext context) {
    // Obtiene el estado actual del tema desde el provider

    // Si hay valor inicial y el controlador está vacío, lo asigna
    if (initialValue != null && controller.text.isEmpty) {
      controller.text = initialValue!;
    }

    // Define el color del texto según si está habilitado y el tema
    final Color textColor = enabled
        ? textColorClaro ?? Colors.blue[900]!
        : Colors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      /*
        TextField principal:
        ------------------------------------------------------------
        Este es el campo de texto donde el usuario puede escribir.
        Se configura su estilo, colores, íconos, bordes y estados.
      */
      child: TextField(
        enabled: enabled, // Controla si el campo puede editarse
        controller: controller, // Controlador de texto
        focusNode: focusNode, // Control de foco
        keyboardType: keyboardType, // Tipo de teclado (texto, numérico, etc.)
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
        enableSuggestions: enableSuggestions,
        autocorrect: autocorrect,
        style: TextStyle(
          color: textColor, // Color del texto según tema/estado
          fontSize: 16,
        ),
        onTap: onTap, // Acción al tocar el campo (si existe)
        decoration: InputDecoration(
          // ====== CONFIGURACIÓN VISUAL DEL CAMPO ======
          hintText: hintText ?? label, // Texto de sugerencia
          hintStyle: TextStyle(color: const Color(0xFF939393), fontSize: 15),
          labelText: label, // Etiqueta flotante
          floatingLabelBehavior:
              FloatingLabelBehavior.auto, // Flota automáticamente
          labelStyle: TextStyle(color: const Color(0xFF939393)),
          helperText: helperText, // Texto auxiliar opcional
          helperStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
          // Ícono a la izquierda (prefixIcon) - (si está habilitado y definido)
          prefixIcon: enabled
              ? (prefixIcon != null
                    ? IconButton(
                        icon: Icon(prefixIcon, color: Colors.blue[300]),
                        onPressed: onPrefixPressed,
                      )
                    : null)
              : Icon(Icons.lock_outline, color: Colors.grey),
          // Ícono a la derecha (suffixIcon), con lógica para limpiar el texto si hay contenido
          /*
            ÍCONO DERECHO (suffixIcon)
            ------------------------------------------------------------
            - Si está cargando → muestra indicador CircularProgress.
            - Si no está habilitado → ícono gris.
            - Si tiene texto → muestra ícono de limpiar (clear).
            - Si no hay texto → muestra el ícono definido por el usuario.
          */
          suffixIcon: cargando
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue[300]!,
                      ),
                    ),
                  ),
                )
              : !enabled
              ? (suffixIcon != null
                    ? Icon(suffixIcon, color: Colors.grey)
                    : null)
              : (controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF64B5F6)),
                        onPressed:
                            onSuffixPressed ??
                            () {
                              controller.clear();
                              if (onChanged != null) onChanged!('');
                            },
                      )
                    : (suffixIcon != null
                          ? IconButton(
                              icon: Icon(suffixIcon, color: Colors.blue[300]),
                              onPressed: onSuffixPressed,
                            )
                          : null)),
          // Espaciado interno del campo
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          // ====== ESTILOS DE BORDES ======
          // Borde cuando el campo está habilitado pero no enfocado
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          ),
          // Borde cuando el campo está deshabilitado
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
          ),
          // Borde cuando el campo está enfocado
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.blue[400]!, width: 1.5),
          ),
          // Color de fondo del campo
          filled: true,
          fillColor: Colors.transparent,
        ),
        cursorColor: Colors.blue[900], // Color del cursor de texto
        onChanged: onChanged, // Eventos de cambio
        onSubmitted: onSubmitted, // Eventos de envío
      ),
    );
  }
}
