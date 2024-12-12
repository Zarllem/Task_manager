import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/features/auth/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthCubit() : super(AuthState(user: null, isLoading: false, error: null));

  void signin(String email, String pass) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
      emit(state.copyWith(user: result.user!, isLoading: false));
    } on FirebaseAuthException catch (e) {
      log('loggin error ${e.message}');
      emit(state.copyWith(isLoading: false, error: e.message));
    }
  }

  void reg(String email, String pass) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      emit(state.copyWith(user: result.user, isLoading: false));
    } on FirebaseAuthException catch (e) {
      log('signup error ${e.message}');
      emit(state.copyWith(isLoading: false, error: e.message));
    }
  }

  void signout() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _firebaseAuth.signOut();
      emit(state.copyWith(user: null, isLoading: false));
    } catch (e) {
      log('signout error ${e.toString()}');
      emit(state.copyWith(error: e.toString()));
    }
  }
}
