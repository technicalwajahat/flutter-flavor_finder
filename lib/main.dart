import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:flavour_finder/preferences/theme_preferences.dart';
import 'package:flavour_finder/repository/auth_repository.dart';
import 'package:flavour_finder/widgets/loading_widget.dart';
import 'package:flavour_finder/routes/approutes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PersistentShoppingCart().init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthRepository()));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flavor Finder',
            theme: notifier.darkTheme ? dark : light,
            darkTheme: notifier.darkTheme ? dark : light,
            getPages: appRoutes(),
            home: const LoadingScreen(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1)),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
