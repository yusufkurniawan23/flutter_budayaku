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
    "Tari",
    "Musik",
    "Upacara",
    "Cerita Rakyat",
    "Kuliner"
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Budaya> _filterBudaya(List<Budaya> budayaList) {
    final query = _searchController.text.toLowerCase();

    return budayaList.where((budaya) {
      final matchesQuery = budaya.namaObjek.toLowerCase().contains(query) ||
          budaya.deskripsi.toLowerCase().contains(query);

      final categoryName = budaya.category?.name.toLowerCase();
      final matchesCategory = _selectedCategory == "Semua" ||
          categoryName == _selectedCategory.toLowerCase();

      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final budayaList = ref.watch(budayaListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kebudayaan'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: budayaList.when(
              data: (budayas) {
                if (budayas.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada data kebudayaan'),
                  );
                }

                // Filter budaya berdasarkan pencarian dan kategori
                final filteredBudayas = _filterBudaya(budayas);

                if (filteredBudayas.isEmpty) {
                  return const Center(
                    child:
                        Text('Tidak ada kebudayaan yang sesuai dengan filter'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filteredBudayas.length,
                  itemBuilder: (context, index) {
                    final budaya = filteredBudayas[index];
                    return _buildBudayaCard(budaya);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari kebudayaan...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BudayaDetailScreen(budayaId: budaya.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: Image.network(
                budaya.foto,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budaya.namaObjek,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        budaya.deskripsi,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (budaya.category != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          budaya.category?.name ?? 'Uncategorized',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
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
}
