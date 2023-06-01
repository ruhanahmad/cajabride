// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';



// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final _auth = FirebaseAuth.instance;

//   String _email = '';
//   String _password = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Firebase Login and Sign Up'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Email'),
//               onChanged: (value) {
//                 _email = value;
//               },
//             ),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//               onChanged: (value) {
//                 _password = value;
//               },
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               child: Text('Login'),
//               onPressed: () {
//                 _login();
//               },
//             ),
//             ElevatedButton(
//               child: Text('Sign Up'),
//               onPressed: () {
//                 _signUp();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _login() async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: _email, password: _password);
//       Navigator.pushNamed(context, '/home');
//     } catch (e) {
//       print(e);
//     }
//   }

//   void _signUp() async {
//     try {
//       await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
//       Navigator.pushNamed(context, '/home');
//     } catch (e) {
//       print(e);
//     }
//   }
// }

import 'package:cajabride/screens/login.dart';
import 'package:cajabride/screens/signUp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Image.asset(
          //   'assets/images/indriver_background.png',
          //   fit: BoxFit.cover,
          // ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'inDriver',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Your everyday ride',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Request a ride',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Get.to(LoginPage());
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(()=>SignUpPage());
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

