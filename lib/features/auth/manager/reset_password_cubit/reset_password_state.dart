abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String error;

  ResetPasswordError({required this.error});
}

class ResetPasswordOtpChanged extends ResetPasswordState {}

class ResetPasswordToggle extends ResetPasswordState {}
