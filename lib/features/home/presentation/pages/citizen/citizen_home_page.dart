import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tashaapp/features/home/cubit/categories_state.dart';
import '../../../../../core/widgets/citizen_floating_nav_bar.dart';
import 'package:tashaapp/features/home/cubit/categories_cubit.dart';

import '../../widgets/home_loading_widget.dart';
import '../../widgets/citizen/citizen_header_section.dart';
import '../../widgets/citizen/citizen_search_section.dart';
import '../../widgets/citizen/citizen_categories_section.dart';
import '../../widgets/citizen/citizen_hidden_gems_section.dart';
import '../../widgets/citizen/citizen_weekend_plans_section.dart';

import 'explore_page.dart';
import 'saved_page.dart';
import '../../../../profile/presentation/pages/profile_page.dart';

import '../../widgets/citizen/citizen_quick_actions.dart';

class CitizenHomePage extends StatefulWidget {
  const CitizenHomePage({super.key});

  @override
  State<CitizenHomePage> createState() => _CitizenHomePageState();
}

class _CitizenHomePageState extends State<CitizenHomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomeContent(),
      const ExplorePage(),
      const SavedPage(),
      const ProfilePage(),
    ];
  }

  Widget _buildHomeContent() {
    return BlocProvider(
      create: (context) => CategoriesCubit()..loadCategories(),
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading || state is CategoriesInitial) {
            return const HomeLoadingWidget();
          }
          final theme = Theme.of(context);
          return Column(
            children: [
              Container(
                height: MediaQuery.paddingOf(context).top + 8,
                color: theme.scaffoldBackgroundColor,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<CategoriesCubit>().loadCategories();
                    // You can add other reloads here if needed
                    await Future.delayed(const Duration(seconds: 1));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CitizenHeaderSection(
                          userName: "Sarah Mitchell",
                          userImage:
                              "https://lh3.googleusercontent.com/aida-public/AB6AXuD2xRjGJBDTCGJcV_7V2mYOvx0ngrourVgu8Fr5MMpEYPY61pw-Ny7VoF4aA66kxUGagh__L7sSsndkRLDoUe9V3YdipBAMDcTvFGv6Kbpfvp46YUs2xfRHdqO4PaQPys_SWbcKc5LI9UrV1G0NMfb1BxshGSnFWelDgc17mprI0VwgrWtTuPwoj3Kkk_M2mwxoGvc2WOFsucrp4jPipTx-QzeP-6B16f7O8QONAmaTguUsyI1TjpnTj4T3Kd2oYCDHm1nlhxv2EOB4",
                        ),
                        const SizedBox(height: 24),
                        const CitizenSearchSection(),
                        const SizedBox(height: 24),
                        const CitizenQuickActions(),
                        const SizedBox(height: 24),
                        CitizenCategoriesSection(
                          onCategorySelected: (category) {
                            // TODO: Implement category filtering if needed
                          },
                        ),
                        const SizedBox(height: 32),
                        const CitizenHiddenGemsSection(),
                        const SizedBox(height: 32),
                        const CitizenWeekendPlansSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          CitizenFloatingNavBar(
            selectedIndex: _selectedIndex,
            onIndexChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}

