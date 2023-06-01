import 'package:cajabride/screens/homeScreen.dart';
import 'package:cajabride/screens/homescreenTest.dart';
import 'package:cajabride/screens/login.dart';
import 'package:cajabride/screens/testthree.dart';
import 'package:cajabride/screens/welcome.dart';
import 'package:cajabride/screens/signUp.dart';
import 'package:cajabride/testtwo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/test.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      //  initialRoute: '/login',
      //   routes: {
      //     // '/splash': (context) => const SplashScreen(),
      //     // '/onboardings': (_) => const OnboardingScreen(),
      //     '/login': (context) =>  LoginPage(),
      //     // '/home': (context) => const BottomBarScreen(),
      //     '/register': (context) => SignUpPage(),
      //     // '/getapproved': (context) => const GetApproved(),
      //   },
      home:  
      // HomeScreens()
      // HomePage(),
      // LoginPage(),
      // PickupLocationScreen(),
      // AddressEntryScreen(),
      // AddressEntryScreened(),
      Welcome(),
    );
  }
}

