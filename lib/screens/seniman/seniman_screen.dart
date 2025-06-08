import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/seniman.dart'; // Perbaikan path import
import '../../providers/seniman_provider.dart'; // Perbaikan path import
import 'seniman_detail_screen.dart';

class SenimanListScreen extends ConsumerStatefulWidget {
  const SenimanListScreen({super.key});

  @override
  ConsumerState<SenimanListScreen> createState() => _SenimanListScreenState();
}

class _SenimanListScreenState extends ConsumerState<SenimanListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final senimanList = ref.watch(senimanListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seniman'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: senimanList.when(
              data: (senimans) {
                if (senimans.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada data seniman'),
                  );
                }

                // Filter seniman berdasarkan pencarian
                final filteredSenimans = _filterSenimans(senimans);

                if (filteredSenimans.isEmpty) {
                  return const Center(
                    child:
                        Text('Tidak ada seniman yang sesuai dengan pencarian'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filteredSenimans.length,
                  itemBuilder: (context, index) {
                    final seniman = filteredSenimans[index];
                    return _buildSenimanCard(seniman);
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari seniman...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (_) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildSenimanCard(Seniman seniman) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // Perbaikan: Mengirim ID seniman bukan objek seniman
              builder: (_) => SenimanDetailScreen(senimanId: seniman.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo
            AspectRatio(
              aspectRatio: 1.0,
              child: Image.network(
                seniman.foto,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 50),
                ),
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    seniman.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Perbaikan: Menggunakan bidang seni alih-alih judul
                  Text(
                    seniman.judul,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Seniman> _filterSenimans(List<Seniman> senimans) {
    final searchQuery = _searchController.text.toLowerCase();

    if (searchQuery.isEmpty) {
      return senimans;
    }

    return senimans.where((seniman) {
      return seniman.nama.toLowerCase().contains(searchQuery) ||
          (seniman.nama.toLowerCase()).contains(searchQuery) ||
          (seniman.judul.toLowerCase()).contains(searchQuery);
    }).toList();
  }
}
