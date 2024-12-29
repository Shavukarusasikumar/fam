import 'package:fam/presentation/bloc/card/card_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fam/presentation/bloc/card/card_bloc.dart';
import 'package:fam/presentation/screens/home/home_screen.dart';
import 'package:fam/data/repositories/card_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final http.Client client;

  const MyApp({super.key, required this.prefs, required this.client});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CardBloc(
              repository: CardRepositoryImpl(client: client),
              prefs: prefs,
            )..add(LoadCards()),
            child: const HomeScreen(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            );
          },
        ));
  
  }
}
