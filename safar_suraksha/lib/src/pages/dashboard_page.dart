import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock role. Replace with Riverpod auth provider state.
    final isTourist = true;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(onPressed: () => context.goNamed('alerts'), icon: const Icon(Icons.notifications_none)),
          IconButton(onPressed: () => context.goNamed('profile'), icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good day, Traveler', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _SafetyScoreCard(score: 76),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.goNamed('panic'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 14)),
                    icon: const Icon(Icons.sos),
                    label: const Text('PANIC'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.goNamed('liveMap'),
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Live Map'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isTourist) ...[
              _CardSection(
                title: 'Your Tourist ID',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.qr_code_2, size: 40),
                  title: const Text('TID_XXXX1234'),
                  subtitle: const Text('Tap to view QR & details'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.goNamed('touristId'),
                ),
              ),
              const SizedBox(height: 12),
              _CardSection(
                title: 'Trip Details',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Delhi → Agra → Jaipur'),
                    SizedBox(height: 8),
                    Text('Apr 10 - Apr 17'),
                  ],
                ),
              ),
            ] else ...[
              _CardSection(
                title: 'Linked Family Members',
                child: Column(
                  children: const [
                    ListTile(leading: Icon(Icons.person), title: Text('Alice'), subtitle: Text('Safe • 1.2km away')),
                    ListTile(leading: Icon(Icons.person), title: Text('Bob'), subtitle: Text('Caution • 3.4km away')),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SafetyScoreCard extends StatelessWidget {
  final int score;
  const _SafetyScoreCard({required this.score});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (score >= 80) {
      color = Colors.green;
    } else if (score >= 60) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Safety Score', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text('$score/100', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Stay aware in crowded areas at night.', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _CardSection extends StatelessWidget {
  final String title;
  final Widget child;
  const _CardSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}


