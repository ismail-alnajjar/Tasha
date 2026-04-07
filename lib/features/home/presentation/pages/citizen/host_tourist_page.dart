import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tashaapp/core/services/location_service.dart';
import 'package:tashaapp/features/home/cubit/local_host_cubit.dart';
import 'package:tashaapp/features/home/cubit/local_host_state.dart';
import 'package:tashaapp/features/home/data/models/local_host_model.dart';
import '../../widgets/shared/base_submission_page.dart';

class HostTouristPage extends StatefulWidget {
  const HostTouristPage({super.key});

  @override
  State<HostTouristPage> createState() => _HostTouristPageState();
}

class _HostTouristPageState extends State<HostTouristPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _activitiesController = TextEditingController();
  
  Position? _currentPosition;
  bool _isLocating = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        context.read<LocalHostCubit>().getMyOffers();
      }
    });
    _getCurrentLocation();
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLocating = true);
    final pos = await LocationService.getCurrentLocation();
    if (mounted) {
      setState(() {
        _currentPosition = pos;
        _isLocating = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _activitiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Become a Local Host', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFD4AF37),
          labelColor: const Color(0xFFD4AF37),
          tabs: const [
            Tab(text: 'تقديم عرض / Host'),
            Tab(text: 'عروضي / My Offers'),
          ],
        ),
      ),
      body: BlocListener<LocalHostCubit, LocalHostState>(
        listener: (context, state) {
          if (state is LocalHostSuccess) {
            _showSuccessDialog(context, isDark, theme);
            _tabController.animateTo(1);
          } else if (state is LocalHostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildFormTab(isDark, theme),
            _buildMyOffersTab(isDark, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFormTab(bool isDark, ThemeData theme) {
    return BlocBuilder<LocalHostCubit, LocalHostState>(
      builder: (context, state) {
        return BaseSubmissionPage(
          title: 'Become a Local Host',
          arabicSubtitle: 'كن سفيراً لبلدك بكرمك',
          headerGradient: const [Color(0xFF134E4A), Color(0xFFD4AF37)],
          fields: [
            FormFieldConfig(
              label: 'عنوان العرض / Title',
              hint: 'مثلاً: جولة في السلط القديمة',
              icon: Icons.title,
              controller: _titleController,
            ),
            FormFieldConfig(
              label: 'المدينة / City',
              hint: 'عمان، السلط، عجلون...',
              icon: Icons.location_city,
              controller: _cityController,
            ),
            FormFieldConfig(
              label: 'الأنشطة / Activities',
              hint: 'مشي، طبخ منسف، زيارة متاحف...',
              icon: Icons.local_activity,
              controller: _activitiesController,
            ),
            FormFieldConfig(
              label: 'رقم الهاتف / Phone',
              hint: '07XXXXXXXX',
              icon: Icons.phone,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            FormFieldConfig(
              label: 'الوصف / Description',
              hint: 'احكِ قصتك.. ماذا ستقدم للسياح؟',
              icon: Icons.description,
              controller: _descController,
              maxLines: 4,
            ),
          ],
          selectedImages: const [], 
          onImagesChanged: (_) {},
          supportMultipleImages: false,
          submitButtonText: _isLocating ? 'Capturing Location...' : 'نشر العرض / Post My Offer',
          isLoading: (state is LocalHostLoading && _tabController.index == 0) || _isLocating,
          previewCard: _buildPreview(isDark),
          locationWidget: _buildLocationButton(isDark, theme),
          onSubmit: () {
            context.read<LocalHostCubit>().submitOffer(
                  title: _titleController.text,
                  description: _descController.text,
                  phone: _phoneController.text,
                  city: _cityController.text,
                  activities: _activitiesController.text,
                  latitude: _currentPosition?.latitude ?? 0.0,
                  longitude: _currentPosition?.longitude ?? 0.0,
                );
          },
        );
      },
    );
  }

  Widget _buildMyOffersTab(bool isDark, ThemeData theme) {
    return BlocBuilder<LocalHostCubit, LocalHostState>(
      builder: (context, state) {
        if (state is LocalHostLoading && _tabController.index == 1) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MyLocalHostsLoaded) {
          final models = state.models;
          if (models.isEmpty) {
             return Center(child: Text('لا يوجد عروض حالياً', style: GoogleFonts.cairo()));
          }
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<LocalHostCubit>().getMyOffers();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: models.length,
              itemBuilder: (context, index) {
                final model = models[index];
                return _buildOfferCard(model, isDark, theme);
              },
            ),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               const Icon(Icons.history_edu, size: 64, color: Colors.grey),
               const SizedBox(height: 16),
               Text('اضغط لتحديث عروضك', style: GoogleFonts.cairo(color: Colors.grey)),
               IconButton(onPressed: () => context.read<LocalHostCubit>().getMyOffers(), icon: const Icon(Icons.refresh))
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfferCard(LocalHostModel model, bool isDark, ThemeData theme) {
    Color statusColor;
    switch (model.status.toLowerCase()) {
      case 'approved': statusColor = Colors.green; break;
      case 'rejected': statusColor = Colors.red; break;
      default: statusColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(model.title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(model.status, style: GoogleFonts.inter(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(model.city, style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 12),
            Text(model.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.cairo(fontSize: 13)),
            if (model.adminReply != null && model.adminReply!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.blue.withOpacity(0.1) : const Color(0xFFF0F7FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.admin_panel_settings, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('رد الإدارة / Admin Reply', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue)),
                          const SizedBox(height: 4),
                          Text(model.adminReply!, style: GoogleFonts.cairo(fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(model.createdAt.toString().split(' ')[0], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationButton(bool isDark, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'موقع الاستضافة / Hosting Location',
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _isLocating ? null : _getCurrentLocation,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _currentPosition != null ? const Color(0xFFD4AF37) : theme.primaryColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _currentPosition != null ? Icons.gps_fixed : Icons.location_searching,
                  color: _currentPosition != null ? const Color(0xFFD4AF37) : theme.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isLocating 
                            ? 'جاري جلب إحداثيات الموقع...' 
                            : (_currentPosition != null ? 'تم ربط موقع الاستضافة بنجاح' : 'اضغط لجلب موقع الاستضافة الحالي'),
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _currentPosition != null ? const Color(0xFFD4AF37) : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      if (_currentPosition != null)
                        Text(
                          'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, Long: ${_currentPosition!.longitude.toStringAsFixed(4)}',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                if (_isLocating)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview(bool isDark) {
    const Color goldColor = Color(0xFFD4AF37);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_titleController.text.isEmpty ? 'Offer Title' : _titleController.text,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_cityController.text.isEmpty ? 'City' : _cityController.text,
              style: GoogleFonts.plusJakartaSans(color: goldColor, fontSize: 13)),
          if (_currentPosition != null) ...[
             const SizedBox(height: 8),
             Row(
               children: [
                 const Icon(Icons.gps_fixed, size: 12, color: goldColor),
                 const SizedBox(width: 4),
                 Text('Hosting Location Linked', style: GoogleFonts.inter(fontSize: 10, color: goldColor)),
               ],
             ),
          ],
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, bool isDark, ThemeData theme) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? theme.cardColor : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.celebration_rounded, color: Color(0xFFD4AF37), size: 80),
            const SizedBox(height: 24),
            Text(
              'مبارك! لقد أرسلت عرض الاستضافة',
              style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'يمكنك متابعة حالة عرضك في تبويب "عروضي"',
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: Colors.white),
              child: const Text('حسناً / OK'),
            ),
          ],
        ),
      ),
    );
  }
}
