import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../pages/home.dart';
import '../services/functions/authFunctions.dart';

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Obx(() {
//         final user = AuthController.to.user.value;
//
//         if (user == null) {
//           return LoginForm();
//         } else {
//           return Home();
//         }
//       }),
//     );
//   }
// }



class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String fullname = '';
  String phoneNumber = '';
  int age = 0;
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ======== Full Name ========
                login
                    ? Container()
                    : TextFormField(
                  key: ValueKey('fullname'),
                  decoration: InputDecoration(
                    hintText: 'Enter Full Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Full Name';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      fullname = value!;
                    });
                  },
                ),
                // ======== phoneNumber ========
                login
                 ?Container()

                :TextFormField(
                  key: ValueKey('age'),
                  decoration: InputDecoration(
                    hintText: 'Enter Age',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Age';
                    } else if (int.tryParse(value) == null) {
                      return 'Please Enter a Valid Age';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      age = int.parse(value!);
                    });
                  },
                ),
                // ======== phoneNumber ========
              login
                    ? Container()
                :TextFormField(
                  key: ValueKey('phoneNumber'),
                  decoration: InputDecoration(
                    hintText: 'Enter Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Phone Number';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      phoneNumber = value!;
                    });
                  },
                ),

                // ======== Email ========
                TextFormField(
                  key: ValueKey('email'),
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please Enter valid Email';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      email = value!;
                    });
                  },
                ),
                // ======== Password ========
                TextFormField(
                  key: ValueKey('password'),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Please Enter Password of min length 6';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      password = value!;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          login
                              ? AuthServices.signinUser(email, password, context)
                              : AuthServices.signupUser(
                              email, password, fullname, phoneNumber, // Pass the phone number to signupUser
                              age,  context);
                        }
                      },
                      child: Text(login ? 'Login' : 'Signup')),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        login = !login;
                      });
                    },
                    child: Text(login
                        ? "Don't have an account? Signup"
                        : "Already have an account? Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}


