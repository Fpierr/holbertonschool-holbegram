import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:holbegram/screens/home.dart';
import 'package:holbegram/screens/auth/login_screen.dart';
import 'package:holbegram/screens/auth/signup_screen.dart';
import 'package:holbegram/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.red, useMaterial3: true),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return FutureBuilder(
                  future: Provider.of<UserProvider>(context, listen: false)
                      .refreshUser(),
                  builder: (context, userSnap) {
                    if (userSnap.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                          body: Center(
                              child: CircularProgressIndicator(
                                  color: Colors.red)));
                    }
                    return const Home();
                  },
                );
              }
              return const LoginScreen();
            }
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUp(),
          '/home': (context) => const Home(),
        },
      ),
    );
  }
}
