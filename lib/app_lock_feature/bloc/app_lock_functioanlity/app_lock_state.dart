part of 'app_lock_cubit.dart';

@immutable
abstract class AppLockState {}

class AppLockInitial extends AppLockState {}

class LoginWithPassword extends AppLockState {
  LoginWithPassword();
}

class AppLockLoading extends AppLockState {}

class AppLockSuccess extends AppLockState {
  AppLockSuccess();
}

class AppLockFailed extends AppLockState {}
