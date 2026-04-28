import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyAPSIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const AuthGate(),
    );
  }
}




class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const _SplashScreen();
        }
        if (snap.data == null) return const RoleSelectionScreen();
        return const _RoleRouter();
      },
    );
  }
}

class _RoleRouter extends StatelessWidget {
  const _RoleRouter();
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final role = (snap.data!.data() as Map<String, dynamic>?)?['role'] ?? '';
        if (role == 'admin') return const AdminDashboard();
        if (role == 'teacher') return const TeacherDashboard();
        return const StudentDashboard();
      },
    );
  }
}


class _SplashScreen extends StatelessWidget {
  const _SplashScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF6A1B9A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school, size: 72, color: Colors.white),
              SizedBox(height: 20),
              Text('MyAPSIT',
                  style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2)),
              SizedBox(height: 8),
              Text('Learning Management System',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              SizedBox(height: 32),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}


class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF6A1B9A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text('MyAPSIT',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('Select your role to continue',
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 50),
                  _RoleCard(
                    icon: Icons.admin_panel_settings,
                    title: 'Admin',
                    subtitle: 'Manage courses, users & system',
                    color: Colors.red,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen(role: 'admin'))),
                  ),
                  const SizedBox(height: 16),
                  _RoleCard(
                    icon: Icons.cast_for_education,
                    title: 'Teacher',
                    subtitle: 'Manage classes, upload content',
                    color: Colors.deepPurple,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen(role: 'teacher'))),
                  ),
                  const SizedBox(height: 16),
                  _RoleCard(
                    icon: Icons.person,
                    title: 'Student',
                    subtitle: 'Access notes, assignments & more',
                    color: Colors.blue,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen(role: 'student'))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _RoleCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.8), radius: 26,
                child: Icon(icon, color: Colors.white, size: 26)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}


class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  Future<void> _login() async {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      _snack('Please enter email and password');
      return;
    }
    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );
      final uid = cred.user!.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!doc.exists) { _snack('User data not found'); await FirebaseAuth.instance.signOut(); return; }
      final role = doc.data()!['role'];
      if (role != widget.role) {
        _snack('Wrong role selected. You are registered as: $role');
        await FirebaseAuth.instance.signOut();
        return;
      }
      if (!mounted) return;
      if (role == 'admin') {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AdminDashboard()), (_) => false);
      } else if (role == 'teacher') {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const TeacherDashboard()), (_) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const StudentDashboard()), (_) => false);
      }
    } catch (e) {
      _snack('Login failed: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Color get _roleColor {
    if (widget.role == 'admin') return Colors.red.shade800;
    if (widget.role == 'teacher') return Colors.deepPurple.shade800;
    return Colors.blue.shade800;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_roleColor, _roleColor.withOpacity(0.6)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(alignment: Alignment.topLeft,
                  child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context))),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(children: [
                      Icon(widget.role == 'admin' ? Icons.admin_panel_settings :
                      widget.role == 'teacher' ? Icons.cast_for_education : Icons.person,
                          size: 70, color: Colors.white),
                      const SizedBox(height: 12),
                      Text('${widget.role[0].toUpperCase()}${widget.role.substring(1)} Login',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 32),
                      _buildField(_emailCtrl, 'Email', Icons.email, false),
                      const SizedBox(height: 16),
                      _buildField(_passCtrl, 'Password', Icons.lock, true),
                      const SizedBox(height: 32),
                      SizedBox(width: double.infinity, height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: _roleColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _loading
                              ? const SizedBox(width: 20, height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, bool isPassword) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: ctrl,
        obscureText: isPassword ? _obscure : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label, labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: isPassword ? IconButton(
              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
              onPressed: () => setState(() => _obscure = !_obscure)) : null,
          border: InputBorder.none, contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}


class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160, floating: false, pinned: true,
            backgroundColor: Colors.red.shade800,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(icon: const Icon(Icons.person_outline, color: Colors.white),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ProfileScreen(uid: uid)))),
              IconButton(icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()), (_) => false);
                  }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade900, Colors.red.shade600],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(height: 10),
                      Text('Admin Panel 🛡️',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Manage courses, users & system', style: TextStyle(color: Colors.white70)),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _SectionHeader('Course Management'),
                _AdminCard(icon: Icons.add_circle, color: Colors.indigo, title: 'Create Course',
                    subtitle: 'Add new course and assign a teacher',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateCourseScreen()))),
                _AdminCard(icon: Icons.list_alt, color: Colors.teal, title: 'All Courses',
                    subtitle: 'View, edit, and manage all courses',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllCoursesScreen()))),
                const SizedBox(height: 8),
                const _SectionHeader('User Management'),
                _AdminCard(icon: Icons.person_add, color: Colors.green, title: 'Create User',
                    subtitle: 'Register admin, teacher, or student',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateUserScreen()))),
                _AdminCard(icon: Icons.people, color: Colors.orange, title: 'All Users',
                    subtitle: 'View and manage all registered users',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllUsersScreen()))),
                _AdminCard(icon: Icons.school, color: Colors.purple, title: 'Enroll Students',
                    subtitle: 'Add students to specific courses',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EnrollStudentScreen()))),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _AdminCard({required this.icon, required this.color, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}




class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});
  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _nameCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _semCtrl = TextEditingController();
  final _sectionCtrl = TextEditingController();
  String? _selectedTeacherId;
  String? _selectedTeacherName;
  bool _loading = false;

  Future<void> _create() async {
    if (_nameCtrl.text.isEmpty || _subjectCtrl.text.isEmpty || _selectedTeacherId == null) {
      _snack('Fill all required fields and select a teacher');
      return;
    }
    setState(() => _loading = true);
    try {
      final courseRef = FirebaseFirestore.instance.collection('courses').doc();
      await courseRef.set({
        'name': _nameCtrl.text.trim(),
        'subject': _subjectCtrl.text.trim(),
        'semester': _semCtrl.text.trim(),
        'section': _sectionCtrl.text.trim(),
        'teacherId': _selectedTeacherId,
        'teacherName': _selectedTeacherName,
        'studentIds': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Link course to teacher
      await FirebaseFirestore.instance.collection('users').doc(_selectedTeacherId).update({
        'courseIds': FieldValue.arrayUnion([courseRef.id]),
      });
      if (mounted) {
        Navigator.pop(context);
        _snack('Course created successfully!');
      }
    } catch (e) {
      _snack('Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Course'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          _field(_nameCtrl, 'Course Name *', Icons.class_),
          const SizedBox(height: 12),
          _field(_subjectCtrl, 'Subject *', Icons.book),
          const SizedBox(height: 12),
          _field(_semCtrl, 'Semester', Icons.calendar_month),
          const SizedBox(height: 12),
          _field(_sectionCtrl, 'Section (e.g. A, B)', Icons.group),
          const SizedBox(height: 16),
          // Teacher picker
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users')
                .where('role', isEqualTo: 'teacher').snapshots(),
            builder: (ctx, snap) {
              if (!snap.hasData) return const CircularProgressIndicator();
              final teachers = snap.data!.docs;
              return DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Assign Teacher *', border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)),
                value: _selectedTeacherId,
                items: teachers.map((t) => DropdownMenuItem(
                  value: t.id,
                  child: Text((t.data() as Map)['name'] ?? t.id),
                )).toList(),
                onChanged: (v) {
                  setState(() {
                    _selectedTeacherId = v;
                    _selectedTeacherName = (teachers.firstWhere((t) => t.id == v).data() as Map)['name'];
                  });
                },
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _create,
              icon: const Icon(Icons.add),
              label: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Create Course'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon) {
    return TextField(controller: ctrl,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), prefixIcon: Icon(icon)));
  }
}



class AllCoursesScreen extends StatelessWidget {
  const AllCoursesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Courses'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('courses').orderBy('createdAt', descending: true).snapshots(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No courses yet. Create one from Admin panel.'));
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (ctx, i) {
              final d = docs[i].data() as Map<String, dynamic>;
              final studentCount = (d['studentIds'] as List?)?.length ?? 0;
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: CircleAvatar(backgroundColor: Colors.teal.shade100,
                      child: const Icon(Icons.class_, color: Colors.teal)),
                  title: Text(d['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Subject: ${d["subject"] ?? ""} | Sem: ${d["semester"] ?? ""} | Sec: ${d["section"] ?? ""}'),
                    Text('Teacher: ${d["teacherName"] ?? "Not assigned"} • $studentCount students',
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete Course'),
                            content: const Text('This will delete the course. Are you sure?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                            ],
                          ));
                      if (confirm == true) {
                        await FirebaseFirestore.instance.collection('courses').doc(docs[i].id).delete();
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});
  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _deptCtrl = TextEditingController();
  String _role = 'student';
  bool _loading = false;

  Future<void> _create() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      _snack('Fill all required fields');
      return;
    }
    setState(() => _loading = true);
    // Use a secondary Firebase App instance so the admin stays logged in.
    FirebaseApp? secondaryApp;
    try {
      secondaryApp = await Firebase.initializeApp(
        name: 'secondary_user_creation',
        options: Firebase.app().options,
      );
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
      final cred = await secondaryAuth.createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(), password: _passCtrl.text.trim());
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'role': _role,
        'department': _deptCtrl.text.trim(),
        'courseIds': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
      await secondaryAuth.signOut();
      if (mounted) {
        Navigator.pop(context);
        _snack('User "${_nameCtrl.text.trim()}" created successfully!');
      }
    } catch (e) {
      _snack('Error: $e');
    } finally {
      // Always delete the secondary app to free resources
      await secondaryApp?.delete();
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create User'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade200)),
            child: const Row(children: [
              Icon(Icons.check_circle_outline, color: Colors.green),
              SizedBox(width: 8),
              Expanded(child: Text('You will remain logged in as admin after creating a user.',
                  style: TextStyle(fontSize: 12, color: Colors.green))),
            ]),
          ),
          _field(_nameCtrl, 'Full Name *', Icons.person),
          const SizedBox(height: 12),
          _field(_emailCtrl, 'Email *', Icons.email),
          const SizedBox(height: 12),
          _field(_passCtrl, 'Password *', Icons.lock),
          const SizedBox(height: 12),
          _field(_deptCtrl, 'Department', Icons.school),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _role,
            decoration: const InputDecoration(labelText: 'Role', border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge)),
            items: ['admin', 'teacher', 'student'].map((r) =>
                DropdownMenuItem(value: r, child: Text(r[0].toUpperCase() + r.substring(1)))).toList(),
            onChanged: (v) => setState(() => _role = v!),
          ),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _create,
              icon: const Icon(Icons.person_add),
              label: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Create User'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon) {
    return TextField(controller: ctrl,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), prefixIcon: Icon(icon)));
  }
}



class AllUsersScreen extends StatelessWidget {
  const AllUsersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Users'), backgroundColor: Colors.orange, foregroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').orderBy('role').snapshots(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No users registered yet'));
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (ctx, i) {
              final d = docs[i].data() as Map<String, dynamic>;
              final role = d['role'] ?? '';
              final roleColor = role == 'admin' ? Colors.red : role == 'teacher' ? Colors.deepPurple : Colors.blue;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: roleColor.withOpacity(0.15),
                      child: Text((d['name'] ?? '?')[0].toUpperCase(),
                          style: TextStyle(color: roleColor, fontWeight: FontWeight.bold))),
                  title: Text(d['name'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(d['email'] ?? ''),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: roleColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(role.toUpperCase(), style: TextStyle(color: roleColor, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



class EnrollStudentScreen extends StatefulWidget {
  const EnrollStudentScreen({super.key});
  @override
  State<EnrollStudentScreen> createState() => _EnrollStudentScreenState();
}

class _EnrollStudentScreenState extends State<EnrollStudentScreen> {
  String? _selectedStudentId;
  String? _selectedCourseId;
  bool _loading = false;

  Future<void> _enroll() async {
    if (_selectedStudentId == null || _selectedCourseId == null) {
      _snack('Select both a student and a course');
      return;
    }
    setState(() => _loading = true);
    try {
      // Add student to course's studentIds array
      await FirebaseFirestore.instance.collection('courses').doc(_selectedCourseId).update({
        'studentIds': FieldValue.arrayUnion([_selectedStudentId]),
      });
      // Add course to student's courseIds array
      await FirebaseFirestore.instance.collection('users').doc(_selectedStudentId).update({
        'courseIds': FieldValue.arrayUnion([_selectedCourseId]),
      });
      if (mounted) _snack('Student enrolled successfully!');
    } catch (e) {
      _snack('Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enroll Student'), backgroundColor: Colors.purple, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // Student picker
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'student').snapshots(),
            builder: (ctx, snap) {
              if (!snap.hasData) return const CircularProgressIndicator();
              return DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Student', border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)),
                value: _selectedStudentId,
                items: snap.data!.docs.map((s) => DropdownMenuItem(
                    value: s.id, child: Text((s.data() as Map)['name'] ?? s.id))).toList(),
                onChanged: (v) => setState(() => _selectedStudentId = v),
              );
            },
          ),
          const SizedBox(height: 16),
          // Course picker
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('courses').snapshots(),
            builder: (ctx, snap) {
              if (!snap.hasData) return const CircularProgressIndicator();
              return DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Course', border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.class_)),
                value: _selectedCourseId,
                items: snap.data!.docs.map((c) {
                  final d = c.data() as Map<String, dynamic>;
                  return DropdownMenuItem(value: c.id, child: Text('${d["name"]} (${d["subject"]})'));
                }).toList(),
                onChanged: (v) => setState(() => _selectedCourseId = v),
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _enroll,
              icon: const Icon(Icons.how_to_reg),
              label: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Enroll Student'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
        ]),
      ),
    );
  }
}


class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180, floating: false, pinned: true,
            backgroundColor: Colors.indigo,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(icon: const Icon(Icons.person_outline, color: Colors.white),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(uid: uid)))),
              IconButton(icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()), (_) => false);
                  }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
                      builder: (ctx, snap) {
                        final data = snap.hasData ? (snap.data!.data() as Map<String, dynamic>?) : null;
                        final name = data?['name'] ?? 'Student';
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const SizedBox(height: 10),
                          Text('Hello, $name! 👋',
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(DateFormat('EEEE, MMM d').format(DateTime.now()),
                              style: const TextStyle(color: Colors.white70)),
                        ]);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _SectionHeader('My Courses'),
                _MyCoursesList(uid: uid, role: 'student'),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}


class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180, floating: false, pinned: true,
            backgroundColor: Colors.deepPurple,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(icon: const Icon(Icons.person_outline, color: Colors.white),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(uid: uid)))),
              IconButton(icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()), (_) => false);
                  }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
                        builder: (ctx, snap) {
                          if (!snap.hasData || snap.data?.data() == null) {
                            return const Text(
                              "Welcome, Teacher!",
                              style: TextStyle(color: Colors.white),
                            );
                          }

                          final data = snap.data!.data() as Map<String, dynamic>;
                          final name = data['name'] ?? 'Teacher';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                'Welcome, $name! ',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('EEEE, MMM d').format(DateTime.now()),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          );
                        }
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _SectionHeader('My Courses'),
                _MyCoursesList(uid: uid, role: 'teacher'),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}




class _MyCoursesList extends StatelessWidget {
  final String uid;
  final String role;
  const _MyCoursesList({required this.uid, required this.role});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (ctx, userSnap) {
        if (!userSnap.hasData) return const Center(child: CircularProgressIndicator());
        final userData = userSnap.data!.data() as Map<String, dynamic>?;
        final courseIds = List<String>.from(userData?['courseIds'] ?? []);
        if (courseIds.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
            child: Column(children: [
              Icon(Icons.school_outlined, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(role == 'student' ? 'No courses enrolled yet.\nAsk admin to enroll you.' :
              'No courses assigned yet.\nAsk admin to assign a course.',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
            ]),
          );
        }
        return Column(
          children: courseIds.map((courseId) => _CourseCard(courseId: courseId, role: role)).toList(),
        );
      },
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String courseId;
  final String role;
  const _CourseCard({required this.courseId, required this.role});

  static const _gradients = [
    [Color(0xFF1A237E), Color(0xFF3949AB)],
    [Color(0xFF4A148C), Color(0xFF7B1FA2)],
    [Color(0xFF006064), Color(0xFF00838F)],
    [Color(0xFF1B5E20), Color(0xFF388E3C)],
    [Color(0xFF880E4F), Color(0xFFC2185B)],
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('courses').doc(courseId).snapshots(),
      builder: (ctx, snap) {
        if (!snap.hasData || !snap.data!.exists) return const SizedBox.shrink();
        final d = snap.data!.data() as Map<String, dynamic>;
        final idx = courseId.hashCode % _gradients.length;
        final gradient = _gradients[idx.abs()];
        final studentCount = (d['studentIds'] as List?)?.length ?? 0;

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => CourseScreen(courseId: courseId, courseName: d['name'] ?? '', role: role))),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: gradient.last.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(d['name'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${d["subject"] ?? ""} • Sem ${d["semester"] ?? ""} • Sec ${d["section"] ?? ""}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  if (role == 'student')
                    Text('Teacher: ${d["teacherName"] ?? ""}', style: const TextStyle(color: Colors.white60, fontSize: 12))
                  else
                    Text('$studentCount students enrolled', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                ]),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
            ]),
          ),
        );
      },
    );
  }
}



class CourseScreen extends StatelessWidget {
  final String courseId;
  final String courseName;
  final String role;
  const CourseScreen({super.key, required this.courseId, required this.courseName, required this.role});

  @override
  Widget build(BuildContext context) {
    final isTeacher = role == 'teacher';
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(courseName),
        backgroundColor: isTeacher ? Colors.deepPurple : Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Announcement banner
          if (!isTeacher) _CourseAnnouncementBanner(courseId: courseId),
          if (!isTeacher) const SizedBox(height: 16),
          if (isTeacher) ...[
            const _SectionHeader('Teaching Tools'),
            _CourseFeatureCard(icon: Icons.upload_file, color: Colors.blue, title: 'Upload Study Materials',
                subtitle: 'Share notes and PDFs with students',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => UploadNotesScreen(courseId: courseId)))),
            _CourseFeatureCard(icon: Icons.assignment_add, color: Colors.orange, title: 'Upload Assignment',
                subtitle: 'Create new assignment for students',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => UploadAssignmentScreen(courseId: courseId)))),
            _CourseFeatureCard(icon: Icons.campaign, color: Colors.amber.shade700, title: 'Post Announcement',
                subtitle: 'Notify all students instantly',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => PostAnnouncementScreen(courseId: courseId)))),
            _CourseFeatureCard(icon: Icons.grade, color: Colors.pink, title: 'Manage Grades',
                subtitle: 'Enter student marks and results',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ManageGradesScreen(courseId: courseId)))),
            const SizedBox(height: 8),
            const _SectionHeader('Class Management'),
            _CourseFeatureCard(icon: Icons.assignment, color: Colors.teal, title: 'Check Submissions',
                subtitle: 'Review student assignment submissions',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CheckSubmissionsScreen(courseId: courseId)))),
            _CourseFeatureCard(icon: Icons.how_to_reg, color: Colors.green, title: 'Mark Attendance',
                subtitle: 'Record student attendance',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => TeacherAttendanceScreen(courseId: courseId)))),
            _CourseFeatureCard(icon: Icons.schedule, color: Colors.cyan, title: 'Manage Timetable',
                subtitle: 'Update class schedule',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ManageTimetableScreen(courseId: courseId)))),
            _CourseFeatureCard(icon: Icons.forum, color: Colors.purple, title: 'Discussion Forum',
                subtitle: 'Answer student questions',
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => DiscussionScreen(courseId: courseId)))),
          ] else ...[
            const _SectionHeader('Quick Access'),
            GridView.count(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1,
              children: [
                _DashCard(icon: Icons.calendar_today, label: 'Attendance',
                    gradient: [Colors.blue.shade400, Colors.blue.shade700],
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => AttendanceScreen(courseId: courseId, studentId: uid)))),
                _DashCard(icon: Icons.menu_book, label: 'Notes',
                    gradient: [Colors.green.shade400, Colors.teal.shade700],
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => NotesScreen(courseId: courseId)))),
                _DashCard(icon: Icons.assignment, label: 'Assignments',
                    gradient: [Colors.orange.shade400, Colors.deepOrange.shade700],
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => AssignmentsScreen(courseId: courseId)))),
                _DashCard(icon: Icons.forum, label: 'Discussion',
                    gradient: [Colors.purple.shade400, Colors.deepPurple.shade700],
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => DiscussionScreen(courseId: courseId)))),
                _DashCard(icon: Icons.schedule, label: 'Timetable',
                    gradient: [Colors.cyan.shade400, Colors.cyan.shade800],
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => TimetableScreen(courseId: courseId)))),
                _DashCard(icon: Icons.grade, label: 'Grades',
                    gradient: [Colors.pink.shade400, Colors.red.shade700],
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => GradesScreen(courseId: courseId, studentId: uid)))),
              ],
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _CourseFeatureCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _CourseFeatureCard({required this.icon, required this.color, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10), elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

class _CourseAnnouncementBanner extends StatelessWidget {
  final String courseId;
  const _CourseAnnouncementBanner({required this.courseId});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses').doc(courseId).collection('announcements')
          .orderBy('timestamp', descending: true).limit(1).snapshots(),
      builder: (ctx, snap) {
        if (!snap.hasData || snap.data!.docs.isEmpty) return const SizedBox.shrink();
        final doc = snap.data!.docs.first;
        final d = doc.data() as Map<String, dynamic>;
        return GestureDetector(
          onTap: () => showDialog(context: ctx, builder: (_) => AlertDialog(
            title: Row(children: [
              const Icon(Icons.campaign, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(child: Text(d['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold))),
            ]),
            content: Text(d['content'] ?? ''),
            actions: [
              TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('courses').doc(courseId)
                      .collection('announcements').doc(doc.id).delete();
                  Navigator.pop(context);
                },
                child: const Text('Dismiss', style: TextStyle(color: Colors.red)),
              ),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
            ],
          )),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.amber.shade600, Colors.orange.shade500]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              const Icon(Icons.campaign, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Latest Announcement', style: TextStyle(color: Colors.white70, fontSize: 11)),
                Text(d['title'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ])),
            ]),
          ),
        );
      },
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
    );
  }
}

class _DashCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;
  const _DashCard({required this.icon, required this.label, required this.gradient, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: gradient.last.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 42, color: Colors.white),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ]),
      ),
    );
  }
}




class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _deptCtrl = TextEditingController();
  bool _editing = false;
  bool _loading = true;
  Map<String, dynamic> _data = {};

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
    if (doc.exists) {
      _data = doc.data()!;
      _nameCtrl.text = _data['name'] ?? '';
      _phoneCtrl.text = _data['phone'] ?? '';
      _deptCtrl.text = _data['department'] ?? '';
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
      'name': _nameCtrl.text, 'phone': _phoneCtrl.text, 'department': _deptCtrl.text,
    });
    setState(() => _editing = false);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), backgroundColor: Colors.indigo, foregroundColor: Colors.white,
          actions: [IconButton(icon: Icon(_editing ? Icons.close : Icons.edit),
              onPressed: () => setState(() => _editing = !_editing))]),
      body: _loading ? const Center(child: CircularProgressIndicator()) :
      SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          CircleAvatar(radius: 50, backgroundColor: Colors.indigo.shade100,
              child: Text((_nameCtrl.text.isNotEmpty ? _nameCtrl.text[0] : '?').toUpperCase(),
                  style: const TextStyle(fontSize: 40, color: Colors.indigo))),
          const SizedBox(height: 8),
          Text(_data['role']?.toString().toUpperCase() ?? '',
              style: TextStyle(color: Colors.indigo.shade400, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
                _ProfileField(label: 'Full Name', ctrl: _nameCtrl, icon: Icons.person, enabled: _editing),
                const Divider(),
                _ProfileField(label: 'Email', ctrl: TextEditingController(text: _data['email'] ?? ''),
                    icon: Icons.email, enabled: false),
                const Divider(),
                _ProfileField(label: 'Phone', ctrl: _phoneCtrl, icon: Icons.phone, enabled: _editing),
                const Divider(),
                _ProfileField(label: 'Department', ctrl: _deptCtrl, icon: Icons.school, enabled: _editing),
              ]))),
          if (_editing) ...[
            const SizedBox(height: 20),
            SizedBox(width: double.infinity,
                child: ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.save),
                    label: const Text('Save Changes'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
          ],
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) => const RoleSelectionScreen()), (_) => false);
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Logout', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
          ),
        ]),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final IconData icon;
  final bool enabled;
  const _ProfileField({required this.label, required this.ctrl, required this.icon, required this.enabled});
  @override
  Widget build(BuildContext context) {
    return TextField(controller: ctrl, enabled: enabled,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: Colors.indigo), border: InputBorder.none));
  }
}


class PostAnnouncementScreen extends StatefulWidget {
  final String courseId;
  const PostAnnouncementScreen({super.key, required this.courseId});
  @override
  State<PostAnnouncementScreen> createState() => _PostAnnouncementScreenState();
}

class _PostAnnouncementScreenState extends State<PostAnnouncementScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _post() async {
    if (_titleCtrl.text.isEmpty || _contentCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all fields')));
      return;
    }
    setState(() => _loading = true);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final name = userDoc.data()?['name'] ?? 'Teacher';
    await FirebaseFirestore.instance
        .collection('courses').doc(widget.courseId).collection('announcements').add({
      'title': _titleCtrl.text.trim(),
      'content': _contentCtrl.text.trim(),
      'postedBy': name,
      'teacherId': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Announcement posted!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Announcement'), backgroundColor: Colors.amber.shade700, foregroundColor: Colors.white),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        TextField(controller: _titleCtrl,
            decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder(), prefixIcon: Icon(Icons.title))),
        const SizedBox(height: 16),
        TextField(controller: _contentCtrl, maxLines: 6,
            decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder(),
                alignLabelWithHint: true, prefixIcon: Icon(Icons.description))),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity,
          child: ElevatedButton.icon(onPressed: _loading ? null : _post, icon: const Icon(Icons.send),
              label: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Post Announcement'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14))),
        ),
      ])),
    );
  }
}




class TimetableScreen extends StatelessWidget {
  final String courseId;
  const TimetableScreen({super.key, required this.courseId});
  @override
  Widget build(BuildContext context) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final today = DateFormat('EEEE').format(DateTime.now());
    return DefaultTabController(
      length: days.length,
      initialIndex: days.contains(today) ? days.indexOf(today) : 0,
      child: Scaffold(
        appBar: AppBar(title: const Text('Timetable'), backgroundColor: Colors.cyan.shade700, foregroundColor: Colors.white,
            bottom: TabBar(isScrollable: true, labelColor: Colors.white, unselectedLabelColor: Colors.white60,
                indicatorColor: Colors.white, tabs: days.map((d) => Tab(text: d.substring(0, 3))).toList())),
        body: TabBarView(children: days.map((day) => _DayTimetable(courseId: courseId, day: day)).toList()),
      ),
    );
  }
}

class _DayTimetable extends StatelessWidget {
  final String courseId;
  final String day;
  const _DayTimetable({required this.courseId, required this.day});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses').doc(courseId).collection('timetable').doc(day).snapshots(),
      builder: (ctx, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        if (!snap.data!.exists) return const Center(child: Text('No schedule for this day'));
        final data = snap.data!.data() as Map<String, dynamic>;
        final slots = (data['slots'] as List<dynamic>? ?? []).map((e) => e as Map<String, dynamic>).toList();
        if (slots.isEmpty) return const Center(child: Text('No classes scheduled'));
        return ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: slots.length,
          itemBuilder: (ctx, i) {
            final slot = slots[i];
            return _TimetableCard(time: slot['time'] ?? '', subject: slot['subject'] ?? '',
                teacher: slot['teacher'] ?? '', room: slot['room'] ?? '', index: i);
          },
        );
      },
    );
  }
}

class _TimetableCard extends StatelessWidget {
  final String time, subject, teacher, room;
  final int index;
  const _TimetableCard({required this.time, required this.subject, required this.teacher, required this.room, required this.index});
  @override
  Widget build(BuildContext context) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.pink];
    final c = colors[index % colors.length];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Container(width: 6, height: 80, decoration: BoxDecoration(color: c,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)))),
        Expanded(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.schedule, size: 14, color: c),
            const SizedBox(width: 4),
            Text(time, style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 12)),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(room, style: TextStyle(color: c, fontSize: 11))),
          ]),
          const SizedBox(height: 6),
          Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 2),
          Text(teacher, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]))),
      ]),
    );
  }
}

class ManageTimetableScreen extends StatefulWidget {
  final String courseId;
  const ManageTimetableScreen({super.key, required this.courseId});
  @override
  State<ManageTimetableScreen> createState() => _ManageTimetableScreenState();
}

class _ManageTimetableScreenState extends State<ManageTimetableScreen> {
  final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  String _selectedDay = 'Monday';
  final _timeCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _teacherCtrl = TextEditingController();
  final _roomCtrl = TextEditingController();

  CollectionReference get _ttRef =>
      FirebaseFirestore.instance.collection('courses').doc(widget.courseId).collection('timetable');

  Future<void> _addSlot() async {
    if (_timeCtrl.text.isEmpty || _subjectCtrl.text.isEmpty) return;
    final ref = _ttRef.doc(_selectedDay);
    final doc = await ref.get();
    List slots = doc.exists ? ((doc.data() as Map)['slots'] ?? []) : [];
    slots.add({'time': _timeCtrl.text, 'subject': _subjectCtrl.text, 'teacher': _teacherCtrl.text, 'room': _roomCtrl.text});
    await ref.set({'slots': slots});
    _timeCtrl.clear(); _subjectCtrl.clear(); _teacherCtrl.clear(); _roomCtrl.clear();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Slot added')));
  }

  Future<void> _deleteSlot(int idx) async {
    final ref = _ttRef.doc(_selectedDay);
    final doc = await ref.get();
    List slots = doc.exists ? ((doc.data() as Map)['slots'] ?? []) : [];
    slots.removeAt(idx);
    await ref.set({'slots': slots});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Timetable'), backgroundColor: Colors.cyan.shade700, foregroundColor: Colors.white),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(value: _selectedDay,
                decoration: const InputDecoration(labelText: 'Select Day', border: OutlineInputBorder()),
                items: days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => setState(() => _selectedDay = v!))),
        Expanded(
          child: StreamBuilder<DocumentSnapshot>(
            stream: _ttRef.doc(_selectedDay).snapshots(),
            builder: (ctx, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final slots = snap.data!.exists
                  ? ((snap.data!.data() as Map)['slots'] ?? []).cast<Map<String, dynamic>>()
                  : <Map<String, dynamic>>[];
              return ListView.builder(
                itemCount: slots.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(slots[i]['subject'] ?? ''),
                  subtitle: Text('${slots[i]["time"]} | ${slots[i]["room"]}'),
                  trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteSlot(i)),
                ),
              );
            },
          ),
        ),
        Card(margin: const EdgeInsets.all(12), child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Add New Slot', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: _timeCtrl,
                decoration: const InputDecoration(labelText: 'Time (e.g. 9:00-10:00)', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: _subjectCtrl,
                decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: _teacherCtrl,
                decoration: const InputDecoration(labelText: 'Teacher', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: _roomCtrl,
                decoration: const InputDecoration(labelText: 'Room', border: OutlineInputBorder()))),
          ]),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity,
              child: ElevatedButton(onPressed: _addSlot, child: const Text('Add Slot'))),
        ]))),
      ]),
    );
  }
}



class GradesScreen extends StatelessWidget {
  final String courseId;
  final String studentId;
  const GradesScreen({super.key, required this.courseId, required this.studentId});

  Color _gradeColor(int m, int mx) {
    final p = m / mx;
    if (p >= 0.75) return Colors.green;
    if (p >= 0.50) return Colors.orange;
    return Colors.red;
  }

  String _gradeLabel(int m, int mx) {
    final p = m / mx;
    if (p >= 0.90) return 'O';
    if (p >= 0.80) return 'A+';
    if (p >= 0.70) return 'A';
    if (p >= 0.60) return 'B+';
    if (p >= 0.50) return 'B';
    return 'F';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Grades'), backgroundColor: Colors.pink.shade700, foregroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses').doc(courseId).collection('grades')
            .where('studentId', isEqualTo: studentId)
            .snapshots(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No grades yet'));
          // Group by examType
          final Map<String, List<Map<String, dynamic>>> grouped = {};
          for (var doc in docs) {
            final d = doc.data() as Map<String, dynamic>;
            final exam = d['examType'] ?? 'Other';
            grouped.putIfAbsent(exam, () => []).add(d);
          }
          return ListView(
            padding: const EdgeInsets.all(12),
            children: grouped.entries.map((entry) {
              final subjects = entry.value;
              final totalMarks = subjects.fold<int>(0, (s, e) => s + ((e['marks'] as num?)?.toInt() ?? 0));
              final totalMax = subjects.fold<int>(0, (s, e) => s + ((e['maxMarks'] as num?)?.toInt() ?? 100));
              return Card(margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Column(children: [
                  Padding(padding: const EdgeInsets.all(14),
                      child: Row(children: [
                        const Icon(Icons.quiz, color: Colors.pink),
                        const SizedBox(width: 8),
                        Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Spacer(),
                        Text('$totalMarks/$totalMax', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ])),
                  ...subjects.map((s) {
                    final m = (s['marks'] as num?)?.toInt() ?? 0;
                    final mx = (s['maxMarks'] as num?)?.toInt() ?? 100;
                    return ListTile(
                      title: Text(s['subject'] ?? ''),
                      subtitle: LinearProgressIndicator(value: m / mx, backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(_gradeColor(m, mx))),
                      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('$m/$mx', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(_gradeLabel(m, mx), style: TextStyle(color: _gradeColor(m, mx), fontWeight: FontWeight.bold)),
                      ]),
                    );
                  }),
                ]),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class ManageGradesScreen extends StatefulWidget {
  final String courseId;
  const ManageGradesScreen({super.key, required this.courseId});
  @override
  State<ManageGradesScreen> createState() => _ManageGradesScreenState();
}

class _ManageGradesScreenState extends State<ManageGradesScreen> {
  final _marksCtrl = TextEditingController();
  final _maxCtrl = TextEditingController(text: '100');
  String _selectedSubject = 'DBMS';
  String _selectedExam = 'Mid-Sem';
  final subjects = ['DBMS', 'CT', 'MDM', 'OS', 'OE', 'DT'];
  final exams = ['Mid-Sem', 'End-Sem', 'Unit Test 1', 'Unit Test 2'];
  String? _selectedStudentId;
  String? _selectedStudentName;

  Future<void> _saveGrade() async {
    if (_selectedStudentId == null || _marksCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all fields')));
      return;
    }
    await FirebaseFirestore.instance
        .collection('courses').doc(widget.courseId).collection('grades').add({
      'studentId': _selectedStudentId,
      'studentName': _selectedStudentName,
      'subject': _selectedSubject,
      'examType': _selectedExam,
      'marks': int.tryParse(_marksCtrl.text) ?? 0,
      'maxMarks': int.tryParse(_maxCtrl.text) ?? 100,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _marksCtrl.clear();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grade saved!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Grades'), backgroundColor: Colors.pink.shade700, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Select Student', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // Pull students enrolled in THIS course only
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('courses').doc(widget.courseId).snapshots(),
            builder: (ctx, courseSnap) {
              if (!courseSnap.hasData) return const CircularProgressIndicator();
              final studentIds = List<String>.from((courseSnap.data!.data() as Map)['studentIds'] ?? []);
              if (studentIds.isEmpty) return const Text('No students enrolled in this course yet.');
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('users')
                    .where(FieldPath.documentId, whereIn: studentIds).get(),
                builder: (ctx, snap) {
                  if (!snap.hasData) return const CircularProgressIndicator();
                  final students = snap.data!.docs;
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Student'),
                    value: _selectedStudentId,
                    items: students.map((s) => DropdownMenuItem(
                        value: s.id, child: Text((s.data() as Map)['name'] ?? s.id))).toList(),
                    onChanged: (v) => setState(() {
                      _selectedStudentId = v;
                      _selectedStudentName = (students.firstWhere((s) => s.id == v).data() as Map)['name'];
                    }),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: DropdownButtonFormField<String>(value: _selectedSubject,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Subject'),
                items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _selectedSubject = v!))),
            const SizedBox(width: 10),
            Expanded(child: DropdownButtonFormField<String>(value: _selectedExam,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Exam'),
                items: exams.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _selectedExam = v!))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _marksCtrl, keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Marks Obtained', border: OutlineInputBorder()))),
            const SizedBox(width: 10),
            Expanded(child: TextField(controller: _maxCtrl, keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Max Marks', border: OutlineInputBorder()))),
          ]),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity,
              child: ElevatedButton.icon(onPressed: _saveGrade, icon: const Icon(Icons.save), label: const Text('Save Grade'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade700, foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14)))),
          const SizedBox(height: 24),
          const Text('Recent Grades', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('courses').doc(widget.courseId).collection('grades')
                .orderBy('timestamp', descending: true).limit(20).snapshots(),
            builder: (ctx, snap) {
              if (!snap.hasData) return const CircularProgressIndicator();
              return Column(children: snap.data!.docs.map((d) {
                final data = d.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text('${data["studentName"]} - ${data["subject"]}'),
                  subtitle: Text('${data["examType"]}'),
                  trailing: Text('${data["marks"]}/${data["maxMarks"]}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              }).toList());
            },
          ),
        ]),
      ),
    );
  }
}


class AttendanceScreen extends StatefulWidget {
  final String courseId;
  final String studentId;
  const AttendanceScreen({super.key, required this.courseId, required this.studentId});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Subjects are now fetched from the course's timetable or a configurable list.
  // For backward compatibility we use the same subject list; you can make this dynamic.
  final subjects = ['DBMS', 'CT', 'MDM', 'OS', 'OE', 'DT'];

  Color getColor(double percent) {
    if (percent >= 75) return Colors.green;
    if (percent >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses').doc(widget.courseId).collection('attendance').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No attendance data'));
          }
          var docs = snapshot.data!.docs;
          int overallPresent = 0, overallTotal = 0;
          for (var doc in docs) {
            var data = doc.data() as Map<String, dynamic>;
            if ((data['day'] ?? '') == 'Saturday' || (data['day'] ?? '') == 'Sunday') continue;
            for (var subject in subjects) {
              var sd = data[subject] as Map<String, dynamic>?;
              if (sd == null || sd.isEmpty) continue;
              overallTotal++;
              if (sd[widget.studentId] == 'present') overallPresent++;
            }
          }
          double overallPercent = overallTotal == 0 ? 0 : (overallPresent / overallTotal) * 100;
          return Column(children: [
            Padding(padding: const EdgeInsets.all(12),
                child: Card(color: getColor(overallPercent).withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
                      Row(children: [
                        const Icon(Icons.pie_chart, color: Colors.indigo),
                        const SizedBox(width: 8),
                        const Text('Overall Attendance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Spacer(),
                        Text('${overallPercent.toStringAsFixed(1)}%',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: getColor(overallPercent))),
                      ]),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(value: overallTotal == 0 ? 0 : overallPresent / overallTotal,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(getColor(overallPercent)),
                          minHeight: 8, borderRadius: BorderRadius.circular(4)),
                      const SizedBox(height: 6),
                      Text('Present: $overallPresent / $overallTotal classes',
                          style: const TextStyle(color: Colors.grey)),
                    ])))),
            Expanded(child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                String subject = subjects[index];
                int present = 0, total = 0;
                for (var doc in docs) {
                  var data = doc.data() as Map<String, dynamic>;
                  if ((data['day'] ?? '') == 'Saturday' || (data['day'] ?? '') == 'Sunday') continue;
                  var sd = data[subject] as Map<String, dynamic>?;
                  if (sd == null || sd.isEmpty) continue;
                  total++;
                  if (sd[widget.studentId] == 'present') present++;
                }
                double percent = total == 0 ? 0 : (present / total) * 100;
                return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const Spacer(),
                        Text('${percent.toStringAsFixed(1)}%',
                            style: TextStyle(fontWeight: FontWeight.bold, color: getColor(percent), fontSize: 16)),
                      ]),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: total == 0 ? 0 : present / total,
                          backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation(getColor(percent)),
                          minHeight: 6, borderRadius: BorderRadius.circular(3)),
                      const SizedBox(height: 4),
                      Text('$present / $total classes', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ])));
              },
            )),
          ]);
        },
      ),
    );
  }
}




class TeacherAttendanceScreen extends StatefulWidget {
  final String courseId;
  const TeacherAttendanceScreen({super.key, required this.courseId});
  @override
  State<TeacherAttendanceScreen> createState() => _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  Map<String, String> attendance = {};
  String selectedSubject = 'DBMS';
  final subjects = ['DBMS', 'CT', 'MDM', 'OS', 'OE', 'DT'];

  bool isWeekend() {
    String day = DateFormat('EEEE').format(DateTime.now());
    return day == 'Saturday' || day == 'Sunday';
  }

  Future<void> saveAttendance() async {
    String today = DateTime.now().toString().substring(0, 10);
    String day = DateFormat('EEEE').format(DateTime.now());
    if (isWeekend()) { _snack('No attendance on weekends'); return; }
    await FirebaseFirestore.instance
        .collection('courses').doc(widget.courseId).collection('attendance').doc(today).set({
      selectedSubject: attendance,
      'date': today,
      'day': day,
    }, SetOptions(merge: true));
    _snack('Attendance saved!');
  }

  Future<void> _markAll(String status, List<QueryDocumentSnapshot> students) async {
    for (var doc in students) { attendance[doc.id] = status; }
    setState(() {});
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    bool weekend = isWeekend();
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('courses').doc(widget.courseId).snapshots(),
        builder: (ctx, courseSnap) {
          if (!courseSnap.hasData) return const Center(child: CircularProgressIndicator());
          final studentIds = List<String>.from((courseSnap.data!.data() as Map)['studentIds'] ?? []);
          if (studentIds.isEmpty) {
            return const Center(child: Text('No students enrolled in this course.'));
          }
          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('users')
                .where(FieldPath.documentId, whereIn: studentIds).get(),
            builder: (ctx, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final students = snap.data!.docs;
              return Column(children: [
                Padding(padding: const EdgeInsets.all(12),
                    child: DropdownButtonFormField<String>(value: selectedSubject,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Subject'),
                        items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) => setState(() { selectedSubject = v!; attendance.clear(); }))),
                if (weekend)
                  Container(margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200)),
                      child: const Row(children: [
                        Icon(Icons.warning, color: Colors.red), SizedBox(width: 8),
                        Text('Weekend - Attendance Disabled', style: TextStyle(color: Colors.red)),
                      ])),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(children: [
                      Expanded(child: ElevatedButton.icon(
                          onPressed: weekend ? null : () => _markAll('present', students),
                          icon: const Icon(Icons.check), label: const Text('All Present'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white))),
                      const SizedBox(width: 10),
                      Expanded(child: ElevatedButton.icon(
                          onPressed: weekend ? null : () => _markAll('absent', students),
                          icon: const Icon(Icons.close), label: const Text('All Absent'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white))),
                    ])),
                Expanded(child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    final uid = student.id;
                    final name = (student.data() as Map)['name'] ?? 'Unknown';
                    final status = attendance[uid];
                    return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: status == 'present' ? Colors.green.shade100 :
                              status == 'absent' ? Colors.red.shade100 : Colors.grey.shade200,
                              child: Text(name[0].toUpperCase())),
                          title: Text(name),
                          subtitle: Text(status ?? 'Not marked',
                              style: TextStyle(color: status == 'present' ? Colors.green :
                              status == 'absent' ? Colors.red : Colors.grey)),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(icon: Icon(Icons.check_circle, color: status == 'present' ? Colors.green : Colors.grey),
                                onPressed: weekend ? null : () => setState(() => attendance[uid] = 'present')),
                            IconButton(icon: Icon(Icons.cancel, color: status == 'absent' ? Colors.red : Colors.grey),
                                onPressed: weekend ? null : () => setState(() => attendance[uid] = 'absent')),
                          ]),
                        ));
                  },
                )),
                Padding(padding: const EdgeInsets.all(16),
                    child: SizedBox(width: double.infinity,
                        child: ElevatedButton.icon(onPressed: weekend ? null : saveAttendance,
                            icon: const Icon(Icons.save), label: const Text('Save Attendance'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14))))),
              ]);
            },
          );
        },
      ),
    );
  }
}




class NotesScreen extends StatelessWidget {
  final String courseId;
  const NotesScreen({super.key, required this.courseId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Notes'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses').doc(courseId).collection('notes')
            .orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var notes = snapshot.data!.docs;
          if (notes.isEmpty) return const Center(child: Text('No notes uploaded yet'));
          return ListView.builder(
            padding: const EdgeInsets.all(12), itemCount: notes.length,
            itemBuilder: (context, index) {
              var note = notes[index].data() as Map<String, dynamic>;
              return Card(margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.picture_as_pdf, color: Colors.teal)),
                    title: Text(note['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('By ${note["uploadedBy"] ?? "Teacher"}'),
                    trailing: const Icon(Icons.open_in_new, color: Colors.teal),
                    onTap: () {
                      final url = note['pdf'] ?? '';
                      if (url.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF not available')));
                        return;
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (_) => PDFViewerScreen(url: url)));
                    },
                  ));
            },
          );
        },
      ),
    );
  }
}

class UploadNotesScreen extends StatefulWidget {
  final String courseId;
  const UploadNotesScreen({super.key, required this.courseId});
  @override
  State<UploadNotesScreen> createState() => _UploadNotesScreenState();
}

class _UploadNotesScreenState extends State<UploadNotesScreen> {
  final _titleCtrl = TextEditingController();
  String? pdfPath;
  String? selectedPDFName;
  bool _uploading = false;

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) setState(() { pdfPath = result.files.single.path; selectedPDFName = result.files.single.name; });
  }

  Future<void> uploadNote() async {
    if (_titleCtrl.text.isEmpty || pdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill title and select PDF')));
      return;
    }
    setState(() => _uploading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final name = (userDoc.data() as Map?)?['name'] ?? 'Teacher';
      File file = File(pdfPath!);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      var ref = FirebaseStorage.instance.ref().child('courses/${widget.courseId}/notes/$fileName.pdf');
      await ref.putFile(file);
      String pdfURL = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('courses').doc(widget.courseId).collection('notes').add({
        'title': _titleCtrl.text,
        'pdf': pdfURL,
        'uploadedBy': name,
        'teacherId': uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _titleCtrl.clear(); pdfPath = null; selectedPDFName = null;
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note uploaded!')));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Notes'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        TextField(controller: _titleCtrl,
            decoration: const InputDecoration(labelText: 'Note Title', border: OutlineInputBorder(), prefixIcon: Icon(Icons.title))),
        const SizedBox(height: 20),
        OutlinedButton.icon(onPressed: pickPDF, icon: const Icon(Icons.upload_file), label: const Text('Select PDF'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14))),
        if (selectedPDFName != null)
          Padding(padding: const EdgeInsets.all(8),
              child: Row(children: [const Icon(Icons.check_circle, color: Colors.green), const SizedBox(width: 8),
                Expanded(child: Text(selectedPDFName!, style: const TextStyle(color: Colors.green)))])),
        const SizedBox(height: 30),
        SizedBox(width: double.infinity,
            child: ElevatedButton.icon(onPressed: _uploading ? null : uploadNote, icon: const Icon(Icons.cloud_upload),
                label: _uploading ? const CircularProgressIndicator(color: Colors.white) : const Text('Upload Note'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14)))),
      ])),
    );
  }
}



class DiscussionScreen extends StatefulWidget {
  final String courseId;
  const DiscussionScreen({super.key, required this.courseId});
  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  final _ctrl = TextEditingController();

  Future<void> send() async {
    if (_ctrl.text.trim().isEmpty) return;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final name = (userDoc.data() as Map?)?['name'] ?? 'User';
    final role = (userDoc.data() as Map?)?['role'] ?? 'student';
    await FirebaseFirestore.instance
        .collection('courses').doc(widget.courseId).collection('discussion').add({
      'text': _ctrl.text.trim(),
      'senderId': uid,
      'senderName': name,
      'role': role,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Discussion Forum'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: Column(children: [
        Expanded(child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses').doc(widget.courseId).collection('discussion')
              .orderBy('timestamp', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            var messages = snapshot.data!.docs;
            return ListView.builder(
              reverse: true, padding: const EdgeInsets.all(10), itemCount: messages.length,
              itemBuilder: (context, index) {
                var data = messages[index].data() as Map<String, dynamic>;
                bool isMe = data['senderId'] == uid;
                bool isTeacher = data['role'] == 'teacher';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.indigo : isTeacher ? Colors.deepPurple.shade50 : Colors.grey.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14), topRight: const Radius.circular(14),
                        bottomLeft: isMe ? const Radius.circular(14) : Radius.zero,
                        bottomRight: isMe ? Radius.zero : const Radius.circular(14),
                      ),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(data['senderName'] ?? 'User', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                            color: isMe ? Colors.white70 : Colors.black54)),
                        if (isTeacher) Container(margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(4)),
                            child: const Text('Teacher', style: TextStyle(color: Colors.white, fontSize: 9))),
                      ]),
                      const SizedBox(height: 4),
                      Text(data['text'] ?? '', style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                    ]),
                  ),
                );
              },
            );
          },
        )),
        Container(margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300)),
            child: Row(children: [
              Expanded(child: TextField(controller: _ctrl,
                  decoration: const InputDecoration(hintText: 'Type a message...', border: InputBorder.none))),
              IconButton(icon: const Icon(Icons.send_rounded, color: Colors.indigo), onPressed: send),
            ])),
      ]),
    );
  }
}


class AssignmentsScreen extends StatelessWidget {
  final String courseId;
  const AssignmentsScreen({super.key, required this.courseId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments'), backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses').doc(courseId).collection('assignments')
            .orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var assignments = snapshot.data!.docs;
          if (assignments.isEmpty) return const Center(child: Text('No assignments yet'));
          return ListView.builder(
            padding: const EdgeInsets.all(12), itemCount: assignments.length,
            itemBuilder: (context, index) {
              var s = assignments[index];
              final ts = s['timestamp'] as Timestamp?;
              final date = ts != null ? DateFormat('MMM d').format(ts.toDate()) : '';
              return Card(margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(Icons.assignment, color: Colors.deepOrange),
                      const SizedBox(width: 8),
                      Expanded(child: Text(s['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                      Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ]),
                    const SizedBox(height: 6),
                    Text(s['description'] ?? ''),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(
                              builder: (_) => PDFViewerScreen(url: s['pdf']))),
                          icon: const Icon(Icons.visibility), label: const Text('View'))),
                      const SizedBox(width: 10),
                      Expanded(child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(
                              builder: (_) => SubmitAssignmentScreen(courseId: courseId, assignmentId: s.id, title: s['title']))),
                          icon: const Icon(Icons.upload), label: const Text('Submit'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white))),
                    ]),
                  ])));
            },
          );
        },
      ),
    );
  }
}

class UploadAssignmentScreen extends StatefulWidget {
  final String courseId;
  const UploadAssignmentScreen({super.key, required this.courseId});
  @override
  State<UploadAssignmentScreen> createState() => _UploadAssignmentScreenState();
}

class _UploadAssignmentScreenState extends State<UploadAssignmentScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? pdfPath;
  String? selectedPDFName;
  bool _uploading = false;

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) setState(() { pdfPath = result.files.single.path; selectedPDFName = result.files.single.name; });
  }

  Future<void> uploadAssignment() async {
    if (_titleCtrl.text.isEmpty || pdfPath == null) return;
    setState(() => _uploading = true);
    try {
      File file = File(pdfPath!);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      var ref = FirebaseStorage.instance.ref().child('courses/${widget.courseId}/assignments/$fileName.pdf');
      await ref.putFile(file);
      String pdfURL = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('courses').doc(widget.courseId).collection('assignments').add({
        'title': _titleCtrl.text, 'description': _descCtrl.text,
        'pdf': pdfURL, 'timestamp': FieldValue.serverTimestamp(),
      });
      _titleCtrl.clear(); _descCtrl.clear(); pdfPath = null; selectedPDFName = null;
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assignment uploaded!')));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Assignment'), backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        TextField(controller: _titleCtrl,
            decoration: const InputDecoration(labelText: 'Assignment Title', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        TextField(controller: _descCtrl, maxLines: 3,
            decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        OutlinedButton.icon(onPressed: pickPDF, icon: const Icon(Icons.upload_file), label: const Text('Select PDF')),
        if (selectedPDFName != null)
          Padding(padding: const EdgeInsets.all(8),
              child: Text(selectedPDFName!, style: const TextStyle(color: Colors.green))),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity,
            child: ElevatedButton.icon(onPressed: _uploading ? null : uploadAssignment, icon: const Icon(Icons.cloud_upload),
                label: _uploading ? const CircularProgressIndicator(color: Colors.white) : const Text('Upload Assignment'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14)))),
      ])),
    );
  }
}


class SubmitAssignmentScreen extends StatefulWidget {
  final String courseId;
  final String assignmentId;
  final String title;
  const SubmitAssignmentScreen({super.key, required this.courseId, required this.assignmentId, required this.title});
  @override
  State<SubmitAssignmentScreen> createState() => _SubmitAssignmentScreenState();
}

class _SubmitAssignmentScreenState extends State<SubmitAssignmentScreen> {
  String? pdfPath;
  String? fileName;
  final _nameCtrl = TextEditingController();
  final _moodleCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() { _nameCtrl.dispose(); _moodleCtrl.dispose(); super.dispose(); }

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) setState(() { pdfPath = result.files.single.path; fileName = result.files.single.name; });
  }

  Future<void> submit() async {
    if (pdfPath == null || _nameCtrl.text.isEmpty || _moodleCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all fields and select PDF')));
      return;
    }
    setState(() => _submitting = true);
    try {
      File file = File(pdfPath!);
      String name = DateTime.now().millisecondsSinceEpoch.toString();
      var ref = FirebaseStorage.instance.ref().child('courses/${widget.courseId}/submissions/$name.pdf');
      await ref.putFile(file);
      String url = await ref.getDownloadURL();
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection('courses').doc(widget.courseId).collection('submissions').add({
        'assignmentId': widget.assignmentId,
        'assignmentTitle': widget.title,
        'pdf': url,
        'studentId': user.uid,
        'studentName': _nameCtrl.text,
        'moodleId': _moodleCtrl.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Submitted successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Submission failed: $e'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 6)));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submit: ${widget.title}'), backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        OutlinedButton.icon(onPressed: pickPDF, icon: const Icon(Icons.upload_file), label: const Text('Select Your PDF'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14))),
        if (fileName != null) Padding(padding: const EdgeInsets.all(8),
            child: Text(fileName!, style: const TextStyle(color: Colors.green))),
        const SizedBox(height: 16),
        TextField(controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Your Name', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: _moodleCtrl,
            decoration: const InputDecoration(labelText: 'Moodle ID', border: OutlineInputBorder())),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity,
            child: ElevatedButton.icon(onPressed: _submitting ? null : submit, icon: const Icon(Icons.send),
                label: _submitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Assignment'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14)))),
      ])),
    );
  }
}


class CheckSubmissionsScreen extends StatelessWidget {
  final String courseId;
  const CheckSubmissionsScreen({super.key, required this.courseId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Submissions'), backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses').doc(courseId).collection('submissions')
            .orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var submissions = snapshot.data!.docs;
          if (submissions.isEmpty) return const Center(child: Text('No submissions yet'));
          return ListView.builder(
            padding: const EdgeInsets.all(12), itemCount: submissions.length,
            itemBuilder: (context, index) {
              var s = submissions[index];
              final data = s.data() as Map<String, dynamic>;
              final ts = data['timestamp'] as Timestamp?;
              final date = ts != null ? DateFormat('MMM d, hh:mm a').format(ts.toDate()) : '';
              return Card(margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    leading: CircleAvatar(backgroundColor: Colors.deepOrange.shade100,
                        child: const Icon(Icons.assignment_turned_in, color: Colors.deepOrange)),
                    title: Text(data['assignmentTitle'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${data["studentName"]} • ${data["moodleId"]}'),
                      Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ]),
                    trailing: const Icon(Icons.picture_as_pdf, color: Colors.deepOrange),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PDFViewerScreen(url: data['pdf']))),
                  ));
            },
          );
        },
      ),
    );
  }
}


class PDFViewerScreen extends StatefulWidget {
  final String url;
  const PDFViewerScreen({super.key, required this.url});
  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: Stack(children: [
        SfPdfViewer.network(widget.url,
            onDocumentLoaded: (_) => setState(() => isLoading = false),
            onDocumentLoadFailed: (_) {
              setState(() => isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load PDF')));
            }),
        if (isLoading) const Center(child: CircularProgressIndicator()),
      ]),
    );
  }
}