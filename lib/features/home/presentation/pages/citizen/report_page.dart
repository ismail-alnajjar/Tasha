import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/core/localization/app_localizations.dart';
import 'package:tashaapp/core/services/location_service.dart';
import 'package:tashaapp/features/home/cubit/report_cubit.dart';
import 'package:tashaapp/features/home/cubit/report_state.dart';
import 'package:tashaapp/features/home/data/models/report_model.dart';
import '../../widgets/shared/base_submission_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<File> _images = [];
  Position? _currentPosition;
  bool _isLocating = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        context.read<ReportCubit>().getMyReports();
      }
    });
    _getCurrentLocation(); // Fetch location automatically
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

  String t(BuildContext context, String key) {
    return AppLocalizations.of(context)!.translate(key);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scale = MediaQuery.sizeOf(context).width / 375;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t(context, 'report_problem'),
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.primaryColor,
          indicatorColor: theme.primaryColor,
          tabs: [
            Tab(text: t(context, 'report_now')),
            Tab(text: t(context, 'my_reports')),
          ],
        ),
      ),
      body: BlocListener<ReportCubit, ReportState>(
        listener: (context, state) {
          if (state is ReportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report submitted successfully')),
            );
            _titleController.clear();
            _descriptionController.clear();
            setState(() => _images.clear());
            _tabController.animateTo(1);
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildForm(scale, isDark, theme),
            _buildMyReportsList(scale, isDark, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(double scale, bool isDark, ThemeData theme) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        return BaseSubmissionPage(
          title: 'Report Issue',
          arabicSubtitle: 'بلغ عن مشكلة في منطقتك',
          headerGradient: const [Color(0xFF134E4A), Color(0xFF00695C)],
          fields: [
            FormFieldConfig(
              label: t(context, 'report_title'),
              hint: t(context, 'enter_title'),
              icon: Icons.title,
              controller: _titleController,
            ),
            FormFieldConfig(
              label: t(context, 'describe_problem'),
              hint: t(context, 'write_here'),
              icon: Icons.description,
              controller: _descriptionController,
              maxLines: 4,
            ),
          ],
          selectedImages: _images,
          onImagesChanged: (imgs) => setState(() => _images = imgs),
          supportMultipleImages: true,
          submitButtonText: t(context, 'send'),
          isLoading: state is ReportLoading,
          previewCard: _buildPreview(scale, isDark),
          locationWidget: _buildLocationButton(isDark, theme),
          onSubmit: () {
            context.read<ReportCubit>().sendReport(
              title: _titleController.text,
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

  Widget _buildLocationButton(bool isDark, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'موقع المشكلة / Problem Location',
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
                color: _currentPosition != null ? Colors.green : theme.primaryColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _currentPosition != null ? Icons.location_on : Icons.my_location,
                  color: _currentPosition != null ? Colors.green : theme.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isLocating 
                            ? 'جاري تحديد الموقع...' 
                            : (_currentPosition != null ? 'تم تحديد الموقع بنجاح' : 'اضغط لتحديد موقعك الحالي'),
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _currentPosition != null ? Colors.green : (isDark ? Colors.white : Colors.black87),
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

  Widget _buildPreview(double scale, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _titleController.text.isEmpty ? 'Title' : _titleController.text,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            _descriptionController.text.isEmpty
                ? 'Description'
                : _descriptionController.text,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyReportsList(double scale, bool isDark, ThemeData theme) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state is ReportLoading)
          return const Center(child: CircularProgressIndicator());
        if (state is MyReportsLoaded) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.reports.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final report = state.reports[index];
              return InkWell(
                onTap: () => _showDetails(report, isDark, theme, scale),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.report_problem, color: theme.primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            if (report.adminReply != null &&
                                report.adminReply!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  report.adminReply!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.green,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('No reports found'));
      },
    );
  }

  void _showDetails(
    ReportModel report,
    bool isDark,
    ThemeData theme,
    double scale,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(report.description),
            if (report.photoUrls.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: report.photoUrls.length,
                  itemBuilder: (context, i) => Image.network(
                    'http://192.168.1.27:5010${report.photoUrls[i]}',
                    width: 100,
                  ),
                ),
              ),
            ],
            if (report.adminReply != null && report.adminReply!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          color: Colors.green,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Admin Reply',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(report.adminReply!),
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
