import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/features/home/cubit/local_host_cubit.dart';
import 'package:tashaapp/features/home/cubit/local_host_state.dart';
import '../../widgets/shared/base_submission_page.dart';

class HostTouristPage extends StatefulWidget {
  const HostTouristPage({super.key});

  @override
  State<HostTouristPage> createState() => _HostTouristPageState();
}

class _HostTouristPageState extends State<HostTouristPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _activitiesController = TextEditingController();

  @override
  void dispose() {
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
      ),
      body: BlocListener<LocalHostCubit, LocalHostState>(
        listener: (context, state) {
          if (state is LocalHostSuccess) {
            _showSuccessDialog(context, isDark, theme);
          } else if (state is LocalHostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<LocalHostCubit, LocalHostState>(
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
              selectedImages: const [], // Not used for now as per previous code
              onImagesChanged: (_) {},
              supportMultipleImages: false,
              submitButtonText: 'نشر العرض / Post My Offer',
              isLoading: state is LocalHostLoading,
              previewCard: _buildPreview(isDark),
              onSubmit: () {
                context.read<LocalHostCubit>().submitOffer(
                      title: _titleController.text,
                      description: _descController.text,
                      phone: _phoneController.text,
                      city: _cityController.text,
                      activities: _activitiesController.text,
                    );
              },
            );
          },
        ),
      ),
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
            const Icon(Icons.celebration_rounded, color: Color(0xFFF97316), size: 80),
            const SizedBox(height: 24),
            Text(
              'مبارك! لقد أصبحت مضيفاً',
              style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('حسناً'),
            ),
          ],
        ),
      ),
    );
  }
}
