import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/core/designe/snackbar.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/auth/cubit/auth_state.dart';
import 'package:task_manager/features/auth/screens/reg_screen.dart';
import 'package:task_manager/features/tasks/task_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});
  static const path = '/signinscreen';

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool passView = true;
  final keys = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void switchViewPass() {
    setState(() {
      passView = !passView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.user != null) {
          context.go(TaskScreen.path);
        } else if (state.user == null && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error.toString()),
            backgroundColor: Colors.red.withAlpha(150),
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Вход'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: keys,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    controller: email,
                    validator: (email) => email != null && !EmailValidator.validate(email) ? 'Введите верную почту' : null,
                    decoration: const InputDecoration(
                      hintText: 'Введите email',
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2,
                  child: TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.visiblePassword,
                    controller: password,
                    obscureText: passView,
                    validator: (password) => password != null && password.length < 6 ? 'Пароль должен иметь минимум 6 символов' : null,
                    decoration: InputDecoration(
                      hintText: 'Введите пароль',
                      suffix: InkWell(
                        onTap: switchViewPass,
                        child: Icon(
                          passView ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (email.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(MySnackbar.mySnackbar('Введите почту'));
                        } else if (password.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(MySnackbar.mySnackbar('Введите пароль'));
                        } else if (password.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(MySnackbar.mySnackbar('Пароль должен иметь не менее 6 символов'));
                        } else if (!state.isLoading) {
                          context.read<AuthCubit>().signin(email.text.trim(), password.text.trim());
                        }
                      },
                      child: state.isLoading ? const CircularProgressIndicator() : const Text('Войти'),
                    );
                  },
                ),
                Container(
                  height: 30,
                ),
                TextButton(
                    onPressed: () {
                      context.go(RegScreen.path);
                    },
                    child: const Text('Зарегистрироваться'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
