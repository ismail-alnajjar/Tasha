import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/features/home/cubit/local_host_cubit.dart';
import 'package:tashaapp/features/home/cubit/local_host_state.dart';
import 'package:tashaapp/features/home/data/models/local_host_model.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitingCitizenPage extends StatelessWidget {
  const VisitingCitizenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => LocalHostCubit()..getAllHosts(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.secondary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Visiting a Citizen",
            style: GoogleFonts.plusJakartaSans(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<LocalHostCubit, LocalHostState>(
          builder: (context, state) {
            if (state is LocalHostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LocalHostError) {
              return Center(child: Text(state.message));
            } else if (state is AllLocalHostsLoaded) {
              print('DEBUG: Received ${state.hosts.length} total hosts from API');
              final hosts = state.hosts.where((h) => h.status.toLowerCase() == 'approved').toList();
              print('DEBUG: Found ${hosts.length} approved hosts after filtering');
              
              if (hosts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        "No citizens hosting at the moment.",
                        style: GoogleFonts.plusJakartaSans(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: hosts.length,
                itemBuilder: (context, index) {
                  final host = hosts[index];
                  return _buildHostCard(context, host);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHostCard(BuildContext context, LocalHostModel host) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
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
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Text(
                host.citizenName.isNotEmpty ? host.citizenName.substring(0, 1).toUpperCase() : 'C',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            title: Text(
              host.title,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: theme.colorScheme.secondary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(host.city, style: GoogleFonts.plusJakartaSans(fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "By: ${host.citizenName}",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              host.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.grey[600],
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: host.activities.split(',').map((activity) {
                return Chip(
                  label: Text(
                    activity.trim(),
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white),
                  ),
                  backgroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse("tel:${host.citizenPhone}");
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text("Call Host"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE75B04),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                       // Link to WhatsApp or similar
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text("Chat"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(color: theme.colorScheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
