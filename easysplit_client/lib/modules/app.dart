import 'package:easysplit_flutter/common/models/history/history.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/pages/bill_page.dart';
import 'package:easysplit_flutter/modules/bills/pages/create_item_page.dart';
import 'package:easysplit_flutter/modules/bills/pages/edit_charge_page.dart';
import 'package:easysplit_flutter/modules/bills/pages/edit_item_page.dart';
import 'package:easysplit_flutter/modules/bills/pages/share_bill_page.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/friends/pages/friends_page.dart';
import 'package:easysplit_flutter/modules/home/pages/home_page.dart';
import 'package:easysplit_flutter/modules/sample/pages/sample_page.dart';
import 'package:easysplit_flutter/modules/images/pages/camera_page.dart';
import 'package:easysplit_flutter/modules/images/pages/full_size_image_page.dart';
import 'package:easysplit_flutter/modules/images/pages/network_error_page.dart';
import 'package:easysplit_flutter/modules/images/pages/no_text_error_page.dart';
import 'package:easysplit_flutter/modules/images/pages/transition_page.dart';
import 'package:easysplit_flutter/modules/settings/pages/settings_page.dart';
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
      initialLocation: '/home',
      routes: [
        GoRoute(
          name: 'home',
          path: '/home',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const HomePage(),
          ),
        ),
        GoRoute(
          name: 'settings',
          path: '/settings',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const SettingsPage(),
          ),
        ),
        GoRoute(
          name: 'camera',
          path: '/camera',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const CameraPage(),
          ),
        ),
        GoRoute(
          name: 'transition',
          path: '/transition',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            return TransitioningPage(
              imagePath: args['imagePath'],
              fromPage: args['fromPage'],
            );
          },
        ),
        GoRoute(
            name: 'network-error',
            path: '/network-error',
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return NetworkErrorPage(
                imagePath: args['imagePath'],
                fromPage: args['fromPage'],
              );
            }),
        GoRoute(
            name: 'no-text-error',
            path: '/no-text-error',
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return NoTextErrorPage(
                imagePath: args['imagePath'],
                fromPage: args['fromPage'],
              );
            }),
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
          name: 'createItem',
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
          name: 'friends',
          path: '/friends',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final scrollPosition = extra?['scrollPosition'] as double?;
            return FriendsPage(scrollPosition: scrollPosition);
          },
        ),
        GoRoute(
          name: 'shareBill',
          path: '/shareBill',
          pageBuilder: (context, state) {
            final history = state.extra as History?;
            return NoTransitionPage(
              key: state.pageKey,
              child: ShareBillPage(history: history),
            );
          },
        ),
        GoRoute(
          name: 'fullSizeImage',
          path: '/fullSizeImage',
          builder: (context, state) {
            final imageUrl = (state.extra as Map<String, dynamic>)['imageUrl']!;
            return FullSizeImagePage(imageUrl: imageUrl);
          },
        ),
        GoRoute(
          name: 'sample',
          path: '/sample',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const SamplePage(),
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
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 148, 209, 228),
          secondary: const Color.fromRGBO(13, 170, 220, 1),
          surface: const Color.fromRGBO(255, 255, 255, 1),
          shadow: const Color.fromRGBO(242, 242, 242, 1)),
    );
  }
}
