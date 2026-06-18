import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/parcelle.dart';
import '../services/action_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/fallback_image.dart';
import '../widgets/footer.dart';

class DetailScreen extends StatefulWidget {
  final String id;

  const DetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _supabase = Supabase.instance.client;
  final PageController _pageController = PageController();
  Parcelle? _parcelle;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchParcelle();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchParcelle() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await _supabase
          .from('parcelles')
          .select()
          .eq('id', widget.id)
          .single();

      setState(() {
        _parcelle = Parcelle.fromMap(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Parcelle introuvable ou erreur de chargement.';
      });
      print('Erreur fetch detail parcelle: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
      );
    }

    if (_errorMessage != null || _parcelle == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppTheme.textSecondary),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Erreur inconnue',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _fetchParcelle,
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
                child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final parcelle = _parcelle!;
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: Text(parcelle.titre),
      ),
      body: isWeb ? _buildWebLayout(parcelle) : _buildMobileLayout(parcelle),
      bottomNavigationBar: isWeb ? null : _buildMobileBottomActions(parcelle),
    );
  }

  Widget _buildWebLayout(Parcelle parcelle) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gallery
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _buildGallery(parcelle),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                // Info & Actions
                Expanded(
                  flex: 4,
                  child: _buildInfoSection(parcelle, showActions: true),
                ),
              ],
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(Parcelle parcelle) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: _buildGallery(parcelle),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildInfoSection(parcelle, showActions: false),
          ),
          const SizedBox(height: 24),
          const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildGallery(Parcelle parcelle) {
    if (parcelle.images.isEmpty) {
      return const FallbackImage();
    }
    
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: parcelle.images.length,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: parcelle.images[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppTheme.background,
                child: const Center(
                  child: CircularProgressIndicator(color: AppTheme.accent),
                ),
              ),
              errorWidget: (context, url, error) => const FallbackImage(),
            );
          },
        ),
        if (parcelle.images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: parcelle.images.map((img) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white70,
                  ),
                );
              }).toList(),
            ),
          ),
        if (parcelle.images.length > 1 && MediaQuery.of(context).size.width > 800) ...[
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                  onPressed: () {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white, size: 32),
                  onPressed: () {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoSection(Parcelle parcelle, {required bool showActions}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                parcelle.titre,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(parcelle.statut),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getStatusText(parcelle.statut),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, color: AppTheme.textSecondary),
            const SizedBox(width: 8),
            Text(
              '${parcelle.quartier ?? 'Quartier non précisé'} ${parcelle.ville != null ? '· ${parcelle.ville}' : ''}',
              style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          Formatters.formatPrice(parcelle.prix),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.accent,
          ),
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        _buildInfoRow('Superficie', parcelle.superficie != null ? '${parcelle.superficie} m²' : 'Non précisée'),
        _buildInfoRow('Type document', parcelle.typeDocument ?? 'Non précisé'),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 24),
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          parcelle.description ?? 'Aucune description fournie.',
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: AppTheme.textSecondary,
          ),
        ),
        if (showActions) ...[
          const SizedBox(height: 40),
          _buildActionButtons(parcelle),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
          Text(value, style: const TextStyle(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildMobileBottomActions(Parcelle parcelle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          )
        ],
      ),
      child: SafeArea(
        child: _buildActionButtons(parcelle),
      ),
    );
  }

  Widget _buildActionButtons(Parcelle parcelle) {
    final bool isAvailable = parcelle.statut.toLowerCase() != 'vendu';

    if (!isAvailable) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Cette parcelle n\'est plus disponible.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => ActionService.appeler(parcelle.telephone),
            icon: const Icon(Icons.phone, color: AppTheme.accent),
            label: const Text('Appeler', style: TextStyle(color: AppTheme.accent)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent.withOpacity(0.1),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => ActionService.ouvrirWhatsApp(
              numero: parcelle.whatsapp,
              titreParcelle: parcelle.titre,
              quartier: parcelle.quartier,
            ),
            icon: const Icon(Icons.chat, color: Colors.white),
            label: const Text('WhatsApp', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.whatsapp,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String statut) {
    switch (statut.toLowerCase()) {
      case 'reserve':
      case 'réservé':
        return AppTheme.statusReserve;
      case 'vendu':
        return AppTheme.statusVendu;
      default:
        return AppTheme.statusDisponible;
    }
  }

  String _getStatusText(String statut) {
    switch (statut.toLowerCase()) {
      case 'reserve':
      case 'réservé':
        return 'Réservé';
      case 'vendu':
        return 'Vendu';
      default:
        return 'Disponible';
    }
  }
}
