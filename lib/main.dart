import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webworksco/Web%20Works%20co/presentation/routes/app_pages.dart';

import 'Web Works co/data/data_source/app_service.dart';
import 'Web Works co/presentation/manager/dashboard_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardController(ApiService.instance),
      child: MaterialApp.router(
        title: 'Creator Profile Portal',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Inter',
        ),
        routerConfig: AppPages().router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
