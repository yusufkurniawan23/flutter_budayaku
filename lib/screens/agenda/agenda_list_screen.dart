import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/agenda.dart';
import '../../../providers/agenda_provider.dart';
import 'agenda_detail_screen.dart';
import 'package:intl/intl.dart';

class AgendaListScreen extends ConsumerStatefulWidget {
  const AgendaListScreen({super.key});

  @override
  ConsumerState<AgendaListScreen> createState() => _AgendaListScreenState();
}

class _AgendaListScreenState extends ConsumerState<AgendaListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan agendaListProvider dari agenda_provider.dart
    final agendas = ref.watch(agendaListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Budaya'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: agendas.when(
              data: (agendaList) {
                if (agendaList.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada agenda yang tersedia'),
                  );
                }

                // Filter agenda berdasarkan pencarian
                final filteredAgendas = _filterAgendas(agendaList);

                if (filteredAgendas.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada agenda yang sesuai dengan filter'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredAgendas.length,
                  itemBuilder: (context, index) {
                    final agenda = filteredAgendas[index];
                    return _buildAgendaCard(agenda);
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
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.secondary,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {}); // Trigger re-build on search
              },
              decoration: InputDecoration(
                hintText: 'Cari agenda...',
                hintStyle: TextStyle(
                  color: Colors.white70,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              // Tindakan untuk tombol filter (jika ada)
            },
            child: const Text('FILTER'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaCard(Agenda agenda) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy', 'id_ID');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Perbaikan: Mengirim ID agenda bukan objek agenda
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AgendaDetailScreen(agendaId: agenda.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with calendar icon and dates
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mulai: ${formatter.format(agenda.tanggalMulai)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Selesai: ${formatter.format(agenda.tanggalSelesai)}',
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agenda.judul,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          agenda.lokasi,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    agenda.deskripsi,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Perbaikan: Mengirim ID agenda bukan objek agenda
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AgendaDetailScreen(agendaId: agenda.id),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility),
                label: const Text('LIHAT DETAIL'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  List<Agenda> _filterAgendas(List<Agenda> agendaList) {
    final query = _searchController.text.toLowerCase();

    return agendaList.where((agenda) {
      final titleMatches = agenda.judul.toLowerCase().contains(query);
      final locationMatches = agenda.lokasi.toLowerCase().contains(query);
      final descriptionMatches = agenda.deskripsi.toLowerCase().contains(query);

      return titleMatches || locationMatches || descriptionMatches;
    }).toList();
  }
}
