import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminUsersTab extends StatefulWidget {
  const AdminUsersTab({super.key});

  @override
  State<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<AdminUsersTab> {
  // 'All' | 'Tenant' | 'Landlord'
  String _filter = 'All';
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'View Users',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 14),
              _searchField(dark, secondaryText),
              const SizedBox(height: 14),
              Row(
                children: [
                  _filterChip('All'),
                  const SizedBox(width: 10),
                  _filterChip('Tenant'),
                  const SizedBox(width: 10),
                  _filterChip('Landlord'),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream:
                FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Failed to load users.',
                    style: GoogleFonts.inter(color: secondaryText),
                  ),
                );
              }

              final docs = snapshot.data?.docs ?? [];

              // Filter client-side (avoids needing a composite Firestore index).
              final filtered = docs.where((doc) {
                final data = doc.data();
                final List<dynamic> roles = data['roles'] ?? [];

                // Hide pure-admin accounts from the user list.
                if (roles.contains('Admin') && roles.length == 1) return false;

                if (_filter != 'All' && !roles.contains(_filter)) return false;

                if (_search.isNotEmpty) {
                  final name = (data['name'] ?? '').toString().toLowerCase();
                  final email = (data['email'] ?? '').toString().toLowerCase();
                  final q = _search.toLowerCase();
                  if (!name.contains(q) && !email.contains(q)) return false;
                }
                return true;
              }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    'No users found.',
                    style: GoogleFonts.inter(color: secondaryText),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return _UserCard(data: filtered[index].data());
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _searchField(bool dark, Color secondaryText) {
    return Container(
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.12)
              : const Color(0xFFE6D6BE),
        ),
      ),
      child: TextField(
        onChanged: (v) => setState(() => _search = v.trim()),
        style: GoogleFonts.inter(
          color: dark ? Colors.white : const Color(0xFF2C2621),
        ),
        decoration: InputDecoration(
          hintText: 'Search by name or email',
          hintStyle: GoogleFonts.inter(color: secondaryText, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: secondaryText),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  Widget _filterChip(String label) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final bool selected = _filter == label;
    return GestureDetector(
      onTap: () => setState(() => _filter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFB17B30)
              : (dark
                  ? Colors.white.withOpacity(0.07)
                  : Colors.white.withOpacity(0.8)),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected
                ? const Color(0xFFB17B30)
                : (dark
                    ? Colors.white.withOpacity(0.12)
                    : const Color(0xFFE6D6BE)),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : (dark ? Colors.white70 : const Color(0xFF7B664C)),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _UserCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg =
        dark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.82);
    final Color border =
        dark ? Colors.white.withOpacity(0.14) : Colors.white.withOpacity(0.90);
    final Color primaryText = dark ? Colors.white : const Color(0xFF2C2621);
    final Color secondaryText = dark ? Colors.white70 : const Color(0xFF7B664C);

    final String name = (data['name'] ?? 'Unknown').toString();
    final String email = (data['email'] ?? '').toString();
    final String nric = (data['nric'] ?? '').toString();
    final List<dynamic> roles = data['roles'] ?? [];

    final String initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(' ').take(2).map((w) => w[0]).join().toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFB17B30).withOpacity(0.18),
            child: Text(
              initials,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: const Color(0xFFB17B30),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: GoogleFonts.inter(fontSize: 13, color: secondaryText),
                ),
                if (nric.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'NRIC: $nric',
                    style:
                        GoogleFonts.inter(fontSize: 12, color: secondaryText),
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: roles
                      .map((r) => _roleBadge(r.toString()))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleBadge(String role) {
    Color color;
    switch (role) {
      case 'Tenant':
        color = const Color(0xFF3B82F6);
        break;
      case 'Landlord':
        color = const Color(0xFF10B981);
        break;
      case 'Admin':
        color = const Color(0xFFB17B30);
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        role,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
