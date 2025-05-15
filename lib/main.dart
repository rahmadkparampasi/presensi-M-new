import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/screens/splash_screen.dart';
import 'package:presensi/services/absen_services.dart';
import 'package:presensi/services/lap_services.dart';
import 'package:presensi/services/ppk_services.dart';
import 'package:presensi/services/satker_services.dart';
import 'package:presensi/services/setpd_services.dart';
import 'package:presensi/services/sisp_services.dart';
import 'package:presensi/services/survei_services.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => AbsenService());
  GetIt.I.registerLazySingleton(() => SatkerServices());
  GetIt.I.registerLazySingleton(() => PpkServices());
  GetIt.I.registerLazySingleton(() => SispServices());
  GetIt.I.registerLazySingleton(() => LapServices());
  GetIt.I.registerLazySingleton(() => SetpdServices());
  GetIt.I.registerLazySingleton(() => SurveiServices());
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PRESENSI',
      home: SplashScreen(),
    );
  }
}
