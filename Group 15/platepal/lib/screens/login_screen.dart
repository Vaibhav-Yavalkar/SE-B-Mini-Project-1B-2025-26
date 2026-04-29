// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAdmin = false;
  bool _isLoggingIn = false;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Admin Credentials (only for the app maker)
  static const String adminEmail = "admin@platepal.com";
  static const String adminPassword = "maker";

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoggingIn = true);

    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    final provider = context.read<AppProvider>();

    // Add a small delay for realistic feel
    await Future.delayed(const Duration(milliseconds: 800));

    if (_isAdmin) {
      // Business/Admin Login Path
      if (email == adminEmail && pass == adminPassword) {
        await provider.login('admin');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/admin');
        }
      } else {
        setState(() => _isLoggingIn = false);
        if (email != adminEmail) {
          _showError('Registered Admin Email is incorrect');
        } else {
          _showError('Incorrect Admin Password');
        }
      }
    } else {
      // Normal User Login Path
      if (_isValidEmail(email) && pass.length >= 4) {
        // Prevent users from using the admin email in user mode if desired, 
        // but for now we just allow valid formatted emails.
        await provider.login('user');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() => _isLoggingIn = false);
        if (!_isValidEmail(email)) {
          _showError('Please enter a valid Gmail (e.g., name@gmail.com)');
        } else {
          _showError('Password must be at least 4 characters');
        }
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      '🍱',
                      style: TextStyle(fontSize: 64),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          _isAdmin ? 'Business Dashboard' : 'Welcome to PlatePal',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isAdmin 
                            ? 'Manage your surplus inventory' 
                            : 'Log in to save food and money',
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Professional Login Toggle
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _buildTypeButton('User', !_isAdmin, () => setState(() => _isAdmin = false)),
                        _buildTypeButton('Business', _isAdmin, () => setState(() => _isAdmin = true)),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Email Field
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoggingIn,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'name@gmail.com',
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v!.isEmpty ? 'Please enter your email' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Password Field
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: true,
                    enabled: !_isLoggingIn,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v!.isEmpty ? 'Please enter your password' : null,
                  ),
                  
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?', 
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Login Button with Loading State
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoggingIn ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: _isLoggingIn
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                          )
                        : Text(
                            _isAdmin ? 'Login as Retailer' : 'Login to Save Food',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  Center(
                    child: Wrap(
                      children: [
                        const Text("Don't have an account? ", 
                          style: TextStyle(color: AppTheme.textSecondary)),
                        GestureDetector(
                          onTap: () {},
                          child: const Text("Sign Up", 
                            style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [
              BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))
            ] : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
