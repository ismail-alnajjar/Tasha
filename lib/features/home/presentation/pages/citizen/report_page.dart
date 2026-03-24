import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tashaapp/core/localization/app_localizations.dart';
import 'package:tashaapp/features/home/cubit/report_cubit.dart';
import 'package:tashaapp/features/home/cubit/report_state.dart';

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

  File? _image;
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
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() => _currentPosition = position);
    } catch (e) {
      debugPrint("Error location: $e");
    } finally {
      setState(() => _isLocating = false);
    }
  }

  String t(BuildContext context, String key) {
    return AppLocalizations.of(context)!.translate(key);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = MediaQuery.sizeOf(context).width / 375;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          t(context, 'report_problem'),
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: theme.primaryColor,
          labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
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
            setState(() {
              _image = null;
              _currentPosition = null;
            });
            _tabController.animateTo(1);
          } else if (state is ReportError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildSendReportForm(context, theme, scale, isDark),
            _buildMyReportsList(context, theme, scale, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSendReportForm(
    BuildContext context,
    ThemeData theme,
    double scale,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(t(context, 'report_title'), scale, theme),
          SizedBox(height: 8 * scale),
          _buildTextField(
            controller: _titleController,
            hint: t(context, 'enter_title'),
            scale: scale,
            theme: theme,
            isDark: isDark,
          ),
          SizedBox(height: 24 * scale),
          _buildLabel(t(context, 'describe_problem'), scale, theme),
          SizedBox(height: 8 * scale),
          _buildTextField(
            controller: _descriptionController,
            hint: t(context, 'write_here'),
            scale: scale,
            theme: theme,
            isDark: isDark,
            maxLines: 5,
          ),
          SizedBox(height: 24 * scale),

          // Location Section
          _buildLabel('Location (Auto-capture)', scale, theme),
          SizedBox(height: 8 * scale),
          InkWell(
            onTap: _getCurrentLocation,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16 * scale,
                vertical: 12 * scale,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12 * scale),
                border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: theme.primaryColor,
                    size: 20 * scale,
                  ),
                  SizedBox(width: 8 * scale),
                  Expanded(
                    child: Text(
                      _isLocating
                          ? "Locating..."
                          : (_currentPosition != null
                                ? "${_currentPosition!.latitude}, ${_currentPosition!.longitude}"
                                : "Click to get current location"),
                      style: GoogleFonts.plusJakartaSans(fontSize: 14 * scale),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24 * scale),

          _buildLabel(t(context, 'attach_photo'), scale, theme),
          SizedBox(height: 8 * scale),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 140 * scale,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16 * scale),
                image: _image != null
                    ? DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      )
                    : null,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey[200]!,
                  width: 2,
                ),
              ),
              child: _image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 36 * scale,
                          color: theme.primaryColor,
                        ),
                        SizedBox(height: 8 * scale),
                        Text(
                          t(context, 'click_to_upload'),
                          style: GoogleFonts.plusJakartaSans(
                            color: theme.primaryColor,
                            fontSize: 13 * scale,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          SizedBox(height: 40 * scale),

          BlocBuilder<ReportCubit, ReportState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                height: 54 * scale,
                child: ElevatedButton(
                  onPressed: state is ReportLoading
                      ? null
                      : () {
                          if (_titleController.text.isEmpty ||
                              _descriptionController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                              ),
                            );
                            return;
                          }
                          context.read<ReportCubit>().sendReport(
                            title: _titleController.text,
                            description: _descriptionController.text,
                            latitude: _currentPosition?.latitude ?? 0.0,
                            longitude: _currentPosition?.longitude ?? 0.0,
                            photo: _image,
                          );
                        },
                  child: state is ReportLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(t(context, 'send')),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMyReportsList(
    BuildContext context,
    ThemeData theme,
    double scale,
    bool isDark,
  ) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MyReportsLoaded) {
          if (state.reports.isEmpty) {
            return const Center(child: Text("No reports found"));
          }
          return ListView.separated(
            padding: EdgeInsets.all(20 * scale),
            itemCount: state.reports.length,
            separatorBuilder: (_, __) => SizedBox(height: 16 * scale),
            itemBuilder: (context, index) {
              final report = state.reports[index];
              String? fullImageUrl;
              if (report.photoUrl != null && report.photoUrl!.isNotEmpty) {
                fullImageUrl = report.photoUrl!.startsWith('http') 
                  ? report.photoUrl 
                  : 'http://192.168.1.27:5000${report.photoUrl}';
              }

              return Container(
                padding: EdgeInsets.all(16 * scale),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16 * scale),
                  boxShadow: isDark
                      ? []
                      : [
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- 1. Report Image Thumbnail ---
                        if (fullImageUrl != null)
                          Container(
                            width: 60 * scale,
                            height: 60 * scale,
                            margin: EdgeInsets.only(right: 12 * scale),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8 * scale),
                              image: DecorationImage(
                                image: NetworkImage(fullImageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 60 * scale,
                            height: 60 * scale,
                            margin: EdgeInsets.only(right: 12 * scale),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8 * scale),
                            ),
                            child: Icon(Icons.image_not_supported, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                          ),

                        // --- 2. Title, Status, Description ---
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      report.title,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16 * scale,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          (report.status?.toLowerCase() == 'pending'
                                                  ? Colors.orange
                                                  : Colors.green)
                                              .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      report.status?.toUpperCase() ?? "PENDING",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: report.status?.toLowerCase() == 'pending'
                                            ? Colors.orange
                                            : Colors.green,
                                        fontSize: 10 * scale,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6 * scale),
                              Text(
                                report.description,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.grey,
                                  fontSize: 13 * scale,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // --- 3. Admin Reply Box ---
                    if (report.adminReply != null && report.adminReply!.trim().isNotEmpty) ...[
                      SizedBox(height: 16 * scale),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12 * scale),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.green[900] : Colors.green[50])!.withOpacity(isDark ? 0.3 : 1.0),
                          borderRadius: BorderRadius.circular(8 * scale),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.admin_panel_settings, size: 16 * scale, color: isDark ? Colors.green[300] : Colors.green[700]),
                                SizedBox(width: 8 * scale),
                                Text(
                                  "Admin Reply",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13 * scale,
                                    color: isDark ? Colors.green[300] : Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6 * scale),
                            Text(
                              report.adminReply!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14 * scale,
                                color: theme.textTheme.bodyMedium?.color,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        } else if (state is ReportError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text("Switch to 'New Report' or refresh"));
      },
    );
  }

  Widget _buildLabel(String text, double scale, ThemeData theme) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16 * scale,
        fontWeight: FontWeight.bold,
        color: theme.textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required double scale,
    required ThemeData theme,
    required bool isDark,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16 * scale),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          contentPadding: EdgeInsets.all(16 * scale),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16 * scale),
            borderSide: isDark
                ? BorderSide(color: Colors.white.withOpacity(0.1))
                : BorderSide.none,
          ),
          fillColor: theme.colorScheme.surface,
          filled: true,
        ),
      ),
    );
  }
}
