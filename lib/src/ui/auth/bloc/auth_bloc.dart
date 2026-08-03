import 'package:nex_fit/src/imports/core_imports.dart';
import 'package:nex_fit/src/imports/packages_imports.dart';

import 'package:nex_fit/src/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({required AuthRepository repository}) : _repository = repository, super(const AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<RememberMeToggled>(_onRememberMeToggled);
  }

  void _onRememberMeToggled(
    RememberMeToggled event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    final result = await _repository.login(email: event.email, password: event.password);
    
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false));
        if (event.context.mounted) {
          showToast(event.context, message: failure.message, status: 'error');
        }
      },
      (user) {
        emit(state.copyWith(isLoading: false));
        if (event.context.mounted) {
          event.context.go(AppRoutes.home);
        }
      },
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    final result = await _repository.signUp(name: event.name, email: event.email, password: event.password);
    
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false));
        if (event.context.mounted) {
          showToast(event.context, message: failure.message, status: 'error');
        }
      },
      (user) {
        emit(state.copyWith(isLoading: false));
        if (event.context.mounted) {
          event.context.go(AppRoutes.home);
        }
      },
    );
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    final result = await _repository.forgotPassword(email: event.email);
    
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false));
        if (event.context.mounted) {
          showToast(event.context, message: failure.message, status: 'error');
        }
      },
      (success) {
        emit(state.copyWith(isLoading: false));
        if (event.context.mounted) {
          showToast(event.context, message: 'Password reset link sent successfully', status: 'success');
        }
        if (event.context.mounted) {
          event.context.go(AppRoutes.login);
        }
      },
    );
  }
}

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final BuildContext context;
  final String email;
  final String password;
  const LoginRequested({required this.context, required this.email, required this.password});
}

class SignUpRequested extends AuthEvent {
  final BuildContext context;
  final String name;
  final String email;
  final String password;
  const SignUpRequested({required this.context, required this.name, required this.email, required this.password});
}

class ForgotPasswordRequested extends AuthEvent {
  final BuildContext context;
  final String email;
  const ForgotPasswordRequested({required this.context, required this.email});
}

class RememberMeToggled extends AuthEvent {
  const RememberMeToggled();
}

class AuthState extends Equatable {
  final bool isLoading;
  final bool rememberMe;
  const AuthState({required this.isLoading, required this.rememberMe});
  const AuthState.initial() : isLoading = false, rememberMe = false;
  AuthState copyWith({bool? isLoading, bool? rememberMe}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
  @override
  List<Object?> get props => [isLoading, rememberMe];
}

