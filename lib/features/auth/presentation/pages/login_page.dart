import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../controllers/auth_flow_controller.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/continue_button.dart';
import '../widgets/otp_code_field.dart';

/// Hosts the three-step email flow: email → name → one-time code.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authFlowControllerProvider);
    final controller = ref.read(authFlowControllerProvider.notifier);

    void onBack() {
      if (state.step == AuthFlowStep.email) {
        context.pop();
      } else {
        controller.back();
      }
    }

    return switch (state.step) {
      AuthFlowStep.email => AuthScaffold(
          title: 'Register for free or log in',
          onBack: onBack,
          child: _EmailStep(state: state, controller: controller),
        ),
      AuthFlowStep.name => AuthScaffold(
          title: 'What should we call you?',
          onBack: onBack,
          child: _NameStep(state: state, controller: controller),
        ),
      AuthFlowStep.otp => AuthScaffold(
          title: 'Enter the 6-digit code sent to you at ${state.email}',
          onBack: onBack,
          child: _OtpStep(state: state, controller: controller),
        ),
    };
  }
}

class _EmailStep extends StatelessWidget {
  const _EmailStep({required this.state, required this.controller});

  final AuthFlowState state;
  final AuthFlowController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          onChanged: controller.setEmail,
          onSubmitted: (_) => controller.submitEmail(),
          decoration: InputDecoration(
            hintText: 'Email address',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ContinueButton(enabled: state.isEmailValid, onPressed: controller.submitEmail),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            children: const [
              TextSpan(text: 'By clicking through you are agreeing to our '),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
              ),
              TextSpan(text: ' and '),
              TextSpan(
                text: 'Terms & Conditions',
                style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
              ),
              TextSpan(text: '.'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _NameStep extends StatefulWidget {
  const _NameStep({required this.state, required this.controller});

  final AuthFlowState state;
  final AuthFlowController controller;

  @override
  State<_NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<_NameStep> {
  final _lastNameFocusNode = FocusNode();

  @override
  void dispose() {
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.givenName],
          onChanged: widget.controller.setFirstName,
          onSubmitted: (_) => _lastNameFocusNode.requestFocus(),
          decoration: InputDecoration(
            hintText: 'First name',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          focusNode: _lastNameFocusNode,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.familyName],
          onChanged: widget.controller.setLastName,
          onSubmitted: (_) => widget.controller.submitName(),
          decoration: InputDecoration(
            hintText: 'Last name',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ContinueButton(enabled: widget.state.isNameValid, onPressed: widget.controller.submitName),
      ],
    );
  }
}

class _OtpStep extends StatelessWidget {
  const _OtpStep({required this.state, required this.controller});

  final AuthFlowState state;
  final AuthFlowController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OtpCodeField(onChanged: controller.setCode),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening email app…')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Open Email App'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: null,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Resend'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ContinueButton(
          enabled: state.isCodeValid,
          // TODO: verify the code with the backend before granting access.
          onPressed: () => context.go(AppRoutes.home),
        ),
      ],
    );
  }
}
