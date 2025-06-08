import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/agenda_provider.dart';

class AgendaDetailScreen extends ConsumerWidget {
  final int agendaId;

  const AgendaDetailScreen({super.key, required this.agendaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Menggunakan agendaDetailProvider dengan ID
    final agendaDetail = ref.watch(agendaDetailProvider(agendaId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Agenda'),
        elevation: 0,
      ),
      body: agendaDetail.when(
        data: (agenda) {
          final DateFormat formatter = DateFormat('dd MMMM yyyy', 'id_ID');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner image
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primary,
                  child: const Center(
                    child: Icon(
                      Icons.event,
                      size: 80,
                      color: Colors.white,
                    ),
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
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),

                      // Info cards
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                context,
                                Icons.calendar_today,
                                'Tanggal',
                                '${formatter.format(agenda.tanggalMulai)} - ${formatter.format(agenda.tanggalSelesai)}',
                              ),
                              const Divider(height: 24),
                              _buildInfoRow(
                                context,
                                Icons.location_on,
                                'Lokasi',
                                agenda.lokasi,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'Tentang Acara',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        agenda.deskripsi,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
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

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
