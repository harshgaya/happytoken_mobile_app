import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:connection_notifier/connection_notifier.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/firebase_options.dart';
import 'package:happy_tokens/helpers/colors.dart';
import 'package:happy_tokens/modules/authentication/pages/user_state.dart';
import 'package:happy_tokens/widgets/no_internet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry/sentry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (Platform.isAndroid) {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  HttpOverrides.global = MyHttpOverrides();

  FlutterError.onError = (FlutterErrorDetails errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<ConnectivityResult>? _subscription;
  bool _isInternetDisconnected = false;

  @override
  void initState() {
    super.initState();

    _monitorInternet();
  }

  void _monitorInternet() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _goToNoInternetScreen();
      } else if (_isInternetDisconnected) {
        _isInternetDisconnected = false;
        _returnToPreviousScreen();
      }
    });

    Connectivity().checkConnectivity().then((result) {
      if (result == ConnectivityResult.none) {
        _goToNoInternetScreen();
      }
    });
  }

  void _goToNoInternetScreen() {
    _isInternetDisconnected = true;
    Get.to(() => NoInternet());
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => NoInternet()),
    // );
  }

  void _returnToPreviousScreen() {
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionNotifier(
      connectionNotificationOptions: const ConnectionNotificationOptions(
        alignment: AlignmentDirectional.bottomCenter,
      ),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Happy Tokens',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(AppColors.appMainColor)),
          useMaterial3: true,
        ),
        home: const UserState(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
