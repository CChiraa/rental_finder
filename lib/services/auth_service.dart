import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SIGN UP
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    String? nric,
  }) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String uid = userCredential.user!.uid;

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'roles': [role],
      'activeRole': role,
      'nric': nric ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return userCredential;
  }

  // SIGN IN
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        throw Exception('User profile not found in Firestore');
      }

      return userDoc.data() as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ADD LANDLORD ROLE
  Future<void> addLandlordRole({String? nric}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'roles': FieldValue.arrayUnion(['Landlord']),
      'activeRole': 'Landlord',
      'nric': nric ?? '',
    });
  }

  // GET USER ROLE + INFO
  Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;

    if (user == null) return null;

    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data() as Map<String, dynamic>?;
  }

  // FORGOT PASSWORD
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}
