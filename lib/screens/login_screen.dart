import 'package:flutter/material.dart';
import 'package:ridetogther/screens/home_screen.dart';

import 'package:ridetogther/screens/main_page.dart';
import 'package:ridetogther/screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<LoginScreen> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(
            context,
          ).unfocus(), // dismiss keyboard on tap outside
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 40),
              const Text(
                "Welcome back! Glad \n to see you Again!",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: emailTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordTextEditingController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Password?"),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              // ElevatedButton(
              //   onPressed: () {
              //     ElevatedButton(
              //       onPressed: () => Navigator.of(context).pushReplacement(
              //         MaterialPageRoute(builder: (context) => HomeScreen()),
              //       ),
              //       child: Text('Register'),
              //     );
              // )
              //   style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              //   child: const Text(
              //     "Login",
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),

              // try {
              //   final email = emailTextEditingController.text.trim();
              //   final password = passwordTextEditingController.text;

              //   if (email.isEmpty || password.isEmpty) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(
              //         content: Text('Email and password cannot be empty'),
              //       ),
              //     );
              //     return;
              //   }

              //   Firebase login
              //   final userCredential = await FirebaseAuth.instance
              //       .signInWithEmailAndPassword(
              //         email: email,
              //         password: password,
              //       );

              //   if (userCredential.user != null) {
              //     // Login success
              // Navigator.of(context).pushReplacement(
              //   MaterialPageRoute(builder: (context) => MainPage()),
              // );
              //   }
              // }

              // on FirebaseAuthException catch (e) {
              //   // Handle error
              //   String message = '';
              //   if (e.code == 'user-not-found') {
              //     message = 'No user found for this email.';
              //   } else if (e.code == 'wrong-password') {
              //     message = 'Wrong password.';
              //   } else {
              //     message = e.message ?? 'Login failed.';
              //   }

              //   ScaffoldMessenger.of(
              //     context,
              //   ).showSnackBar(SnackBar(content: Text(message)));
              // }
              // },
              // style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              // child: const Text(
              //   "Login",
              //   style: TextStyle(color: Colors.white),
              //   ),
              // ),
              const SizedBox(height: 20),
              const Center(child: Text("Or Login with")),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   "images/Google_G_logo.svg.png",
                  //   height: 30,
                  //   width: 30,
                  // ),
                  const SizedBox(width: 20),
                  const Icon(Icons.facebook, size: 32),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/registration');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(),
                        ),
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
