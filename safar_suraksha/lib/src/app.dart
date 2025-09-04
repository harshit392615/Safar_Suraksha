import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/welcome_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/signup_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/kyc_trip_page.dart';
import 'pages/tourist_id_page.dart';
import 'pages/live_map_page.dart';
import 'pages/alerts_page.dart';
import 'pages/panic_page.dart';
import 'pages/family_tracking_page.dart';
import 'pages/profile_page.dart';

class SafarSurakshaApp extends StatelessWidget {
  const SafarSurakshaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', name: 'welcome', builder: (_, __) => const WelcomePage()),
        GoRoute(path: '/signup', name: 'signup', builder: (_, __) => const SignupPage()),
        GoRoute(path: '/login', name: 'login', builder: (_, __) => const LoginPage()),
        GoRoute(path: '/dashboard', name: 'dashboard', builder: (_, __) => const DashboardPage()),
        GoRoute(path: '/kyc', name: 'kyc', builder: (_, __) => const KycTripPage()),
        GoRoute(path: '/tourist-id', name: 'touristId', builder: (_, __) => const TouristIdPage()),
        GoRoute(path: '/live-map', name: 'liveMap', builder: (_, __) => const LiveMapPage()),
        GoRoute(path: '/alerts', name: 'alerts', builder: (_, __) => const AlertsPage()),
        GoRoute(path: '/panic', name: 'panic', builder: (_, __) => const PanicPage()),
        GoRoute(path: '/family', name: 'family', builder: (_, __) => const FamilyTrackingPage()),
        GoRoute(path: '/profile', name: 'profile', builder: (_, __) => const ProfilePage()),
      ],
    );

    return MaterialApp.router(
      title: 'Safar Suraksha',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      routerConfig: router,
    );
  }
}

