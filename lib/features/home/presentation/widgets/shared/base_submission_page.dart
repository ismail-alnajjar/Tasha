import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tashaapp/core/localization/app_localizations.dart';

class FormFieldConfig {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final Color iconColor;

  FormFieldConfig({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.iconColor = const Color(0xFFD4AF37),
  });
}

class BaseSubmissionPage extends StatefulWidget {
  final String title;
  final String arabicSubtitle;
  final List<Color> headerGradient;
  final List<FormFieldConfig> fields;
  final bool supportMultipleImages;
  final String submitButtonText;
  final Widget previewCard;
  final VoidCallback onSubmit;
  final bool isLoading;
  final List<File> selectedImages;
  final Function(List<File>) onImagesChanged;

  const BaseSubmissionPage({
    super.key,
    required this.title,
    required this.arabicSubtitle,
    required this.headerGradient,
    required this.fields,
    required this.submitButtonText,
    required this.previewCard,
    required this.onSubmit,
    this.isLoading = false,
    this.supportMultipleImages = false,
    required this.selectedImages,
    required this.onImagesChanged,
  });

  @override
  State<BaseSubmissionPage> createState() => _BaseSubmissionPageState();
}

class _BaseSubmissionPageState extends State<BaseSubmissionPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    if (widget.supportMultipleImages) {
      final List<XFile> pickedList = await _picker.pickMultiImage();
      if (pickedList.isNotEmpty) {
        widget.onImagesChanged([
          ...widget.selectedImages,
          ...pickedList.map((x) => File(x.path)),
        ]);
      }
    } else {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        widget.onImagesChanged([File(pickedFile.path)]);
      }
    }
  }

  void _removeImage(int index) {
    List<File> current = List.from(widget.selectedImages);
    current.removeAt(index);
    widget.onImagesChanged(current);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scale = (screenWidth / 360).clamp(0.8, 1.2);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const Color goldColor = Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : const Color(0xFFFFF9F0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header
            Stack(
              children: [
                Container(
                  height: 150 * scale,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: widget.headerGradient),
                  ),
                ),
                Container(
                  height: 150 * scale,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 40 * scale,
                  left: 24,
                  right: 24,
                  child: Column(
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.plusJakartaSans(
                          color: goldColor,
                          fontSize: 24 * scale,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.arabicSubtitle,
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 20 * scale,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(24 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'أدخل البيانات / Fill Information',
                    scale,
                    goldColor,
                  ),
                  const SizedBox(height: 24),

                  // 2. Dynamic Fields
                  ...widget.fields.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildModernField(f, scale, isDark),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. Image Section
                  _buildSectionTitle(
                    '${AppLocalizations.of(context)?.translate('attach_photo') ?? 'Attach Photo'} / Photos',
                    scale,
                    goldColor,
                  ),
                  const SizedBox(height: 16),
                  _buildImagePicker(scale, goldColor, isDark),

                  const SizedBox(height: 32),
                  _buildSectionTitle('معاينة / Preview', scale, goldColor),
                  const SizedBox(height: 16),
                  widget.previewCard,

                  const SizedBox(height: 48),

                  // 4. Submit Button
                  _buildSubmitButton(scale, theme),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double scale, Color color) {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 16 * scale,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildModernField(FormFieldConfig f, double scale, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          f.label,
          style: GoogleFonts.cairo(
            fontSize: 13 * scale,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: f.controller,
          maxLines: f.maxLines,
          keyboardType: f.keyboardType,
          style: GoogleFonts.cairo(fontSize: 14 * scale),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: f.hint,
            hintStyle: GoogleFonts.cairo(
              fontSize: 12 * scale,
              color: Colors.grey,
            ),
            prefixIcon: Icon(f.icon, color: f.iconColor, size: 22 * scale),
            filled: true,
            fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: f.iconColor.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: f.iconColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker(double scale, Color goldColor, bool isDark) {
    return Column(
      children: [
        InkWell(
          onTap: _pickImages,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            height: 120 * scale,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: goldColor.withOpacity(0.3), width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo_rounded, color: goldColor, size: 40),
                const SizedBox(height: 8),
                Text(
                  'اضغط لإضافة صور',
                  style: GoogleFonts.cairo(
                    color: goldColor,
                    fontSize: 12 * scale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.selectedImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(widget.selectedImages.length, (index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      widget.selectedImages[index],
                      width: 80 * scale,
                      height: 80 * scale,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton(double scale, ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 60 * scale,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFE65100)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF97316).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: widget.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                widget.submitButtonText,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 18 * scale,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
