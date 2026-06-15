import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/services/report_service.dart';

class AdminDashboardTab extends StatelessWidget {
  const AdminDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        Text(
          'Admin Dashboard',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Overview of the YuppiesLah platform',
          style: GoogleFonts.inter(fontSize: 13.5, color: secondaryText),
        ),
        const SizedBox(height: 22),

        // Users + role stats (one stream, counted client-side).
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            int total = 0;
            int tenants = 0;
            int landlords = 0;

            if (snapshot.hasData) {
              for (final doc in snapshot.data!.docs) {
                final List<dynamic> roles = doc.data()['roles'] ?? [];
                if (roles.contains('Admin') && roles.length == 1) {
                  continue; // skip pure admin accounts from user counts
                }
                total++;
                if (roles.contains('Tenant')) tenants++;
                if (roles.contains('Landlord')) landlords++;
              }
            }

            final bool loading =
                snapshot.connectionState == ConnectionState.waiting;

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.groups_rounded,
                        label: 'Total Users',
                        value: loading ? '—' : '$total',
                        accent: const Color(0xFFB17B30),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.person_rounded,
                        label: 'Tenants',
                        value: loading ? '—' : '$tenants',
                        accent: const Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.home_work_rounded,
                        label: 'Landlords',
                        value: loading ? '—' : '$landlords',
                        accent: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _PendingReportsCard(),
                    ),
                  ],
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 26),
        Text(
          'Reports summary',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        const SizedBox(height: 12),
        _ReportsSummary(),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg =
        dark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.78);
    final Color border =
        dark ? Colors.white.withOpacity(0.14) : Colors.white.withOpacity(0.90);
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(dark ? 0.18 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: secondaryText),
          ),
        ],
      ),
    );
  }
}

class _PendingReportsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ReportService().getAllReports(),
      builder: (context, snapshot) {
        int pending = 0;
        if (snapshot.hasData) {
          for (final doc in snapshot.data!.docs) {
            if ((doc.data()['status'] ?? '') == ReportService.pending) {
              pending++;
            }
          }
        }
        final bool loading =
            snapshot.connectionState == ConnectionState.waiting;
        return _StatCard(
          icon: Icons.flag_rounded,
          label: 'Pending Reports',
          value: loading ? '—' : '$pending',
          accent: const Color(0xFFEF4444),
        );
      },
    );
  }
}

class _ReportsSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg =
        dark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.78);
    final Color border =
        dark ? Colors.white.withOpacity(0.14) : Colors.white.withOpacity(0.90);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ReportService().getAllReports(),
      builder: (context, snapshot) {
        int pending = 0, reviewed = 0, resolved = 0;
        if (snapshot.hasData) {
          for (final doc in snapshot.data!.docs) {
            switch (doc.data()['status'] ?? '') {
              case ReportService.pending:
                pending++;
                break;
              case ReportService.reviewed:
                reviewed++;
                break;
              case ReportService.resolved:
                resolved++;
                break;
            }
          }
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryItem(
                '$pending',
                'Pending',
                const Color(0xFFEF4444),
                secondaryText,
              ),
              _divider(dark),
              _summaryItem(
                '$reviewed',
                'Reviewed',
                const Color(0xFF3B82F6),
                secondaryText,
              ),
              _divider(dark),
              _summaryItem(
                '$resolved',
                'Resolved',
                const Color(0xFF10B981),
                secondaryText,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _divider(bool dark) => Container(
        height: 38,
        width: 1,
        color: dark ? Colors.white24 : const Color(0xFFE6D6BE),
      );

  Widget _summaryItem(
    String value,
    String label,
    Color color,
    Color secondaryText,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12.5, color: secondaryText),
        ),
      ],
    );
  }
}
