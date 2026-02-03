import 'package:flutter/material.dart';

class TripPlannerPage extends StatefulWidget {
  const TripPlannerPage({super.key});

  @override
  State<TripPlannerPage> createState() => _TripPlannerPageState();
}

class _TripPlannerPageState extends State<TripPlannerPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int _duration = 3;
  // ignore: unused_field
  String _category = 'General';

  // Dummy data simulating the Jordan trip locations seen in the image
  final List<Map<String, dynamic>> _places = [
    {
      "name": "Qahwa BLK - Sport City",
      "type": "Cafe",
      "image": "https://placehold.co/100x100/222/fff?text=BLK",
      "time": "0 min",
    },
    {
      "name": "Qahwa BLK - Abdali Boulevard",
      "type": "Cafe",
      "image": "https://placehold.co/100x100/333/fff?text=BLK",
      "time": "15 min",
    },
    {
      "name": "King Abdullah I Mosque",
      "type": "Religious Site",
      "image": "https://placehold.co/100x100/2cb/fff?text=Mosque",
      "time": "10 min",
    },
    {
      "name": "Temple of Hercules",
      "type": "Historical Site",
      "image": "https://placehold.co/100x100/ec1/fff?text=Temple",
      "time": "20 min",
    },
    {
      "name": "Amman Citadel",
      "type": "Historical Landmark",
      "image": "https://placehold.co/100x100/a31/fff?text=Citadel",
      "time": "5 min",
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _duration = args['duration'] ?? 3;
      _category = args['category'] ?? 'General';
    }
    // Initialize controller if it's null or if length needs to change
    if (_tabController == null || _tabController!.length != _duration + 1) {
      _tabController?.dispose();
      _tabController = TabController(length: _duration + 1, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 16, color: Colors.black),
                    label: const Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Simulated Map View with an Image
                    Image.network(
                      "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/35.9284,31.9454,12,0/600x400?access_token=YOUR_ACCESS_TOKEN",
                      // Fallback placeholder if no internet
                      errorBuilder: (ctx, _, __) => Container(
                        color: const Color(0xFFE0E0E0),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map, size: 50, color: Colors.grey),
                              Text("Map View"),
                            ],
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                    // Gradient overlay for better text visibility if we had title
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black12, Colors.transparent],
                          stops: [0.0, 0.4],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  color: Colors.white,
                  child: _tabController == null
                      ? const Center(child: CircularProgressIndicator())
                      : TabBar(
                          controller: _tabController!,
                          isScrollable: true,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.black,
                          indicatorWeight: 3,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          tabs: [
                            const Tab(text: "Overview"),
                            ...List.generate(
                              _duration,
                              (index) => Tab(text: "Day ${index + 1}"),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ];
        },
        body: _tabController == null
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController!,
                children: [
                  // Overview Tab
                  _buildOverviewTab(),
                  // Day Tabs
                  ...List.generate(_duration, (dayIndex) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      itemCount: _places.length + 1, // +1 for the Header
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Day ${dayIndex + 1}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.tune,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Optimize",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }

                        final place =
                            _places[index - 1]; // adjustment for header
                        return _buildTimelineItem(index, place);
                      },
                    );
                  }),
                ],
              ),
      ),
    );
  }

  Widget _buildTimelineItem(int index, Map<String, dynamic> place) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line & Number
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Container(
                  width: 20,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 16),
                  child: Text(
                    "$index",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey[200],
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 24.0,
                right: 16.0,
                top: 8.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(place['image']),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.category,
                              size: 12,
                              color: Colors.blue[300],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              place['type'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Directions Button & Time
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.directions,
                                    size: 14,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Directions",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (index >
                                1) // Show travel time for items after first
                              Row(
                                children: [
                                  const Icon(
                                    Icons.drive_eta,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    place['time'],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _duration,
      itemBuilder: (context, index) {
        // Create a summary string by joining place names
        // In a real app, this would come from per-day data
        final daySummary = _places.map((e) => e['name']).join(' - ');

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Day ${index + 1}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                daySummary,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
