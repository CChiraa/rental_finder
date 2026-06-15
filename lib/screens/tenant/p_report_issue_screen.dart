import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_rental_app/services/report_service.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();

  String selectedIssue = 'Scam by landlord';
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  bool _submitting = false;

  final List<String> issueTypes = [
    'Scam by landlord',
    'Fake property listing',
    'Unsafe property condition',
    'Payment issue',
    'Harassment or suspicious behavior',
    'Other',
  ];

  @override
  void dispose() {
    subjectController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);

    try {
      await ReportService().submitReport(
        issueType: selectedIssue,
        subject: subjectController.text,
        details: detailsController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFB17B30),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Text(
            'Your report has been sent to admin successfully.',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) Navigator.pop(context);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Failed to send report. Please try again.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryText = Theme.of(context).colorScheme.onSurface;
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    final Gradient backgroundGradient = dark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B1220),
              Color(0xFF111827),
              Color(0xFF172554),
              Color(0xFF0F172A),
            ],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F1E7),
              Color(0xFFF2E6D5),
              Color(0xFFEAD8BE),
              Color(0xFFF7EFE5),
            ],
          );

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Report an Issue',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                _infoCard(context, dark),
                const SizedBox(height: 20),
                _sectionLabel(context, 'Issue Type'),
                const SizedBox(height: 10),
                _buildDropdownField(context),
                const SizedBox(height: 20),
                _sectionLabel(context, 'Subject'),
                const SizedBox(height: 10),
                _buildTextField(
                  context: context,
                  controller: subjectController,
                  hintText: 'Short summary of the issue',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a subject';
                    }
                    if (value.trim().length < 4) {
                      return 'Subject is too short';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _sectionLabel(context, 'Details'),
                const SizedBox(height: 10),
                _buildTextField(
                  context: context,
                  controller: detailsController,
                  hintText: 'Describe the issue clearly',
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter issue details';
                    }
                    if (value.trim().length < 10) {
                      return 'Please provide more details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: dark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.white.withOpacity(0.72),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: dark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFFB17B30),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tip: Include clear details such as landlord name, '
                          'property title, payment reference, date, or '
                          'screenshots when explaining the problem.',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: secondaryText,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB17B30),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _submitting ? null : _submitReport,
                    child: _submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Submit Report',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, bool dark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1E1E1E) : const Color(0xFFFFF6EF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.08)
              : const Color(0xFFE6C28A),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.18)
                : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFB17B30),
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Use this form to report serious issues to the admin team. '
              'Please provide clear and accurate information so we can '
              'review the case properly.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: dark ? Colors.white70 : const Color(0xFF5E4B36),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1E1E1E) : Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.18)
                : Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: dark ? Colors.white.withOpacity(0.08) : Colors.transparent,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedIssue,
        decoration: const InputDecoration(border: InputBorder.none),
        style: GoogleFonts.inter(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        dropdownColor: dark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        iconEnabledColor: dark ? Colors.white70 : const Color(0xFFB17B30),
        items: issueTypes
            .map(
              (type) => DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) setState(() => selectedIssue = value);
        },
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1E1E1E) : Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.18)
                : Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: dark ? Colors.white.withOpacity(0.08) : Colors.transparent,
        ),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: dark ? Colors.white38 : const Color(0xFFB7A999),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
