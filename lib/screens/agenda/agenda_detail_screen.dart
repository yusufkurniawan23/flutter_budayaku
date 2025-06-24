import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/agenda_provider.dart';
import '../../utils/date_formatter.dart';

class AgendaDetailScreen extends ConsumerWidget {
  final int agendaId;

  const AgendaDetailScreen({super.key, required this.agendaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agendaDetail = ref.watch(agendaDetailProvider(agendaId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: agendaDetail.when(
        data: (agenda) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
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
                      agenda.judul,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.brown[600]!, Colors.brown[800]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.event,
                            size: 100,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        Positioned(
                          bottom: 80,
                          left: 0,
                          right: 0,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildDateInfo(
                                  'Mulai',
                                  DateFormatter.formatDateShort(agenda.tanggalMulai),
                                  Icons.play_arrow,
                                ),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                _buildDateInfo(
                                  'Selesai',
                                  DateFormatter.formatDateShort(agenda.tanggalSelesai),
                                  Icons.stop,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusCard(agenda),
                      const SizedBox(height: 20),
                      _buildInfoCard(agenda),
                      const SizedBox(height: 20),
                      _buildDescriptionCard(agenda),
                      const SizedBox(height: 20),
                      _buildLocationCard(agenda),
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
            title: const Text('Detail Agenda'),
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
                  'Memuat detail agenda...',
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
            title: const Text('Detail Agenda'),
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
                    'Detail agenda tidak dapat dimuat.\nSilakan coba lagi atau kembali ke halaman sebelumnya.',
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
                          ref.invalidate(agendaDetailProvider(agendaId));
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

  Widget _buildDateInfo(String label, String date, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          date,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(agenda) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = DateTime(agenda.tanggalMulai.year, agenda.tanggalMulai.month, agenda.tanggalMulai.day);
    final endDate = DateTime(agenda.tanggalSelesai.year, agenda.tanggalSelesai.month, agenda.tanggalSelesai.day);

    String status;
    Color color;
    IconData icon;
    String description;

    if (today.isBefore(startDate)) {
      status = 'Akan Datang';
      color = Colors.blue;
      icon = Icons.schedule;
      final daysLeft = startDate.difference(today).inDays;
      description = daysLeft == 0 
          ? 'Dimulai hari ini' 
          : daysLeft == 1 
              ? 'Dimulai besok' 
              : 'Dimulai dalam $daysLeft hari';
    } else if (today.isAfter(endDate)) {
      status = 'Selesai';
      color = Colors.grey;
      icon = Icons.event_busy;
      final daysPast = today.difference(endDate).inDays;
      description = daysPast == 1 
          ? 'Berakhir kemarin' 
          : 'Berakhir $daysPast hari yang lalu';
    } else {
      status = 'Sedang Berlangsung';
      color = Colors.green;
      icon = Icons.event_available;
      final daysLeft = endDate.difference(today).inDays;
      description = daysLeft == 0 
          ? 'Berakhir hari ini' 
          : daysLeft == 1 
              ? 'Berakhir besok' 
              : 'Berakhir dalam $daysLeft hari';
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(agenda) {
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
              'Informasi Agenda',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.event,
              'Tanggal Mulai',
              DateFormatter.formatDate(agenda.tanggalMulai),
              Colors.green,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.event_busy,
              'Tanggal Selesai',
              DateFormatter.formatDate(agenda.tanggalSelesai),
              Colors.red,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.access_time,
              'Durasi',
              _calculateDuration(agenda.tanggalMulai, agenda.tanggalSelesai),
              Colors.orange,
            ),
            if (agenda.createdAt != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.calendar_today,
                'Dibuat Pada',
                DateFormatter.formatDate(agenda.createdAt!),
                Colors.purple,
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

  Widget _buildLocationCard(agenda) {
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
                Icon(Icons.location_on, color: Colors.brown[700]),
                const SizedBox(width: 12),
                Text(
                  'Lokasi Acara',
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
              child: Row(
                children: [
                  Icon(
                    Icons.place,
                    color: Colors.brown[600],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      agenda.lokasi,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(agenda) {
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
                  'Deskripsi Agenda',
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
                agenda.deskripsi,
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

  String _calculateDuration(DateTime start, DateTime end) {
    final difference = end.difference(start).inDays + 1;
    if (difference == 1) {
      return '1 hari';
    } else {
      return '$difference hari';
    }
  }
}