import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase (Use ANON key ONLY)
  await Supabase.initialize(
    url: 'https://xpnwpumcyqueqjdjqdyz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhwbndwdW1jeXF1ZXFqZGpxZHl6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI1Nzg2NDgsImV4cCI6MjA4ODE1NDY0OH0.CwUS_hxkB5hWVAdBlB9olDby2YXNhUAJ8PMEFq_93bQ',
  );

  // Initialize date formatting for 'fr_FR' (intl)
  await initializeDateFormatting('fr_FR', null);

  runApp(const ParcellesApp());
}

// GoRouter configuration
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/parcelle/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetailScreen(id: id);
      },
    ),
  ],
);

class ParcellesApp extends StatelessWidget {
  const ParcellesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vente de Parcelles',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
