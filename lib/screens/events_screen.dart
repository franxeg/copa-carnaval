import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return BottomNav(
      currentIndex: 4,
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Eventos'),
            bottom: TabBar(
              isScrollable: false,
              tabs: List.generate(
                  6, (i) => Tab(text: '${25 + i} Dic')),
              labelColor: AppTheme.primaryYellow,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryYellow,
            ),
          ),
          body: TabBarView(
            children: List.generate(6, (day) {
              final events = provider.getEventsByDay(day + 1);
              if (events.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy,
                          size: 64, color: Colors.grey.shade600),
                      const SizedBox(height: 16),
                      Text('Sin eventos para el ${25 + day} de diciembre',
                          style: TextStyle(color: Colors.grey.shade400)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: events.length,
                itemBuilder: (_, i) {
                  final e = events[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryYellow.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.event,
                                color: AppTheme.primaryYellow),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.title,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(e.description,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                                if (e.location != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(e.location!,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13)),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
