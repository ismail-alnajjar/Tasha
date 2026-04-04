import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/features/home/cubit/categories_state.dart';
import '../../../../../core/widgets/custom_floating_nav_bar.dart';
import '../../../../../core/widgets/destination_card.dart';
import 'package:tashaapp/features/home/cubit/categories_cubit.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../auth/cubit/auth_cubit.dart';
import '../../../../auth/cubit/auth_state.dart';
import '../../../../../core/routes/app_routes.dart';

import '../../widgets/home_loading_widget.dart';

class TouristHomePage extends StatefulWidget {
  const TouristHomePage({super.key});

  @override
  State<TouristHomePage> createState() => _TouristHomePageState();
}

class _TouristHomePageState extends State<TouristHomePage> {
  String _selectedCategory = 'Popular';

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
      // Proceed with booking (Mock)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Proceeding to booking...")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => CategoriesCubit()..loadCategories(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                if (state is CategoriesLoading || state is CategoriesInitial) {
                  return const HomeLoadingWidget();
                }
                return Column(
                  children: [
                    // Status Bar Spacer
                    Container(
                      height: MediaQuery.of(context).padding.top + 8,
                      color: theme.scaffoldBackgroundColor,
                    ),
                    // Main Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top App Bar
                            _buildTopAppBar(context, appLocalizations),
                            const SizedBox(height: 16),

                            // Hero Search Section
                            _buildSearchSection(context, appLocalizations),
                            const SizedBox(height: 16),

                            // Categories
                            _buildCategories(context, appLocalizations),
                            const SizedBox(height: 24),

                            // Section Header
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
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
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

                            // Destination Cards
                            DestinationCard(
                              title: "Maldives Private Villa",
                              location: "Serene Luxury • North Atoll",
                              price: "\$4,500",
                              rating: 4.9,
                              imageUrl:
                                  "https://lh3.googleusercontent.com/aida-public/AB6AXuDtd6JBYZq9hD6z_KGzY_yEy-qbHuveKbeR15PNTgqv0QoiiYRlVrG4V0l3Lbh8E4fe4Q68n65ZSTbJZZh5PsSjA6hseW2Ma4nv3S-DJ3PbTDr_SMt-9m1EpUmpe91pXBzO9Fan2rYl1Z5prpD7nGQ76PGm-lzhmM732Q3spG81uhC2EmYSUbaUzsHxtfv9s4t_xVgfEKrBd9qrib8MstrmZAup0UQVXKlo6NtGFl7_rMfEWnOKAGpLb5VigUUsMebpNI7NAVxGK08",
                              tag: appLocalizations.translate(
                                'collaborative_choice',
                              ),
                              tagName: appLocalizations.translate(
                                'collaborative_choice',
                              ),
                              showAvatars: true,
                              onBookPressed: () => _handleBookPressed(context),
                            ),
                            DestinationCard(
                              title: "Aman Kyoto Sanctuary",
                              location: "Zen Retreat • Kyoto, Japan",
                              price: "\$2,800",
                              rating: 5.0,
                              imageUrl:
                                  "https://lh3.googleusercontent.com/aida-public/AB6AXuC0iz6npFT9qjeUmekuw4ZhSvGTQihvlF7bdJJmS8RvreXU_8km78eAA1kZpvCubiJy7M32h4u_0QCAIyXI_1lpbvRCPpjnk6fvhPKCSKvZgfeSJZvKyUsAPp_l3b963Xgvsm3kbK7cVvdNfU6NxXynMcd9puxO5RZX9udrZ8LG4u9W_26rQ9Bf-Di5kWTSRdrBt1-GbhHBCDr232FR5BaxVVQPFzHmlt13SPPfi1hlBGksqoTIDyHWcdYSlrL_9deqRXwkkUPrpD8",
                              tag: appLocalizations.translate('trending_now'),
                              tagName: appLocalizations.translate(
                                'cultural_immersion',
                              ),
                              isTrending: true,
                              onBookPressed: () => _handleBookPressed(context),
                            ),
                            DestinationCard(
                              title: "The Alpina Gstaad",
                              location: "Mountain Bliss • Switzerland",
                              price: "\$3,200",
                              rating: 4.8,
                              imageUrl:
                                  "https://lh3.googleusercontent.com/aida-public/AB6AXuCxaxWhiU68gVjQCgshFsN-qKOc9V1CoQzN1XLOLX6CXlcXaLNeEHQkmkrccE3IgDCYuLNmVQn_vZEaSQbHxNbLzoK-B_v9ovzYvixFzySg_2ZuT6lcH8sB-mER26dbErTnFm17JTmKRkNeyWipDt3QTAkyABEi9CLD0WdUsdmzS7T9d3BOBJM5p-U1CNUzlEqtiyNNhS5Gqia8o8W4wk_xMeygsOgefN6SWHkS_fB94-7RiacIrsZd2PNGpRAOokDKlzqXXbPcUzU",
                              tag: appLocalizations.translate('alpine_luxury'),
                              tagName: appLocalizations.translate(
                                'alpine_luxury',
                              ),
                              onBookPressed: () => _handleBookPressed(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            // Custom Navigation Bar
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
          /*
          // Optional: Keep generic title or nothing
          Text(
            "Explore",
             style: GoogleFonts.plusJakartaSans(
                color: theme.colorScheme.secondary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
             ),
          ),
          */
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
        border: Border.all(color: theme.brightness == Brightness.dark ? Colors.white12 : Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: theme.brightness == Brightness.dark ? Colors.black38 : Colors.black12, blurRadius: 2, offset: const Offset(0, 1)),
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
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
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
    // Map category keys to icons
    final categories = [
      {'icon': Icons.bolt, 'key': 'cat_popular'},
      {'icon': Icons.museum, 'key': 'cat_museum'},
      {'icon': Icons.forest, 'key': 'cat_nature'},
      {'icon': Icons.restaurant, 'key': 'cat_foodie'},
      {'icon': Icons.history_edu, 'key': 'cat_history'},
      {'icon': Icons.shopping_bag, 'key': 'cat_shopping'},
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
          final String label = appLocalizations.translate(cat['key'] as String);

          final isSelected =
              _selectedCategory == label ||
              (_selectedCategory == 'Popular' &&
                  label == appLocalizations.translate('cat_popular'));

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = label;
              });
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
