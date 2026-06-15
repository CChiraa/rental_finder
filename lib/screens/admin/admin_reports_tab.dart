import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/services/report_service.dart';

class AdminReportsTab extends StatelessWidget {
  const AdminReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reports',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
                Text(
                  'Issues submitted by tenants',
                  style:
                      GoogleFonts.inter(fontSize: 13.5, color: secondaryText),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: ReportService().getAllReports(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Failed to load reports.',
                    style: GoogleFonts.inter(color: secondaryText),
                  ),
                );
              }

              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox_rounded,
                          size: 48, color: secondaryText),
                      const SizedBox(height: 10),
                      Text(
                        'No reports yet.',
                        style: GoogleFonts.inter(color: secondaryText),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  return _ReportCard(id: doc.id, data: doc.data());
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String id;
  final Map<String, dynamic> data;

  const _ReportCard({required this.id, required this.data});

  static Color statusColor(String status) {
    switch (status) {
      case ReportService.reviewed:
        return const Color(0xFF3B82F6);
      case ReportService.resolved:
        return const Color(0xFF10B981);
      default:
        return const Color(0xFFEF4444);
    }
  }

  String _formatTime(dynamic createdAt) {
    if (createdAt is Timestamp) {
      final d = createdAt.toDate();
      return '${d.day}/${d.month}/${d.year}  '
          '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg =
        dark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.82);
    final Color border =
        dark ? Colors.white.withOpacity(0.14) : Colors.white.withOpacity(0.90);
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    final String issueType = (data['issueType'] ?? 'Other').toString();
    final String subject = (data['subject'] ?? '').toString();
    final String reporter = (data['reporterName'] ?? 'Unknown').toString();
    final String status = (data['status'] ?? ReportService.pending).toString();
    final Color sColor = statusColor(status);

    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFB17B30), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    issueType,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                  ),
                ),
                _statusBadge(status, sColor),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subject,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.person_outline_rounded,
                    size: 14, color: secondaryText),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    reporter,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        GoogleFonts.inter(fontSize: 12.5, color: secondaryText),
                  ),
                ),
                Text(
                  _formatTime(data['createdAt']),
                  style: GoogleFonts.inter(fontSize: 11.5, color: secondaryText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color sheetBg = dark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    final String issueType = (data['issueType'] ?? 'Other').toString();
    final String subject = (data['subject'] ?? '').toString();
    final String details = (data['details'] ?? '').toString();
    final String reporter = (data['reporterName'] ?? 'Unknown').toString();
    final String email = (data['reporterEmail'] ?? '').toString();
    final String status = (data['status'] ?? ReportService.pending).toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            18,
            22,
            22 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: secondaryText.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        issueType,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: primaryText,
                        ),
                      ),
                    ),
                    _statusBadge(status, statusColor(status)),
                  ],
                ),
                const SizedBox(height: 16),
                _detailRow('Subject', subject, primaryText, secondaryText),
                _detailRow('Reporter', reporter, primaryText, secondaryText),
                _detailRow('Email', email, primaryText, secondaryText),
                _detailRow(
                  'Submitted',
                  _formatTime(data['createdAt']),
                  primaryText,
                  secondaryText,
                ),
                const SizedBox(height: 12),
                Text(
                  'Details',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: secondaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  details,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.5,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Update status',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: secondaryText,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _statusButton(sheetContext, ReportService.pending,
                        const Color(0xFFEF4444), status),
                    const SizedBox(width: 8),
                    _statusButton(sheetContext, ReportService.reviewed,
                        const Color(0xFF3B82F6), status),
                    const SizedBox(width: 8),
                    _statusButton(sheetContext, ReportService.resolved,
                        const Color(0xFF10B981), status),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () => _confirmDelete(sheetContext),
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: Colors.redAccent),
                    label: Text(
                      'Delete report',
                      style: GoogleFonts.inter(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(
    String label,
    String value,
    Color primaryText,
    Color secondaryText,
  ) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 13, color: secondaryText),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusButton(
    BuildContext context,
    String value,
    Color color,
    String current,
  ) {
    final bool active = current == value;
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          await ReportService().updateStatus(id, value);
          if (context.mounted) Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? color : color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(active ? 1 : 0.4)),
          ),
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) async {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: dark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Delete report?', style: GoogleFonts.inter()),
        content: Text(
          'This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ReportService().deleteReport(id);
      if (context.mounted) Navigator.pop(context); // close the detail sheet
    }
  }
}
