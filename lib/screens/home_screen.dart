import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/budaya_provider.dart';
import '../providers/seniman_provider.dart';
import '../providers/agenda_provider.dart';
import '../widgets/budaya_card_widget.dart';
import 'agenda/agenda_list_screen.dart';
import 'agenda/agenda_detail_screen.dart';
import 'budaya/budaya_list_screen.dart';
import 'seniman/seniman_screen.dart';
import 'seniman/seniman_detail_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    
    final List<Widget> screens = [
      const _HomeContent(),
      const SenimanListScreen(),
      const BudayaListScreen(),
      const AgendaListScreen(),
    ];

    return Scaffold(
      body: _currentIndex < screens.length
          ? screens[_currentIndex]
          : screens[0], // Fallback ke home jika index tidak valid
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Seniman',
          ),
          NavigationDestination(
            icon: Icon(Icons.museum_outlined),
            selectedIcon: Icon(Icons.museum),
            label: 'Budaya',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Agenda',
          ),
          NavigationDestination(
            icon: Icon(Icons.message_outlined),
            selectedIcon: Icon(Icons.message),
            label: 'Kontak',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budayaList = ref.watch(budayaListProvider);
    final user = ref.watch(authStateProvider).value;

    final featuredSeniman = ref.watch(senimanListProvider);

    final agendas = ref.watch(agendaListProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Budayaku',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://picsum.photos/800/400',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 50),
                      );
                    },
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Implementasi pencarian
                },
              ),
            ],
          ),

          // Greeting
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, ${user?.name ?? 'Pengunjung'}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jelajahi kekayaan budaya Indonesia',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kategori',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryItem(
                          context,
                          'Cagar Budaya',
                          Icons.account_balance,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BudayaListScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        _buildCategoryItem(
                          context,
                          'Cagar Alam',
                          Icons.landscape,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BudayaListScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        _buildCategoryItem(
                          context,
                          'Seniman',
                          Icons.brush,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SenimanListScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        _buildCategoryItem(
                          context,
                          'Agenda',
                          Icons.event,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AgendaListScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Upcoming Agenda
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Agenda Mendatang',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AgendaListScreen(),
                            ),
                          );
                        },
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Display upcoming agendas
                  agendas.when(
                    data: (allAgendas) {
                      if (allAgendas.isEmpty) {
                        return const Center(
                          child: Text("Tidak ada agenda mendatang"),
                        );
                      }

                      // Filter untuk agenda mendatang
                      final now = DateTime.now();
                      final upcomingAgendas = allAgendas
                          .where((agenda) => agenda.tanggalMulai.isAfter(now))
                          .toList()
                        ..sort(
                            (a, b) => a.tanggalMulai.compareTo(b.tanggalMulai));

                      if (upcomingAgendas.isEmpty) {
                        return const Center(
                          child: Text("Tidak ada agenda mendatang"),
                        );
                      }

                      return SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: upcomingAgendas.length > 5
                              ? 5
                              : upcomingAgendas.length,
                          itemBuilder: (context, index) {
                            final agenda = upcomingAgendas[index];
                            return Card(
                              margin: const EdgeInsets.only(right: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                width: 280,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      agenda.judul,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 16),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            agenda.lokasi,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${_formatDate(agenda.tanggalMulai)} - ${_formatDate(agenda.tanggalSelesai)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Navigate to detail with agendaId
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AgendaDetailScreen(
                                              agendaId: agenda.id,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(36),
                                      ),
                                      child: const Text('Lihat Detail'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('Gagal memuat agenda: $error')),
                  ),
                ],
              ),
            ),
          ),

          // Featured Budaya
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Budaya Pilihan',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BudayaListScreen(),
                            ),
                          );
                        },
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Budaya List
          budayaList.when(
            data: (budayas) {
              if (budayas.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text("Tidak ada data budaya")),
                );
              }

              // Hanya tampilkan maksimal 5 data di halaman utama
              final displayedBudayas =
                  budayas.length > 5 ? budayas.sublist(0, 5) : budayas;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return BudayaCard(budaya: displayedBudayas[index]);
                  },
                  childCount: displayedBudayas.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverToBoxAdapter(
              child: Center(
                child: Text('Error: $error'),
              ),
            ),
          ),

          // Featured Seniman
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seniman Terpilih',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SenimanListScreen(),
                            ),
                          );
                        },
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Display featured artists
                  featuredSeniman.when(
                    data: (senimans) {
                      if (senimans.isEmpty) {
                        return const Center(
                            child: Text("Tidak ada data seniman"));
                      }

                      // Ambil 5 seniman pertama
                      final displayedSenimans = senimans.length > 5
                          ? senimans.sublist(0, 5)
                          : senimans;

                      return SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: displayedSenimans.length,
                          itemBuilder: (context, index) {
                            final seniman = displayedSenimans[index];
                            return InkWell(
                              onTap: () {
                                // Navigate to seniman detail screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SenimanDetailScreen(
                                      senimanId: seniman.id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 12),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(seniman
                                              .foto.isNotEmpty
                                          ? seniman.foto
                                          : 'https://via.placeholder.com/80'),
                                      onBackgroundImageError: (_, __) {},
                                      child: seniman.foto.isEmpty
                                          ? const Icon(Icons.person, size: 40)
                                          : null,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      seniman.nama,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      seniman.judul, // Spesialisasi seniman
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                        child: Text('Gagal memuat data seniman: $error')),
                  ),
                ],
              ),
            ),
          ),

          // Footer
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: const Center(
                child: Text(
                  '© 2025 Budayaku - Aplikasi Budaya Indonesia',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    try {
      final formatter = DateFormat('dd MMM yyyy');
      return formatter.format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }
}
