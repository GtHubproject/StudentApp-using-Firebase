import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_studentapp_project/pages/home.dart';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.cyan
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // User is authenticated, show Home.
            return Home();
          } else {
            // User is not authenticated, show LoginForm.
            return LoginForm();
          }
        },
      ),
    );
  }
}



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// import 'package:firebase_studentapp_project/pages/home.dart';
//
// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
//
// import 'auth/login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp( const MyApp());
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       theme: ThemeData(
//           primarySwatch: Colors.grey
//       ),
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       getPages: [
//         GetPage(name: '/', page: () => StreamBuilder<User?>(
//           stream: AuthController.to.user, // Use AuthController for user state
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               // User is authenticated, show Home.
//               return Home();
//             } else {
//               // User is not authenticated, show LoginForm.
//               return LoginForm();
//             }
//           },
//         )),
//       ],
//     );
//   }
// }
// class AuthController extends GetxController {
//   static AuthController get to => Get.find();
//
//   final Rx<User?> _user = Rx<User?>(null);
//
//   Stream<User?> get user => _user.stream;
//
//   @override
//   void onInit() {
//     _user.bindStream(FirebaseAuth.instance.authStateChanges());
//     super.onInit();
//   }
//   void signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }
// }
