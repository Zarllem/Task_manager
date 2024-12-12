import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/core/designe/snackbar.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/auth/cubit/auth_state.dart';
import 'package:task_manager/features/auth/screens/signin_screen.dart';
import 'package:task_manager/features/tasks/task_screen.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});
  static const path = '/regscreen';

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password2 = TextEditingController();
  bool passView = true;
  bool passView2 = true;
  final keys = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    password2.dispose();
    super.dispose();
  }

  void switchViewPass() {
    setState(() {
      passView = !passView;
    });
  }

  void switchViewPass2() {
    setState(() {
      passView2 = !passView2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.user != null) {
          context.go(TaskScreen.path);
        } else if (state.user == null && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(MySnackbar.mySnackbar(state.error!));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Регистрация'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.go(SigninScreen.path),
            icon: const Icon(Icons.arrow_back),
          ),
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
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2,
                  child: TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.visiblePassword,
                    controller: password2,
                    obscureText: passView2,
                    validator: (password2) => password2 != null && password2.length < 6 ? 'Пароль должен иметь минимум 6 символов' : null,
                    decoration: InputDecoration(
                      hintText: 'Введите пароль',
                      suffix: InkWell(
                        onTap: switchViewPass2,
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
                        } else if (password.text.isEmpty || password2.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(MySnackbar.mySnackbar('Введите пароли'));
                        } else if (password.text != password2.text) {
                          ScaffoldMessenger.of(context).showSnackBar(MySnackbar.mySnackbar('Пароли должны совпадать'));
                        } else if (password.text.length < 6 || password2.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(MySnackbar.mySnackbar('Пароли должны иметь не менее 6 символов'));
                        } else if (!state.isLoading) {
                          context.read<AuthCubit>().reg(email.text.trim(), password.text.trim());
                        }
                      },
                      child: state.isLoading ? const CircularProgressIndicator() : const Text('Зарегистрироваться'),
                    );
                  },
                ),
                Container(
                  height: 30,
                ),
                TextButton(onPressed: () => context.go(SigninScreen.path), child: const Text('Войти'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
