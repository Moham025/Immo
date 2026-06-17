import 'package:url_launcher/url_launcher.dart';

class ActionService {
  static const String _defaultPhone = '22600000000'; // À remplacer par le numéro global

  static Future<void> ouvrirWhatsApp({
    String? numero,
    required String titreParcelle,
    String? quartier,
  }) async {
    final numStr = numero ?? _defaultPhone;
    final message = 'Bonjour, je suis intéressé par la parcelle "$titreParcelle"'
        '${quartier != null ? " à $quartier" : ""}. Est-elle toujours disponible ?';
    final uri = Uri.parse('https://wa.me/$numStr?text=${Uri.encodeComponent(message)}');
    
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Impossible de lancer WhatsApp');
    }
  }

  static Future<void> appeler(String? numero) async {
    final numStr = numero ?? _defaultPhone;
    final uri = Uri.parse('tel:$numStr');
    
    if (!await launchUrl(uri)) {
      throw Exception('Impossible de lancer l\'appel');
    }
  }
}
