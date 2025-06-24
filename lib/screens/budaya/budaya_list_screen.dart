import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/budaya.dart';
import '../../providers/budaya_provider.dart';
import 'budaya_detail_screen.dart';

class BudayaListScreen extends ConsumerStatefulWidget {
  const BudayaListScreen({super.key});

  @override
  ConsumerState<BudayaListScreen> createState() => _BudayaListScreenState();
}

class _BudayaListScreenState extends ConsumerState<BudayaListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "Semua";

  final List<String> _categories = [
    "Semua",
    "Cagar Budaya",
    "Cagar Alam", 
    "Seni Tradisional",
    "Arsitektur Tradisional",
    "Kuliner Tradisional",
    "Pakaian Adat",
    "Ritual Adat",
    "Kerajinan Tangan"
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final budayaList = ref.watch(budayaListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Kebudayaan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.brown[700],
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: budayaList.when(
              data: (budayas) {
                if (budayas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.museum_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada data kebudayaan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Silakan coba lagi nanti',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final filteredBudayas = _filterBudaya(budayas);

                if (filteredBudayas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada kebudayaan yang sesuai',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          Text(
                            'dengan pencarian "${_searchController.text}"',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        if (_selectedCategory != "Semua")
                          Text(
                            'di kategori "$_selectedCategory"',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(budayaListProvider);
                  },
                  color: Colors.brown[700],
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredBudayas.length,
                    itemBuilder: (context, index) {
                      final budaya = filteredBudayas[index];
                      return _buildBudayaCard(budaya);
                    },
                  ),
                );
              },
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[700]!),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Memuat kebudayaan Indonesia...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              error: (error, stack) => Center(
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
                        'Terjadi Kesalahan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString().replaceAll('Exception: ', ''),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.invalidate(budayaListProvider);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari kebudayaan...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(Icons.search, color: Colors.brown[700]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.brown[700]!, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.brown[700],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.brown[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudayaCard(Budaya budaya) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BudayaDetailScreen(budayaId: budaya.id),
            ),
          );
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    child: _buildImage(budaya),
                  ),
                ),
                
                // Details Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  height: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nama Objek
                      Flexible(
                        child: Text(
                          budaya.namaObjek,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Category Badge dan Tanggal
                      Row(
                        children: [
                          if (budaya.category != null)
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.brown[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  budaya.getCategoryDisplayName(),
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.brown[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                        ],
                      ),
                      
                      // Tanggal
                      Text(
                        budaya.getFormattedDate(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Photo Badge - positioned at top right
            if (budaya.hasPhoto)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Foto',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Budaya budaya) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: budaya.hasPhoto 
          ? Image.network(
              budaya.getFullImageUrl()!, 
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              headers: const {
                'Accept': 'image/*',
                'User-Agent': 'BudayakuApp/1.0',
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[200],
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
                          strokeWidth: 2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Memuat foto...',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                print('❌ Error loading image: ${budaya.getFullImageUrl()} - $error');
                return _buildPlaceholder(budaya);
              },
            )
          : _buildPlaceholder(budaya),
    );
  }

  Widget _buildPlaceholder(Budaya budaya) {
    // Update: Gunakan gradient dan icon yang lebih menarik
    final categoryColors = _getCategoryColors(budaya.getCategoryDisplayName());
    
    return Container(
      width: double.infinity,
      height: double.infinity,
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
          // Icon kategori yang lebih besar
          Text(
            budaya.getCategoryIcon(),
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          
          // Nama objek
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              budaya.namaObjek,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.2,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Kategori badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              budaya.getCategoryDisplayName(),
              style: TextStyle(
                fontSize: 8,
                color: categoryColors[1],
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
        return [Colors.amber[300]!, Colors.amber[600]!];
      case 'cagar alam':
        return [Colors.green[300]!, Colors.green[600]!];
      case 'seni tradisional':
        return [Colors.purple[300]!, Colors.purple[600]!];
      case 'arsitektur tradisional':
        return [Colors.orange[300]!, Colors.orange[600]!];
      case 'kuliner tradisional':
        return [Colors.red[300]!, Colors.red[600]!];
      case 'pakaian adat':
        return [Colors.pink[300]!, Colors.pink[600]!];
      case 'ritual adat':
        return [Colors.indigo[300]!, Colors.indigo[600]!];
      case 'kerajinan tangan':
        return [Colors.teal[300]!, Colors.teal[600]!];
      default:
        return [Colors.brown[300]!, Colors.brown[600]!];
    }
  }

  List<Budaya> _filterBudaya(List<Budaya> budayaList) {
    final query = _searchController.text.toLowerCase().trim();

    return budayaList.where((budaya) {

      final matchesQuery = query.isEmpty ||
          budaya.namaObjek.toLowerCase().contains(query) ||
          budaya.deskripsiClean.toLowerCase().contains(query) ||
          budaya.getCategoryDisplayName().toLowerCase().contains(query);

      // Filter berdasarkan kategori
      final matchesCategory = _selectedCategory == "Semua" ||
          budaya.getCategoryDisplayName() == _selectedCategory;

      return matchesQuery && matchesCategory;
    }).toList();
  }
}