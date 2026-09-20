import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_controller.dart';
import '../services/app_routes.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/continue_button.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  bool _isSignUp = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(authControllerProvider.notifier);
    if (_isSignUp) {
      await controller.signUp(
        email: _email.text.trim(),
        password: _password.text,
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
      );
    } else {
      await controller.signIn(
        email: _email.text.trim(),
        password: _password.text,
      );
    }

    if (!mounted) return;
    final result = ref.read(authControllerProvider);
    if (result.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.error.toString())));
      return;
    }

    if (result.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check your email to confirm your account.'),
        ),
      );
      return;
    }

    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return AuthScaffold(
      title: _isSignUp ? 'Create your account' : 'Log in',
      onBack: () => context.pop(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isSignUp) ...[
              _field(
                controller: _firstName,
                label: 'First name',
                autofillHints: const [AutofillHints.givenName],
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your first name'
                    : null,
              ),
              const SizedBox(height: 12),
              _field(
                controller: _lastName,
                label: 'Last name',
                autofillHints: const [AutofillHints.familyName],
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your last name'
                    : null,
              ),
              const SizedBox(height: 12),
            ],
            _field(
              controller: _email,
              label: 'Email address',
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty || !email.contains('@')) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _field(
              controller: _password,
              label: 'Password',
              obscureText: true,
              autofillHints: [
                _isSignUp ? AutofillHints.newPassword : AutofillHints.password,
              ],
              validator: (value) => value == null || value.length < 6
                  ? 'Password must be at least 6 characters'
                  : null,
              onSubmitted: (_) {
                if (!isLoading) _submit();
              },
            ),
            const SizedBox(height: 20),
            ContinueButton(
              enabled: !isLoading,
              label: isLoading
                  ? 'Please wait'
                  : _isSignUp
                  ? 'Create account'
                  : 'Log in',
              onPressed: _submit,
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () => setState(() => _isSignUp = !_isSignUp),
              child: Text(
                _isSignUp
                    ? 'Already have an account? Log in'
                    : 'New here? Create an account',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
    bool obscureText = false,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      obscureText: obscureText,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
