import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/parcelle_card.dart';
import '../widgets/footer.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;
  List<Parcelle> _parcelles = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchParcelles();
  }

  Future<void> _fetchParcelles() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final rows = await _supabase
          .from('parcelles')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _parcelles = (rows as List).map((e) => Parcelle.fromMap(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Une erreur est survenue lors du chargement des parcelles.';
      });
      print('Erreur fetch parcelles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Biens immobiliers'),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: AppTheme.accent,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.accent,
            tabs: [
              Tab(text: 'Parcelles'),
              Tab(text: 'Maisons'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBody('parcelle'),
            _buildBody('maison'),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(String categorie) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.accent),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppTheme.textSecondary),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _fetchParcelles,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final filteredParcelles = _parcelles.where((p) {
      final cat = p.categorie.trim().toLowerCase();
      return cat == categorie || cat == '${categorie}s';
    }).toList();

    if (filteredParcelles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(categorie == 'maison' ? Icons.home : Icons.landscape, size: 64, color: AppTheme.textSecondary),
            const SizedBox(height: 16),
            Text(
              categorie == 'maison' 
                  ? 'Aucune maison disponible pour le moment.'
                  : 'Aucune parcelle disponible pour le moment.',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    final featuredParcelles = filteredParcelles.where((p) => p.featured).toList();

    return RefreshIndicator(
      color: AppTheme.accent,
      onRefresh: _fetchParcelles,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (featuredParcelles.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Text(
                  'À la une',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                  ),
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 300.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.85,
                  autoPlayInterval: const Duration(seconds: 5),
                ),
                items: featuredParcelles.map((parcelle) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ParcelleCard(parcelle: parcelle);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
            
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Text(
                'Toutes les parcelles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 3;
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 2;
                  }
                  
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                    ),
                    itemCount: filteredParcelles.length,
                    itemBuilder: (context, index) {
                      return ParcelleCard(parcelle: filteredParcelles[index]);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 64),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
