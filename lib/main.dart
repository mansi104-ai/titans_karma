import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pec_chat/providers/user_provider.dart';
import 'package:pec_chat/responsive/mobile_screen_layout.dart';
import 'package:pec_chat/responsive/responsive_layout.dart';
import 'package:pec_chat/responsive/web_screen_layout.dart';
import 'package:pec_chat/screens/login_screen.dart';
import 'package:pec_chat/utils/colors.dart';
import 'package:provider/provider.dart';


void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCv-6HKeFZh1X4IfoQHtUwMzALGsa5OcxE",
          authDomain: "pec-chat.firebaseapp.com",
          appId: "1:11962779834:android:a7824fa052aa445cae1a83",
          databaseURL: "https://pec-chat-default-rtdb.asia-southeast1.firebasedatabase.app",
          messagingSenderId: "11962779834",
          projectId: "pec-chat",
          storageBucket: 'pec-chat.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        title: 'PEC CHAT',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
