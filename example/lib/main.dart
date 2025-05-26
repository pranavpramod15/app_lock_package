import 'package:app_lock/app_lock.dart';
import 'package:app_lock/app_lock_feature/bloc/app_lock_functioanlity/app_lock_cubit.dart';
import 'package:app_lock/app_lock_feature/bloc/app_lock_preferences/app_lock_preferences_cubit.dart';
import 'package:app_lock/app_lock_feature/bloc/blur/blur_cubit.dart';
import 'package:app_lock/app_lock_feature/locator.dart';
import 'package:app_lock/app_lock_feature/widgets/app_lock_wrapper.dart';
import 'package:app_lock/app_lock_feature/widgets/blur_widget.dart';
import 'package:app_lock/mc_data_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AppLockPreferencesCubit>(
            create: (context) => AppLockPreferencesCubit(
                mcDataRepo: sl<McDataRepo>(), context: context),
          ),
          BlocProvider<BlurCubit>(
            create: (context) => BlurCubit(),
          ),
          BlocProvider<AppLockCubit>(
            create: (context) =>
                AppLockCubit(blurCubit: BlocProvider.of<BlurCubit>(context)),
          ),
        ],
        child: AppLockWrapper(
            child: BlurWidget(
                blurCubit: BlocProvider.of<BlurCubit>(context),
                child: const HomeScreen())),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
    );
  }
}
