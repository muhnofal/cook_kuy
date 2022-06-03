import 'package:cook_kuy/providers/user_provider.dart';
import 'package:cook_kuy/responsive/mobile_screen_layout.dart';
import 'package:cook_kuy/responsive/responsive_layout_screen.dart';
import 'package:cook_kuy/responsive/web_screen_layout.dart';
import 'package:cook_kuy/screens/login/login_screen.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cook Kuy',
        // theme: ThemeData.light()
        //     .copyWith(scaffoldBackgroundColor: mobileBackgroundColor,),
        theme: ThemeData(
          scaffoldBackgroundColor: mobileBackgroundColor,
          primaryColor: ijoSkripsi,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapsnot) {
            if (snapsnot.connectionState == ConnectionState.active) {
              if (snapsnot.hasData) {
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapsnot.hasError) {
                return Center(
                  child: Text('${snapsnot.error}'),
                );
              }
            } 
            if (snapsnot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
