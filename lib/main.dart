import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stikahub/providers/auth/auth_provider.dart';
import 'package:stikahub/repositories/authentication/authentication_repository.dart';
import 'package:stikahub/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationRepository>(
          create: (_) => AuthenticationRepository(),
        ),
        ChangeNotifierProxyProvider<AuthenticationRepository,
            UserProfileProvider>(
          create: (context) => UserProfileProvider(
            Provider.of<AuthenticationRepository>(context, listen: false),
          ),
          update: (context, authRepo, previous) =>
              previous ?? UserProfileProvider(authRepo),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}
