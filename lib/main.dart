import 'package:flutter/material.dart';

void main() {
  runApp(const MarketplaceApp());
}

class MarketplaceApp extends StatelessWidget {
  const MarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF2F6FED);

    return MaterialApp(
      title: 'Marketplace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.black87,
        ),
      ),
      home: const HomeShell(),
    );
  }
}

/// Simple data model shared by both pages.
class Person {
  final String name;
  final String subtitle;
  final String category;
  final double rating;
  final Color color;

  const Person({
    required this.name,
    required this.subtitle,
    required this.category,
    required this.rating,
    required this.color,
  });
}

final List<Person> customers = [
  Person(name: 'Amina Yusuf', subtitle: 'Hargeisa • 12 orders', category: 'Retail', rating: 4.8, color: Colors.blue.shade100),
  Person(name: 'Cabdi Warsame', subtitle: 'Burco • 5 orders', category: 'Wholesale', rating: 4.5, color: Colors.orange.shade100),
  Person(name: 'Hodan Ali', subtitle: 'Berbera • 20 orders', category: 'Retail', rating: 4.9, color: Colors.green.shade100),
  Person(name: 'Mohamed Farah', subtitle: 'Hargeisa • 3 orders', category: 'Online', rating: 4.2, color: Colors.purple.shade100),
  Person(name: 'Sahra Ismail', subtitle: 'Erigavo • 8 orders', category: 'Retail', rating: 4.7, color: Colors.pink.shade100),
];

final List<Person> suppliers = [
  Person(name: 'Golden Grain Co.', subtitle: 'Grains & Cereals', category: 'Food', rating: 4.6, color: Colors.amber.shade100),
  Person(name: 'Horn Textiles', subtitle: 'Fabrics & Clothing', category: 'Textiles', rating: 4.3, color: Colors.teal.shade100),
  Person(name: 'Somali Fresh Produce', subtitle: 'Fruits & Vegetables', category: 'Food', rating: 4.8, color: Colors.lightGreen.shade100),
  Person(name: 'BuildRight Materials', subtitle: 'Construction Supplies', category: 'Construction', rating: 4.1, color: Colors.brown.shade100),
  Person(name: 'TechHub Electronics', subtitle: 'Devices & Accessories', category: 'Electronics', rating: 4.5, color: Colors.indigo.shade100),
];

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DirectoryPage(title: 'Customers', people: customers, icon: Icons.people_alt_rounded),
      DirectoryPage(title: 'Suppliers', people: suppliers, icon: Icons.local_shipping_rounded),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people_alt_outlined), selectedIcon: Icon(Icons.people_alt_rounded), label: 'Customers'),
          NavigationDestination(icon: Icon(Icons.local_shipping_outlined), selectedIcon: Icon(Icons.local_shipping_rounded), label: 'Suppliers'),
        ],
      ),
    );
  }
}

class DirectoryPage extends StatefulWidget {
  final String title;
  final List<Person> people;
  final IconData icon;

  const DirectoryPage({
    super.key,
    required this.title,
    required this.people,
    required this.icon,
  });

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.people
        .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(widget.icon, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search ${widget.title.toLowerCase()}...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => PersonCard(person: filtered[i]),
              childCount: filtered.length,
            ),
          ),
        ),
      ],
    );
  }
}

class PersonCard extends StatelessWidget {
  final Person person;

  const PersonCard({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: person.color,
            child: Text(
              person.name.substring(0, 1),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(person.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                Text(person.subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    person.category,
                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  const SizedBox(width: 2),
                  Text(person.rating.toString(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
            ],
          ),
        ],
      ),
    );
  }
}
