import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Handles tenant-submitted reports and admin-side review.
///
/// Firestore structure:
///   reports/{autoId}
///     reporterId, reporterName, reporterEmail,
///     issueType, subject, details,
///     status ('Pending' | 'Reviewed' | 'Resolved'),
///     createdAt, updatedAt
class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String pending = 'Pending';
  static const String reviewed = 'Reviewed';
  static const String resolved = 'Resolved';

  // ---------- TENANT SIDE ----------

  /// Saves a new report submitted by the currently logged-in tenant.
  Future<void> submitReport({
    required String issueType,
    required String subject,
    required String details,
  }) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception('You must be logged in to submit a report');
    }

    String reporterName = user.displayName ?? '';
    String reporterEmail = user.email ?? '';

    // Enrich with the profile stored in the users collection if available.
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      final Map<String, dynamic>? data = userDoc.data();
      if (data != null) {
        reporterName = (data['name'] ?? reporterName).toString();
        reporterEmail = (data['email'] ?? reporterEmail).toString();
      }
    } catch (_) {
      // Ignore enrichment errors; fall back to auth values.
    }

    await _firestore.collection('reports').add({
      'reporterId': user.uid,
      'reporterName': reporterName,
      'reporterEmail': reporterEmail,
      'issueType': issueType,
      'subject': subject.trim(),
      'details': details.trim(),
      'status': pending,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ---------- ADMIN SIDE ----------

  /// All reports, newest first. Single-field order (no composite index needed).
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllReports() {
    return _firestore
        .collection('reports')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateStatus(String reportId, String status) async {
    await _firestore.collection('reports').doc(reportId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteReport(String reportId) async {
    await _firestore.collection('reports').doc(reportId).delete();
  }
}
