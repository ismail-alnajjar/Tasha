import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HostTouristPage extends StatefulWidget {
  const HostTouristPage({super.key});

  @override
  State<HostTouristPage> createState() => _HostTouristPageState();
}

class _HostTouristPageState extends State<HostTouristPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scale = (screenWidth / 375).clamp(0.8, 1.2);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Premium Color Palette
    const Color goldColor = Color(0xFFD4AF37);
    const Color warmOrange = Color(0xFFF97316);
    const Color sandyBackground = Color(0xFFFFF9F0);

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : sandyBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Premium Header with Background Image
            Stack(
              children: [
                Container(
                  height: 300 * scale,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF134E4A),
                        goldColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 300 * scale,
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
                  top: 50,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  bottom: 40 * scale,
                  left: 24,
                  right: 24,
                  child: Column(
                    children: [
                      Text(
                        'Become a Local Host',
                        style: GoogleFonts.tajawal(
                          color: goldColor,
                          fontSize: 24 * scale,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'كن سفيراً لبلدك بكرمك',
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
                  // 2. Modern Input Fields
                  _buildSectionTitle('أنسئ عرضك الخاص / Create Offer', scale, goldColor),
                  const SizedBox(height: 24),

                  _buildModernField(
                    label: 'العنوان (ماذا ستقدم؟)',
                    hint: 'مثلاً: جولة في السلط القديمة',
                    icon: Icons.home_work_rounded,
                    controller: _titleController,
                    scale: scale,
                    color: goldColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  _buildModernField(
                    label: 'تفاصيل الاستضافة',
                    hint: 'احكِ قصتك.. هل ستطبخ لهم المنسف؟ أم ستأخذهم في جولة في قريتك؟',
                    icon: Icons.description_rounded,
                    controller: _descController,
                    maxLines: 4,
                    scale: scale,
                    color: goldColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  _buildModernField(
                    label: 'رقم التواصل',
                    hint: '+962 7XXXXXXXX',
                    icon: Icons.phone_android_rounded,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    scale: scale,
                    color: Colors.green,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 32),

                  // 3. Photo Upload Section
                  _buildSectionTitle('أضف لمستك الخاصة / Upload Photos', scale, goldColor),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 120 * scale,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: goldColor.withOpacity(0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo_rounded, color: goldColor, size: 40),
                        const SizedBox(height: 8),
                        Text(
                          'اضغط لإضافة صور مكانك',
                          style: GoogleFonts.cairo(
                            color: goldColor,
                            fontSize: 12 * scale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 4. Live Preview Card
                  _buildSectionTitle('معاينة العرض / Live Preview', scale, goldColor),
                  const SizedBox(height: 16),
                  _buildPreviewCard(scale, isDark, goldColor),

                  const SizedBox(height: 48),

                  // 5. Submit Button
                  Container(
                    width: double.infinity,
                    height: 60 * scale,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [warmOrange, Color(0xFFE65100)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: warmOrange.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Confetti Effect Logic would go here
                        _showSuccessDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'نشر العرض / Post My Offer',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 18 * scale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
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

  Widget _buildModernField({
    required String label,
    required String hint,
    required IconData icon,
    required double scale,
    required Color color,
    required bool isDark,
    TextEditingController? controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 13 * scale,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.cairo(fontSize: 14 * scale),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.cairo(fontSize: 12 * scale, color: Colors.grey),
            prefixIcon: Icon(icon, color: color, size: 22 * scale),
            filled: true,
            fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: color.withOpacity(0.1), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: color, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewCard(double scale, bool isDark, Color goldColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 150 * scale,
            width: double.infinity,
            decoration: BoxDecoration(
              color: goldColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Icon(Icons.image_outlined, color: goldColor, size: 48),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25 * scale,
                  backgroundColor: goldColor.withOpacity(0.2),
                  child: Icon(Icons.person, color: goldColor),
                ),

                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _titleController.text.isEmpty ? 'عنوان العرض سيظهر هنا' : _titleController.text,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 16 * scale,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, color: goldColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '5.0 (جديد)',
                            style: GoogleFonts.cairo(fontSize: 12 * scale, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.volunteer_activism_rounded, color: goldColor.withOpacity(0.5), size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.celebration_rounded, color: Color(0xFFF97316), size: 80),
            const SizedBox(height: 24),
            Text(
              'مبارك! لقد أصبحت مضيفاً',
              style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'شكراً لمبادرتك الطيبة وكرمك الأصيل. سيتم مراجعة عرضك ونشره قريباً.',
              style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF97316),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('حسناً', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

