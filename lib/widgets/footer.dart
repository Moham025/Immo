import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/action_service.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      color: AppTheme.textMain, // Un fond sombre élégant
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        children: [
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              // Section Marque
              Column(
                crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.real_estate_agent, color: AppTheme.accent, size: 28),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'IMMO-NG',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Votre partenaire de confiance\npour l\'immobilier au Burkina Faso.',
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              if (isMobile) const SizedBox(height: 40),
              
              // Section Contact
              Column(
                crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contactez-nous',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildContactItem(Icons.phone, '+226 07 33 06 86', onTap: () => ActionService.appeler('+22607330686')),
                  const SizedBox(height: 16),
                  _buildContactItem(Icons.language, 'immo.ngniorconception.com'),
                  const SizedBox(height: 16),
                  _buildContactItem(Icons.location_on, 'Ouagadougou, Burkina Faso'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),
          const Divider(color: Colors.white24),
          const SizedBox(height: 24),
          Text(
            '© ${DateTime.now().year} IMMO-NG. Tous droits réservés.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, {VoidCallback? onTap}) {
    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.accent, size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
