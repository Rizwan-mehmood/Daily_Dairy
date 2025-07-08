import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data_schema.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  UserModel? _userData;
  bool _isLoading = true;

  User? get currentUser => _user;

  UserModel? get currentUserData => _userData;

  bool get isLoading => _isLoading;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    if (user != null) {
      await _loadUserData();
    } else {
      _userData = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      try {
        final doc = await _firestore.collection('users').doc(_user!.uid).get();
        if (doc.exists) {
          _userData = UserModel.fromFirestore(doc);
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<String?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'invalid-email':
          return 'Invalid email address format.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        default:
          return 'Login failed. Please try again.';
      }
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<String?> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String? phone,
    String? address,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user document in Firestore
        final userData = UserModel(
          id: credential.user!.uid,
          email: email,
          name: name,
          role: 'customer',
          // Default role
          phone: phone,
          address: address,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(userData.toFirestore());

        // Update display name
        await credential.user!.updateDisplayName(name);
      }

      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'email-already-in-use':
          return 'An account already exists with this email address.';
        case 'invalid-email':
          return 'Invalid email address format.';
        default:
          return 'Registration failed. Please try again.';
      }
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'invalid-email':
          return 'Invalid email address format.';
        default:
          return 'Failed to send reset email. Please try again.';
      }
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Initialize admin account if it doesn't exist
  Future<void> initializeAdmin() async {
    try {
      final adminEmail = 'rizwanmehmood262@gmail.com';
      final adminPassword = 'riz12wan@';

      // Check if admin already exists
      final userDoc =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: adminEmail)
              .get();

      if (userDoc.docs.isEmpty) {
        // Create admin account
        final credential = await _auth.createUserWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );

        if (credential.user != null) {
          final adminData = UserModel(
            id: credential.user!.uid,
            email: adminEmail,
            name: 'Admin User',
            role: 'admin',
            phone: '+92300123456',
            address: 'Admin Office, Lahore, Pakistan',
            createdAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(credential.user!.uid)
              .set(adminData.toFirestore());

          await credential.user!.updateDisplayName('Admin User');
        }
      }
    } catch (e) {
      print('Error initializing admin: $e');
    }
  }
}
