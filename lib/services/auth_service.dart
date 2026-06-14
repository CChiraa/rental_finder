import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    final UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

    final String uid = userCredential.user!.uid;

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name.trim(),
      'email': email.trim(),
      'roles': [role],
      'activeRole': role,
      'nric': nric?.trim() ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return userCredential;
  }

  // SIGN IN
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential = await _auth
        .signInWithEmailAndPassword(email: email.trim(), password: password);

    final String uid = userCredential.user!.uid;

    final DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!userDoc.exists || userDoc.data() == null) {
      throw Exception('User profile not found in Firestore');
    }

    return userDoc.data() as Map<String, dynamic>;
  }

  // GOOGLE SIGN IN / SIGN UP
  Future<Map<String, dynamic>> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Google sign in cancelled');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(
      credential,
    );

    final User? user = userCredential.user;

    if (user == null) {
      throw Exception('Google sign in failed');
    }

    final DocumentReference userRef = _firestore
        .collection('users')
        .doc(user.uid);

    final DocumentSnapshot userDoc = await userRef.get();

    if (!userDoc.exists) {
      await userRef.set({
        'uid': user.uid,
        'name': user.displayName ?? 'User',
        'email': user.email ?? '',
        'roles': ['Tenant'],
        'activeRole': 'Tenant',
        'nric': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final DocumentSnapshot newUserDoc = await userRef.get();
      return newUserDoc.data() as Map<String, dynamic>;
    }

    return userDoc.data() as Map<String, dynamic>;
  }

  // ADD LANDLORD ROLE
  Future<void> addLandlordRole({required String nric}) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user is currently logged in');
    }

    if (nric.trim().isEmpty) {
      throw Exception('NRIC is required to become a landlord');
    }

    await _firestore.collection('users').doc(user.uid).update({
      'roles': FieldValue.arrayUnion(['Landlord']),
      'activeRole': 'Landlord',
      'nric': nric.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ADD TENANT ROLE
  Future<void> addTenantRole() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user is currently logged in');
    }

    await _firestore.collection('users').doc(user.uid).update({
      'roles': FieldValue.arrayUnion(['Tenant']),
      'activeRole': 'Tenant',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // SWITCH ROLE
  Future<void> switchRole(String role) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user is currently logged in');
    }

    final DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists || userDoc.data() == null) {
      throw Exception('User profile not found');
    }

    final Map<String, dynamic> userData =
        userDoc.data() as Map<String, dynamic>;

    final List<dynamic> roles = userData['roles'] ?? [];

    if (!roles.contains(role)) {
      throw Exception('This account does not have $role access');
    }

    await _firestore.collection('users').doc(user.uid).update({
      'activeRole': role,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // GET USER DATA
  Future<Map<String, dynamic>?> getUserData() async {
    final User? user = _auth.currentUser;

    if (user == null) return null;

    final DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data() as Map<String, dynamic>?;
  }

  // RESET PASSWORD
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // LOGOUT
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  // CURRENT USER
  User? get currentUser => _auth.currentUser;
}
