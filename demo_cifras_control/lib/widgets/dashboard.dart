import 'package:demo_cifras_control/shared/widgets/ui/custom_button.dart';
import 'package:demo_cifras_control/shared/widgets/ui/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:demo_cifras_control/models/cifras_m.dart';
import 'package:demo_cifras_control/services/cifras_service.dart';
import 'package:demo_cifras_control/shared/widgets/ui/total_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  CifrasControlM? _cifras; //Modelo que almacenará la respuesta del servicio.

  bool isLoading =
      false; // Bandera para indicar si se está cargando información.

  // Controladores para manejar el texto de los campos de fecha.
  TextEditingController _fechaAlController = TextEditingController();
  TextEditingController _fechaDelController = TextEditingController();

  // FocusNodes para controlar el foco de los inputs.
  FocusNode _focusFechaDel = FocusNode();
  FocusNode _focusFechaAl = FocusNode();

  // Se ejecuta una sola vez cuando el widget se crea.
  @override
  void initState() {
    super.initState();
  }

  // Se ejecuta cuando el widget se destruye.
  // Aquí liberamos recursos para evitar memory leaks.
  @override
  void dispose() {
    _fechaDelController.dispose();
    _fechaAlController.dispose();
    _focusFechaDel.dispose();
    _focusFechaAl.dispose();
    super.dispose();
  }

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

  // Método principal que construye la interfaz.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior de la pantalla.
      appBar: AppBar(title: const Text("Dashboard Demo")),
      // Cuerpo de la pantalla.
      body: _buildBody(),
    );
  }

  // Método separado para mantener limpio el build principal.
  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 10),

        /// Sección de filtros de fecha.
        Row(
          children: [
            // Campo Fecha Desde.
            Expanded(
              child: CustomInputField(
                label: "Fecha del:",
                controller: _fechaDelController,
                focusNode: _focusFechaDel,
                hintText: "Seleccionar Fecha",
                prefixIcon: Icons.calendar_today,
                // Abre el DatePicker al presionar el ícono.
                onPrefixPressed: () => _seleccionarFecha(
                  controller: _fechaDelController,
                  focusNode: _focusFechaDel,
                ),
                // También lo abre al tocar el campo.
                onTap: () => _seleccionarFecha(
                  controller: _fechaDelController,
                  focusNode: _focusFechaDel,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Campo Fecha Al.
            Expanded(
              child: CustomInputField(
                label: "Fecha al:",
                controller: _fechaAlController,
                focusNode: _focusFechaAl,
                hintText: "Seleccionar Fecha",
                prefixIcon: Icons.calendar_today,
                // Abre el DatePicker al presionar el ícono.
                onPrefixPressed: () => _seleccionarFecha(
                  controller: _fechaAlController,
                  focusNode: _focusFechaAl,
                ),
                // También lo abre al tocar el campo.
                onTap: () => _seleccionarFecha(
                  controller: _fechaAlController,
                  focusNode: _focusFechaAl,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Botón que dispara la consulta.
        BotonGenerico(
          estaCargando: isLoading,
          texto: "Consultar Cifras",
          colorTexto: Colors.white,
          colorFondo: Colors.blue[600],
          onPressed: _cargarCifras,
        ),
        const SizedBox(height: 20),

        /// Si existen cifras, se muestran en pantalla.
        if (_cifras != null) ...[
          // Chip informativo con cantidad de documentos.
          Chip(
            label: Text(
              "Cifras de ${_cifras!.cantidadDocumentos} docs",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
            avatar: const Icon(
              Icons.description,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(height: 20),
          //TARJETAS CON CIFRAS DE CONTROL
          // Tarjeta que muestra el Gran Total.
          TotalCard(
            title: "Gran Total",
            value: _cifras!.granTotal,
            textColor: Colors.black87,
            numberColor: Colors.green,
            backgroundColor: const Color(0xFFF5F5F5),
          ),
          // Tarjeta que muestra el IVA.
          TotalCard(
            title: "IVA",
            value: _cifras!.iva,
            textColor: Colors.black87,
            numberColor: Colors.orange,
            backgroundColor: const Color(0xFFF5F5F5),
          ),
        ],
      ],
    );
  }
}
