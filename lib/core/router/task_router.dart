import 'package:go_router/go_router.dart';
import 'package:task_manager/features/auth/screens/reg_screen.dart';
import 'package:task_manager/features/auth/screens/signin_screen.dart';
import 'package:task_manager/features/auth/screens/signout_screen.dart';
import 'package:task_manager/features/tasks/task_screen.dart';

abstract class TaskRouter {
  static final GoRouter goRouter = GoRouter(initialLocation: SigninScreen.path, routes: [
    GoRoute(
      path: SigninScreen.path,
      builder: (context, state) => const SigninScreen(),
    ),
    GoRoute(
      path: TaskScreen.path,
      builder: (context, state) => const TaskScreen(),
    ),
    GoRoute(
      path: SignoutScreen.path,
      builder: (context, state) => const SignoutScreen(),
    ),
    GoRoute(
      path: RegScreen.path,
      builder: (context, state) => const RegScreen(),
    )
  ]);
}
