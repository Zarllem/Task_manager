import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/auth/cubit/auth_state.dart';
import 'package:task_manager/features/auth/screens/signin_screen.dart';
import 'package:task_manager/features/tasks/task_cubit.dart';
import 'package:task_manager/features/tasks/task_state.dart';

class SignoutScreen extends StatelessWidget {
  const SignoutScreen({super.key});
  static const path = '/signoutscreen';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.user == null) {
          context.go(SigninScreen.path);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Аккаунт'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_outlined,
                  ),
                  Text('Ваша почта:'),
                ],
              ),
              Text('${user!.email}'),
              Container(
                height: 20,
              ),
              BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  return state.list!.isEmpty
                      ? const Text('У вас нет задач')
                      : state.list!.length == 1
                          ? const Text('У вас: 1 задача')
                          : state.list!.length < 5
                              ? Text('У вас: ${state.list!.length} задачи')
                              : Text('У вас: ${state.list!.length} задач');
                },
              ),
              Container(
                height: 20,
              ),
              TextButton(onPressed: context.read<AuthCubit>().signout, child: const Text('Выйти'))
            ],
          ),
        ),
      ),
    );
  }
}
