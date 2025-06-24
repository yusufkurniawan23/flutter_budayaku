import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/budaya_provider.dart';
import '../../utils/date_formatter.dart';

class BudayaDetailScreen extends ConsumerWidget {
  final int budayaId;

  const BudayaDetailScreen({super.key, required this.budayaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budayaDetail = ref.watch(budayaDetailProvider(budayaId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: budayaDetail.when(
        data: (budaya) {
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, budaya),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryAndDateChips(context, budaya),
                      const SizedBox(height: 24),
                      _buildAboutSection(context, budaya),
                      const SizedBox(height: 20),
                      _buildInfoSection(context, budaya),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => Scaffold(
          appBar: AppBar(
            title: const Text('Detail Budaya'),
            backgroundColor: Colors.brown[700],
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[700]!),
                ),
                const SizedBox(height: 16),
                Text(
                  'Memuat detail kebudayaan...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        error: (error, stack) => Scaffold(
          appBar: AppBar(
            title: const Text('Detail Budaya'),
            backgroundColor: Colors.brown[700],
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Data Tidak Ditemukan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Detail kebudayaan tidak dapat dimuat.\nSilakan coba lagi atau kembali ke halaman sebelumnya.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.invalidate(budayaDetailProvider(budayaId));
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Kembali'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.brown[700],
                          side: BorderSide(color: Colors.brown[700]!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, budaya) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.brown[700],
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            budaya.namaObjek,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildHeroImage(budaya),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage(budaya) {
    return budaya.hasPhoto
        ? Image.network(
            budaya.getFullImageUrl()!, 
            fit: BoxFit.cover,
            headers: const {
              'Accept': 'image/*',
              'User-Agent': 'BudayakuApp/1.0',
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.brown[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[700]!),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Memuat foto...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print('❌ Error loading hero image: ${budaya.getFullImageUrl()}');
              print('❌ Error details: $error');
              return _buildPlaceholderHero(budaya);
            },
          )
        : _buildPlaceholderHero(budaya);
  }

  Widget _buildPlaceholderHero(budaya) {
    final categoryColors = _getCategoryColors(budaya.getCategoryDisplayName());
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: categoryColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon kategori besar
          Text(
            budaya.getCategoryIcon(),
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 16),
          
          // Nama objek
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              budaya.namaObjek,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              budaya.getCategoryDisplayName(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk mendapatkan warna berdasarkan kategori
  List<Color> _getCategoryColors(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'cagar budaya':
        return [Colors.amber[400]!, Colors.amber[700]!];
      case 'cagar alam':
        return [Colors.green[400]!, Colors.green[700]!];
      case 'seni tradisional':
        return [Colors.purple[400]!, Colors.purple[700]!];
      case 'arsitektur tradisional':
        return [Colors.orange[400]!, Colors.orange[700]!];
      case 'kuliner tradisional':
        return [Colors.red[400]!, Colors.red[700]!];
      case 'pakaian adat':
        return [Colors.pink[400]!, Colors.pink[700]!];
      case 'ritual adat':
        return [Colors.indigo[400]!, Colors.indigo[700]!];
      case 'kerajinan tangan':
        return [Colors.teal[400]!, Colors.teal[700]!];
      default:
        return [Colors.brown[400]!, Colors.brown[700]!];
    }
  }

  Widget _buildCategoryAndDateChips(BuildContext context, budaya) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (budaya.category != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.brown[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.brown[300]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 16,
                  color: Colors.brown[700],
                ),
                const SizedBox(width: 6),
                Text(
                  budaya.getCategoryDisplayName(),
                  style: TextStyle(
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue[300]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: Colors.blue[700],
              ),
              const SizedBox(width: 6),
              Text(
                budaya.getFormattedDate(),
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, budaya) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.brown[700]),
                const SizedBox(width: 12),
                Text(
                  'Tentang ${budaya.namaObjek}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                budaya.deskripsiClean,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, budaya) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Detail',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
            const SizedBox(height: 16),
            if (budaya.category != null) ...[
              _buildInfoRow(
                Icons.category,
                'Kategori',
                budaya.getCategoryDisplayName(),
                Colors.purple,
              ),
              const Divider(height: 24),
            ],
            _buildInfoRow(
              Icons.calendar_month,
              'Tanggal Penetapan',
              budaya.getFormattedDate(),
              Colors.blue,
            ),
            if (budaya.createdAt != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.add_circle_outline,
                'Ditambahkan Pada',
                DateFormatter.formatDate(budaya.createdAt!),
                Colors.green,
              ),
            ],
            if (budaya.updatedAt != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.update,
                'Terakhir Diperbarui',
                DateFormatter.formatDateTime(budaya.updatedAt!),
                Colors.orange,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}