import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/seniman_provider.dart'; // Perbaikan path import
import 'package:intl/intl.dart'; // Import untuk format tanggal

class SenimanDetailScreen extends ConsumerWidget {
  final int senimanId;

  const SenimanDetailScreen({super.key, required this.senimanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final senimanDetail = ref.watch(senimanDetailProvider(senimanId));

    return Scaffold(
      body: senimanDetail.when(
        data: (seniman) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    seniman.nama,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        seniman.foto, // Field foto sudah benar
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[700],
                            child: const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0),
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.category),
                                title: const Text('Spesialisasi'),
                                subtitle:
                                    Text(seniman.judul), // Menampilkan judul
                                contentPadding: EdgeInsets.zero,
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.location_on),
                                title: const Text('Alamat'),
                                subtitle:
                                    Text(seniman.alamat), // Menampilkan alamat
                                contentPadding: EdgeInsets.zero,
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: const Text('Kontak'),
                                subtitle: Text(
                                    seniman.nomor), // Menampilkan nomor kontak
                                contentPadding: EdgeInsets.zero,
                              ),
                              if (seniman.createdAt != null) ...[
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.date_range),
                                  title: const Text('Terdaftar Sejak'),
                                  subtitle:
                                      Text(_formatDate(seniman.createdAt!)),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Tentang Seniman',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        seniman.deskripsi, // Menggunakan field deskripsi
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  // Helper method untuk format tanggal
  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }
}
