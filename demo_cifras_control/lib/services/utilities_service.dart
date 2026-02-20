// Clase utilitaria que agrupa funciones reutilizables.
//En este caso, sirve para formatear números como moneda.
class UtilitiesService {
  //Servicio de login comentado.
  //En un escenario real se podría usar para obtener
  //el símbolo de moneda desde la empresa logueada.
  //Ej: final LoginService loginService = LoginService();

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
}
