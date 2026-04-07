import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/features/home/cubit/tourist_cubit.dart';
import 'package:tashaapp/features/home/cubit/tourist_state.dart';
import 'package:tashaapp/features/home/data/models/place_model.dart';
import '../../../../../core/widgets/custom_floating_nav_bar.dart';
import '../../../../../core/widgets/destination_card.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../auth/cubit/auth_cubit.dart';
import '../../../../auth/cubit/auth_state.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../widgets/citizen/trip_reviews_sheet.dart';
import 'visiting_citizen_page.dart';

class TouristHomePage extends StatefulWidget {
  const TouristHomePage({super.key});

  @override
  State<TouristHomePage> createState() => _TouristHomePageState();
}

class _TouristHomePageState extends State<TouristHomePage> {
  String _selectedCategoryKey = 'popular';

  @override
  void initState() {
    super.initState();
  }

  void _handleBookPressed(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated && authState.userType == 'guest') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Registration Required"),
          content: const Text(
            "You need to sign in or register to book a trip.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              child: const Text("Sign In"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Proceeding to booking...")));
    }
  }

  void _showPlaceDetailsBottomSheet(BuildContext context, PlaceModel place) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  child: Image.network(
                    place.imageUrl ?? "https://via.placeholder.com/400x250",
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                place.rating.toString(),
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          place.location,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "About this place",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            TripReviewsSheet.show(context, place.id);
                          },
                          icon: const Icon(
                            Icons.rate_review_outlined,
                            size: 18,
                          ),
                          label: const Text("See Reviews"),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFF97316),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          place.description.isEmpty
                              ? "Experience the unique beauty of ${place.name}. A perfect destination for tourists seeking adventure and culture."
                              : place.description,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.grey[600],
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCitizenHostingBanner(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VisitingCitizenPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE75B04), Color(0xFFF97316)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE75B04).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations.translate('Visit a citizen'),
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Meet locals, share culture, and experience Jordan like a citizen.",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Explore Hosts",
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFE75B04),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_alt_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => TouristCubit()..fetchTouristPlaces('popular'),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top + 8,
                  color: theme.scaffoldBackgroundColor,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopAppBar(context, appLocalizations),
                        const SizedBox(height: 16),
                        _buildSearchSection(context, appLocalizations),
                        const SizedBox(height: 24),
                        _buildCitizenHostingBanner(context, appLocalizations),
                        const SizedBox(height: 24),
                        _buildCategories(context, appLocalizations),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appLocalizations.translate(
                                'popular_destinations',
                              ),
                              style: GoogleFonts.plusJakartaSans(
                                color: theme.colorScheme.secondary,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                appLocalizations.translate('see_all'),
                                style: GoogleFonts.plusJakartaSans(
                                  color: theme.colorScheme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<TouristCubit, TouristState>(
                          builder: (context, state) {
                            if (state is TouristLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is TouristError) {
                              return Center(
                                child: Text('Error: ${state.message}'),
                              );
                            } else if (state is TouristLoaded) {
                              if (state.places.isEmpty) {
                                return const Center(
                                  child: Text('No places found.'),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.places.length,
                                itemBuilder: (context, index) {
                                  final place = state.places[index];
                                  return GestureDetector(
                                    onTap: () => _showPlaceDetailsBottomSheet(
                                      context,
                                      place,
                                    ),
                                    child: DestinationCard(
                                      title: place.name,
                                      location: place.location,
                                      price: "View Details",
                                      rating: place.rating,
                                      imageUrl:
                                          place.imageUrl ??
                                          "https://via.placeholder.com/400x250",
                                      tag: place.category,
                                      tagName: place.category,
                                      showAvatars: true,
                                      onBookPressed: () =>
                                          _handleBookPressed(context),
                                    ),
                                  );
                                },
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const CustomFloatingNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    final theme = Theme.of(context);
    final authState = context.watch<AuthCubit>().state;
    final isGuest =
        authState is AuthAuthenticated && authState.userType == 'guest';

    if (isGuest) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            icon: const Icon(Icons.login, size: 18),
            label: const Text("Login"),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.primaryColor.withOpacity(0.2),
              width: 2,
            ),
            image: const DecorationImage(
              image: NetworkImage(
                "https://lh3.googleusercontent.com/aida-public/AB6AXuAoazFhIk1282TBMkuDHkjXCapzifptDABJw93XX29mcK_RjDPy6wxi2kX9rhALrAsinDqC8vrsS7uJzC6Ycx-_duLHbauHrqLKVpnh-yoU8bXMichEwKCymzK2hDPc-qf2n5fXc1f97VAkbWahkGde7-tJjbHXPMe98DTcfR5erWGjM9KcTn4wKTjochon0JITMd2dD99nnCrk7sEzHp4hZytCKJz4nzARcW_BIWo5JZuvj2zHKjNWxQBEFZXAa9z_YZUYMmUbF6w",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appLocalizations.translate('welcome_back'),
                style: GoogleFonts.plusJakartaSans(
                  color: theme.primaryColor.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                "Alex Thompson",
                style: GoogleFonts.plusJakartaSans(
                  color: theme.colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSection(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    final theme = Theme.of(context);
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.white12
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black38
                : Colors.black12,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Icon(Icons.search, color: theme.colorScheme.primary),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: appLocalizations.translate('search_places'),
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              style: GoogleFonts.plusJakartaSans(
                color: theme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.tune, color: theme.colorScheme.secondary),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    final categories = [
      {'icon': Icons.bolt, 'key': 'cat_popular', 'api': 'popular'},
      {'icon': Icons.people_outline, 'key': 'cat_citizen', 'api': 'citizen'},
      {'icon': Icons.museum, 'key': 'cat_museum', 'api': 'museums'},
      {'icon': Icons.forest, 'key': 'cat_nature', 'api': 'nature'},
      {'icon': Icons.restaurant, 'key': 'cat_foodie', 'api': 'food-drink'},
      {'icon': Icons.history_edu, 'key': 'cat_history', 'api': 'history'},
      {'icon': Icons.shopping_bag, 'key': 'cat_shopping', 'api': 'shopping'},
    ];

    final theme = Theme.of(context);

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final String key = cat['key'] as String;
          final String label = appLocalizations.translate(key);
          final isSelected = _selectedCategoryKey == key;

          return GestureDetector(
            onTap: () {
              if (key == 'cat_citizen') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VisitingCitizenPage(),
                  ),
                );
                return;
              }
              setState(() {
                _selectedCategoryKey = key;
              });
              context.read<TouristCubit>().fetchTouristPlaces(
                cat['api'] as String,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE75B04) : theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? null
                    : Border.all(color: theme.dividerColor.withOpacity(0.1)),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFE75B04).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurface,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
