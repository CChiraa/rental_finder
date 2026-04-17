import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

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
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F1E7),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2C2621)),
        title: Text(
          'Report an Issue',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2C2621),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F1E7), Color(0xFFF2E6D5), Color(0xFFEAD8BE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWarningCard(),
                const SizedBox(height: 22),

                _sectionLabel('Issue Type'),
                const SizedBox(height: 10),
                _buildDropdownField(),

                const SizedBox(height: 20),

                _sectionLabel('Subject'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: subjectController,
                  hintText: 'Enter a short subject',
                  maxLines: 1,
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

                _sectionLabel('Details'),
                const SizedBox(height: 10),
                _buildTextField(
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
                    color: Colors.white.withOpacity(0.72),
                    borderRadius: BorderRadius.circular(18),
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
                          'Tip: Include clear details such as landlord name, property title, payment reference, date, or screenshots when explaining the problem.',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            height: 1.5,
                            color: const Color(0xFF7B664C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE1C27A), Color(0xFFB8964F)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB8964F).withOpacity(0.20),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _submitReport,
                      icon: const Icon(
                        Icons.report_problem_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Submit Report',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
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

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6EF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6C28A), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
              'Use this form to report serious issues to the admin team. Please provide clear and accurate information so we can review the case properly.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF5E4B36),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF2C2621),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedIssue,
        decoration: const InputDecoration(border: InputBorder.none),
        style: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF2C2621),
          fontWeight: FontWeight.w500,
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(16),
        items: issueTypes.map((issue) {
          return DropdownMenuItem<String>(value: issue, child: Text(issue));
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedIssue = value!;
          });
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required int maxLines,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF2C2621),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            color: const Color(0xFF9B8A76),
            fontSize: 13.5,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
