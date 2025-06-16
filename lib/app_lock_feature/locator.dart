import 'package:app_lock/app_lock_feature/cubits/biometric_service/biometric_service.dart';
import 'package:app_lock/mc_data_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

@pragma('vm:prefer-inline')
T sl<T extends Object>() => getIt.get<T>();

setUpLocator() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<McDataRepo>(() => McDataRepo(prefs));
  getIt.registerLazySingleton(() => BiometricService());
}
