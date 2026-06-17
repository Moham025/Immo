import 'package:intl/intl.dart';

class Formatters {
  static String formatPrice(num? price) {
    if (price == null) return 'Prix non défini';
    final f = NumberFormat.decimalPattern('fr_FR');
    return '${f.format(price)} FCFA';
  }
}
