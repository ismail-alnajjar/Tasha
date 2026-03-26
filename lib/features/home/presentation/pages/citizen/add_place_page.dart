import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/core/localization/app_localizations.dart';
import 'package:tashaapp/features/home/cubit/hidden_gem_cubit.dart';
import 'package:tashaapp/features/home/cubit/hidden_gem_state.dart';
import 'package:tashaapp/features/home/data/models/hidden_gem_model.dart';
import '../../widgets/shared/base_submission_page.dart';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<File> _images = [];
  Position? _currentPosition;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        context.read<HiddenGemCubit>().getMyHiddenGems();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      final position = await Geolocator.getCurrentPosition();
      setState(() => _currentPosition = position);
    } catch (e) {
      debugPrint("Error location: $e");
    }
  }

  String t(BuildContext context, String key, {String? fallback}) {
    return AppLocalizations.of(context)?.translate(key) ?? (fallback ?? key);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scale = MediaQuery.sizeOf(context).width / 375;

    return Scaffold(
      appBar: AppBar(
        title: Text(t(context, 'suggest_place', fallback: 'Suggest a Place'),
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.primaryColor,
          indicatorColor: theme.primaryColor,
          tabs: [
            Tab(text: t(context, 'suggest_place', fallback: 'Suggest Place')),
            Tab(text: t(context, 'my_places', fallback: 'My Places')),
          ],
        ),
      ),
      body: BlocListener<HiddenGemCubit, HiddenGemState>(
        listener: (context, state) {
          if (state is HiddenGemSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(t(context, 'submitted_successfully'))));
            _nameController.clear();
            _descriptionController.clear();
            setState(() => _images.clear());
            _tabController.animateTo(1);
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildForm(scale, isDark, theme),
            _buildMyPlacesList(scale, isDark, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(double scale, bool isDark, ThemeData theme) {
    return BlocBuilder<HiddenGemCubit, HiddenGemState>(
      builder: (context, state) {
        return BaseSubmissionPage(
          title: 'Suggest hidden gem',
          arabicSubtitle: 'اقترح مكان سياحي غير معروف',
          headerGradient: const [Color(0xFF0F172A), Color(0xFF1E293B)],
          fields: [
            FormFieldConfig(
              label: t(context, 'place_name'),
              hint: t(context, 'enter_place_name'),
              icon: Icons.place,
              controller: _nameController,
            ),
            FormFieldConfig(
              label: t(context, 'description'),
              hint: t(context, 'enter_description'),
              icon: Icons.description,
              controller: _descriptionController,
              maxLines: 4,
            ),
          ],
          selectedImages: _images,
          onImagesChanged: (imgs) => setState(() => _images = imgs),
          supportMultipleImages: true,
          submitButtonText: t(context, 'send'),
          isLoading: state is HiddenGemLoading,
          previewCard: _buildPreview(scale, isDark),
          onSubmit: () {
            context.read<HiddenGemCubit>().sendHiddenGem(
                  name: _nameController.text,
                  description: _descriptionController.text,
                  latitude: _currentPosition?.latitude ?? 0.0,
                  longitude: _currentPosition?.longitude ?? 0.0,
                  photos: _images,
                );
          },
        );
      },
    );
  }

  Widget _buildPreview(double scale, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_nameController.text.isEmpty ? 'Place Name' : _nameController.text,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_descriptionController.text.isEmpty ? 'Description' : _descriptionController.text,
              style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMyPlacesList(double scale, bool isDark, ThemeData theme) {
    return BlocBuilder<HiddenGemCubit, HiddenGemState>(
      builder: (context, state) {
        if (state is HiddenGemLoading) return const Center(child: CircularProgressIndicator());
        if (state is MyHiddenGemsLoaded) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.gems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final gem = state.gems[index];
              return InkWell(
                onTap: () => _showDetails(gem, isDark, theme, scale),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.map, color: theme.primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(gem.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(gem.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('No places found'));
      },
    );
  }

  void _showDetails(HiddenGemModel gem, bool isDark, ThemeData theme, double scale) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(gem.name, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(gem.description),
            if (gem.photoUrls.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: gem.photoUrls.length,
                  itemBuilder: (context, i) => Image.network('http://192.168.1.27:5000${gem.photoUrls[i]}', width: 100),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
