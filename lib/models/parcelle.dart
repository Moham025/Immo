class Parcelle {
  final String id;
  final String titre;
  final String? quartier;
  final String? ville;
  final num? superficie;
  final num? prix;
  final String? typeDocument;
  final String? description;
  final String statut;
  final List<String> images;
  final String? telephone;
  final String? whatsapp;
  final bool featured;
  final String categorie; // 'parcelle' ou 'maison'

  Parcelle({
    required this.id,
    required this.titre,
    this.quartier,
    this.ville,
    this.superficie,
    this.prix,
    this.typeDocument,
    this.description,
    this.statut = 'disponible',
    this.images = const [],
    this.telephone,
    this.whatsapp,
    this.featured = false,
    this.categorie = 'parcelle',
  });

  factory Parcelle.fromMap(Map<String, dynamic> m) => Parcelle(
        id: m['id'] as String,
        titre: m['titre'] as String? ?? '',
        quartier: m['quartier'] as String?,
        ville: m['ville'] as String?,
        superficie: m['superficie'] as num?,
        prix: m['prix'] as num?,
        typeDocument: m['type_document'] as String?,
        description: m['description'] as String?,
        statut: m['statut'] as String? ?? 'disponible',
        images: (m['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
        telephone: m['telephone'] as String?,
        whatsapp: m['whatsapp'] as String?,
        featured: m['featured'] as bool? ?? false,
        categorie: m['categorie'] as String? ?? 'parcelle',
      );
}
