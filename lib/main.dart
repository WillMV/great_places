import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:great_places/pages/map_page.dart';
import 'package:great_places/pages/my_places_page.dart';
import 'package:great_places/pages/place_detail.dart';
import 'package:great_places/pages/place_form_page.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/providers/location_provider.dart';
import 'package:great_places/utils/routers.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(
    DevicePreview(
        enabled: !kReleaseMode,
        builder: (ctx) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => GreatPlaces(),
                ),
                ChangeNotifierProvider(
                  create: (context) => LocationProvider(),
                ),
              ],
              child: const MyApp(),
            )),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      appBarTheme: AppBarTheme(
        actionsIconTheme: const IconThemeData(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade900,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 23),
      ),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      routes: {
        AppRoutes.HOME: (context) => const MyPlacesPage(),
        AppRoutes.MAP_PAGE: (context) => const MapPage(),
        AppRoutes.PLACE_FORM: (context) => const PlaceFormPage(),
        AppRoutes.PLACE_DETAIL: (context) => const PlaceDetail(),
      },
      initialRoute: AppRoutes.HOME,
    );
  }
}
