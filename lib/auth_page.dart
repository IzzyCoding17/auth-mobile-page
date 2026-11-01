import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  static const Color purple = Colors.deepPurple;
  static const Duration duration = Duration(milliseconds: 600);

  bool _isLogin = true;
  bool _remember = false;
  bool _obscure = true;

  final _loginKey = GlobalKey<FormState>();
  final _signupKey = GlobalKey<FormState>();

  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  final _name = TextEditingController();
  final _signupEmail = TextEditingController();
  final _signupPassword = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _loginEmail.dispose();
    _loginPassword.dispose();
    _name.dispose();
    _signupEmail.dispose();
    _signupPassword.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _toggle() {
    FocusScope.of(context).unfocus();
    setState(() => _isLogin = !_isLogin);
  }

  void _login() {
    if (_loginKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
    }
  }

  void _signup() {
    if (_signupKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created')),
      );
      _toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purple,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;
          final keyboard = MediaQuery.of(context).viewInsets.bottom;
          final statusBar = MediaQuery.of(context).padding.top;

          return Stack(
            children: [
              // Logo and title
              AnimatedPositioned(
                duration: duration,
                curve: Curves.easeInOut,
                top: _isLogin ? h * 0.20 : statusBar + 30,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Kelppy Tech',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isLogin ? 'Welcome back' : 'Create your account',
                      style:
                      const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // White curved panel that slides up for sign up
              AnimatedPositioned(
                duration: duration,
                curve: Curves.easeInOut,
                top: _isLogin ? h : h * 0.30,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipPath(
                  clipper: _CurveClipper(),
                  child: Container(color: Colors.white),
                ),
              ),

              // Forms
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: duration,
                  child: _isLogin
                      ? _buildLogin(h, keyboard)
                      : _buildSignup(h, keyboard),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogin(double h, double keyboard) {
    return SingleChildScrollView(
      key: const ValueKey('login'),
      padding: EdgeInsets.fromLTRB(40, h * 0.46, 40, 24 + keyboard),
      child: Form(
        key: _loginKey,
        child: Column(
          children: [
            _field(
              controller: _loginEmail,
              label: 'Email ID',
              icon: Icons.email_outlined,
              onPurple: true,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter your email';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 8),
            _field(
              controller: _loginPassword,
              label: 'Password',
              icon: Icons.lock_outline,
              onPurple: true,
              obscure: _obscure,
              suffix: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              validator: (v) =>
              (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _remember,
                        onChanged: (v) =>
                            setState(() => _remember = v ?? false),
                        activeColor: Colors.white,
                        checkColor: purple,
                        side: const BorderSide(color: Colors.white, width: 1.5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Remember me',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
                const Text('Forgot Password?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontStyle: FontStyle.italic)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: purple,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _toggle,
              child: const Text('or Get Registered',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignup(double h, double keyboard) {
    return SingleChildScrollView(
      key: const ValueKey('signup'),
      padding: EdgeInsets.fromLTRB(40, h * 0.30 + 70, 40, 24 + keyboard),
      child: Form(
        key: _signupKey,
        child: Column(
          children: [
            _field(
              controller: _name,
              label: 'Full name',
              icon: Icons.person_outline,
              onPurple: false,
              validator: (v) =>
              (v == null || v.isEmpty) ? 'Enter your name' : null,
            ),
            const SizedBox(height: 8),
            _field(
              controller: _signupEmail,
              label: 'Email ID',
              icon: Icons.email_outlined,
              onPurple: false,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || !v.contains('@'))
                  ? 'Enter a valid email'
                  : null,
            ),
            const SizedBox(height: 8),
            _field(
              controller: _signupPassword,
              label: 'Password',
              icon: Icons.lock_outline,
              onPurple: false,
              obscure: _obscure,
              suffix: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black45,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              validator: (v) =>
              (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
            ),
            const SizedBox(height: 8),
            _field(
              controller: _confirm,
              label: 'Confirm password',
              icon: Icons.lock_outline,
              onPurple: false,
              obscure: _obscure,
              validator: (v) => v != _signupPassword.text
                  ? 'Passwords do not match'
                  : null,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _toggle,
              child: const Text('Already registered? Login',
                  style: TextStyle(color: purple)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool onPurple,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
  }) {
    final color = onPurple ? Colors.white : purple;
    final hint = onPurple ? Colors.white70 : Colors.black45;
    final error = onPurple ? Colors.amberAccent : Colors.red;

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(color: color),
      cursorColor: color,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: hint),
        floatingLabelStyle: TextStyle(color: color),
        prefixIcon: Icon(icon, color: hint),
        suffixIcon: suffix,
        errorStyle: TextStyle(color: error),
        enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: hint)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color, width: 2)),
        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: error)),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: error, width: 2)),
      ),
    );
  }
}

// Draws the curved top edge of the white panel
class _CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 50);
    path.quadraticBezierTo(size.width / 2, -30, size.width, 50);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}