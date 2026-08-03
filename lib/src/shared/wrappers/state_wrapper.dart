import '../../imports/imports.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../ui/auth/bloc/session_bloc.dart';
import '../../ui/auth/bloc/auth_bloc.dart';

/// A wrapper to initialize the chosen State Management library.
class StateWrapper extends StatelessWidget {
  final Widget child;

  const StateWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl();
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionBloc>(create: (_) => SessionBloc(repository: authRepository)),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(repository: authRepository)),
      ],
      child: child,
    );
  }
}
