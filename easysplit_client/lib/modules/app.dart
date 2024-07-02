import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/pages/bill_page.dart';
import 'package:easysplit_flutter/modules/bills/pages/create_item_page.dart';
import 'package:easysplit_flutter/modules/bills/pages/edit_charge_page.dart';
import 'package:easysplit_flutter/modules/bills/pages/edit_item_page.dart';
import 'package:easysplit_flutter/modules/bills/pages/share_bill_page.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/images/pages/camera_page.dart';
import 'package:easysplit_flutter/modules/images/pages/network_error_page.dart';
import 'package:easysplit_flutter/modules/images/pages/no_text_error_page.dart';
import 'package:easysplit_flutter/modules/images/pages/transition_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  final _receiptStore = locator<ReceiptStore>();
  late final GoRouter router;

  App({super.key}) {
    router = _getRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: MaterialApp.router(
          routeInformationProvider: router.routeInformationProvider,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          debugShowCheckedModeBanner: false,
          theme: _getThemeData(),
        ));
  }

  GoRouter _getRouter() {
    return GoRouter(
      initialLocation: '/camera',
      routes: [
        GoRoute(
          name: 'camera',
          path: '/camera',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const CameraPage(),
          ),
        ),
        GoRoute(
          path: '/transition',
          builder: (context, state) =>
              TransitioningPage(imagePath: state.extra as String),
        ),
        GoRoute(
          path: '/network-error',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: NetworkErrorPage(imagePath: state.extra as String),
          ),
        ),
        GoRoute(
          path: '/no-text-error',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: NoTextErrorPage(imagePath: state.extra as String),
          ),
        ),
        GoRoute(
          name: 'bill',
          path: '/bill',
          pageBuilder: (context, state) {
            final args = state.extra as Map<String, dynamic>?;
            final scrollPosition = args?['scrollPosition'] as double?;
            return NoTransitionPage(
              key: state.pageKey,
              child: BillPage(scrollPosition: scrollPosition),
            );
          },
        ),
        GoRoute(
          path: '/createItem',
          builder: (context, state) {
            final scrollPosition = (state.extra
                as Map<String, dynamic>)['scrollPosition'] as double?;
            return CreateItemPage(
                receiptStore: _receiptStore, scrollPosition: scrollPosition);
          },
        ),
        GoRoute(
          name: 'editItem',
          path: '/editItem',
          pageBuilder: (context, state) {
            final item = (state.extra as Map<String, dynamic>)['item']!;
            final index = (state.extra as Map<String, dynamic>)['index']!;
            final scrollPosition = (state.extra
                as Map<String, dynamic>)['scrollPosition'] as double?;
            return NoTransitionPage(
              key: state.pageKey,
              child: EditItemPage(
                item: item,
                index: index,
                receiptStore: _receiptStore,
                scrollPosition: scrollPosition,
              ),
            );
          },
        ),
        GoRoute(
          name: 'editCharge',
          path: '/editCharge',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: EditChargePage(
              charge: (state.extra as Map<String, dynamic>)['charge']!,
              index: (state.extra as Map<String, dynamic>)['index']!,
              isDiscount: (state.extra as Map<String, dynamic>)['isDiscount']!,
              receiptStore: _receiptStore,
            ),
          ),
        ),
        GoRoute(
          name: 'shareBill',
          path: '/shareBill',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ShareBillPage(),
          ),
        ),
      ],
    );
  }

  ThemeData _getThemeData() {
    return ThemeData(
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Poppins'),
        displayMedium: TextStyle(fontFamily: 'Poppins'),
        displaySmall: TextStyle(fontFamily: 'Poppins'),
        headlineLarge: TextStyle(fontFamily: 'Poppins'),
        headlineMedium: TextStyle(fontFamily: 'Poppins'),
        headlineSmall: TextStyle(fontFamily: 'Poppins'),
        titleLarge: TextStyle(fontFamily: 'Poppins'),
        titleMedium: TextStyle(fontFamily: 'Poppins'),
        titleSmall: TextStyle(fontFamily: 'Poppins'),
        bodyLarge: TextStyle(fontFamily: 'Poppins'),
        bodyMedium: TextStyle(fontFamily: 'Poppins'),
        bodySmall: TextStyle(fontFamily: 'Poppins'),
        labelLarge: TextStyle(fontFamily: 'Poppins'),
        labelMedium: TextStyle(fontFamily: 'Poppins'),
        labelSmall: TextStyle(fontFamily: 'Poppins'),
      ),
      primaryColor: const Color.fromARGB(255, 148, 209, 228),
      canvasColor: const Color.fromARGB(255, 148, 209, 228),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 148, 209, 228),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 148, 209, 228),
      ),
    );
  }
}
