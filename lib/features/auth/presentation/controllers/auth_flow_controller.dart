import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Steps of the email registration/login flow shown after the user taps
/// "Email" on [AuthLandingPage].
enum AuthFlowStep { email, name, otp }

class AuthFlowState extends Equatable {
  const AuthFlowState({
    this.step = AuthFlowStep.email,
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.code = '',
  });

  final AuthFlowStep step;
  final String email;
  final String firstName;
  final String lastName;
  final String code;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool get isEmailValid => _emailRegex.hasMatch(email.trim());

  bool get isNameValid => firstName.trim().isNotEmpty && lastName.trim().isNotEmpty;

  bool get isCodeValid => code.length == 6;

  AuthFlowState copyWith({
    AuthFlowStep? step,
    String? email,
    String? firstName,
    String? lastName,
    String? code,
  }) {
    return AuthFlowState(
      step: step ?? this.step,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      code: code ?? this.code,
    );
  }

  @override
  List<Object?> get props => [step, email, firstName, lastName, code];
}

/// Drives the multi-step email flow: collect email, then name, then verify
/// the emailed one-time code.
///
/// TODO: wire each transition to a domain use case (request code / verify
/// code / complete profile) once the backend exposes those endpoints.
class AuthFlowController extends Notifier<AuthFlowState> {
  @override
  AuthFlowState build() => const AuthFlowState();

  void setEmail(String value) => state = state.copyWith(email: value);

  void setFirstName(String value) => state = state.copyWith(firstName: value);

  void setLastName(String value) => state = state.copyWith(lastName: value);

  void setCode(String value) => state = state.copyWith(code: value);

  void submitEmail() {
    if (!state.isEmailValid) return;
    state = state.copyWith(step: AuthFlowStep.name);
  }

  void submitName() {
    if (!state.isNameValid) return;
    state = state.copyWith(step: AuthFlowStep.otp);
  }

  /// Moves back one step. Does nothing on the first step; the page itself
  /// handles popping the route in that case.
  void back() {
    switch (state.step) {
      case AuthFlowStep.name:
        state = state.copyWith(step: AuthFlowStep.email);
      case AuthFlowStep.otp:
        state = state.copyWith(step: AuthFlowStep.name);
      case AuthFlowStep.email:
        break;
    }
  }
}

final authFlowControllerProvider =
    NotifierProvider<AuthFlowController, AuthFlowState>(AuthFlowController.new);
