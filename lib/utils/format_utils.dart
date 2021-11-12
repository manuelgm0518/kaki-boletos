import 'package:intl/intl.dart';
import 'package:get/get.dart';

class Validator {
  static String? requiredField(String? value) => (value?.isEmpty ?? true) ? 'Este campo es requerido' : null;

  static String? emailField(String? value) => requiredField(value) ?? (!value!.isEmail ? 'Correo no válido' : null);

  static String? phoneField(String? value) => requiredField(value) ?? (!value!.isPhoneNumber ? 'Número no válido' : null);
}

class DateFormatter {
  static String getVerboseDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(const Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();
    if (!localDateTime.difference(justNow).isNegative) {
      return 'Justo ahora';
    }
    if (localDateTime.day == now.day && localDateTime.month == now.month && localDateTime.year == now.year) {
      return '${"Hoy"} (${DateFormat("hh:mma").format(dateTime)})';
    }
    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (localDateTime.day == yesterday.day && localDateTime.month == now.month && localDateTime.year == now.year) {
      return '${"Ayer"} (${DateFormat("hh:mma").format(dateTime)})';
    }
    return DateFormat('dd / MM / yy (hh:mma)').format(dateTime);
  }
}
