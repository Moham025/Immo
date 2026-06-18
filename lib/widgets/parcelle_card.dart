import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../models/parcelle.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'fallback_image.dart';

class ParcelleCard extends StatelessWidget {
  final Parcelle parcelle;

  const ParcelleCard({Key? key, required this.parcelle}) : super(key: key);

  Color _getStatusColor() {
    switch (parcelle.statut.toLowerCase()) {
      case 'reserve':
      case 'réservé':
        return AppTheme.statusReserve;
      case 'vendu':
        return AppTheme.statusVendu;
      default:
        return AppTheme.statusDisponible;
    }
  }

  String _getStatusText() {
    switch (parcelle.statut.toLowerCase()) {
      case 'reserve':
        return 'Réservé';
      case 'vendu':
        return 'Vendu';
      default:
        return 'Disponible';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isVendu = parcelle.statut.toLowerCase() == 'vendu';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.go('/parcelle/${parcelle.id}');
        },
        child: Opacity(
          opacity: isVendu ? 0.7 : 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image and Badge
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: parcelle.images.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: parcelle.images.first,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppTheme.background,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppTheme.accent,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => const FallbackImage(),
                              )
                            : const FallbackImage(),
                      ),
                      // Status Badge
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getStatusText(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Infos
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          parcelle.titre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textMain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${parcelle.quartier ?? ''} ${parcelle.ville != null ? '· ${parcelle.ville}' : ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (parcelle.superficie != null)
                              Text(
                                '${parcelle.superficie} m²',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                Formatters.formatPrice(parcelle.prix),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
