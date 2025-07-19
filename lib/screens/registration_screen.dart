import 'package:flutter/material.dart';
import 'package:ridetogther/screens/home_screen.dart';
import 'package:ridetogther/screens/main_page.dart';

// import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String phone = '';
  bool _isLoading = false;
  bool _passwordVisible = false;

  // Future<void> _register() async {
  //   if (_formKey.currentState?.validate() != true) return;
  //   setState(() => _isLoading = true);
  //   try {
  //     final credential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //           email: emailController.text.trim(),
  //           password: passwordController.text,
  //         );

  //     await credential.user?.sendEmailVerification();

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Verification email sent!')));
  //   } on FirebaseAuthException catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.message ?? 'Registration failed')),
  //     );
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter your name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val != null && val.contains('@')
                    ? null
                    : 'Enter valid email',
              ),
              SizedBox(height: 10),
              // InternationalPhoneNumberInput(
              //   onInputChanged: (PhoneNumber number) {
              //     phone = number.phoneNumber ?? '';
              //     print('Parsed Phone: $phone');
              //   },
              //   onInputValidated: (bool value) {
              //     print('Is phone valid? $value');
              //   },
              //   selectorConfig: const SelectorConfig(
              //     selectorType: PhoneInputSelectorType.DROPDOWN,
              //   ),
              //   ignoreBlank: false,
              //   autoValidateMode: AutovalidateMode.onUserInteraction,
              //   selectorTextStyle: const TextStyle(color: Colors.black),
              //   textFieldController: TextEditingController(),
              //   formatInput: true,
              //   inputDecoration: const InputDecoration(
              //     labelText: 'Phone Number',
              //     border: OutlineInputBorder(),
              //   ),
              //   initialValue: PhoneNumber(isoCode: 'IN'),
              //   countries: ['IN'], // Optional: limit to India
              // ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _passwordVisible = !_passwordVisible),
                  ),
                ),
                validator: (val) =>
                    val != null && val.length >= 6 ? null : 'Min 6 characters',
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                validator: (val) => val == passwordController.text
                    ? null
                    : 'Passwords do not match',
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      ),
                      child: Text('Register'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
