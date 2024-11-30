import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMessage = '';

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (_usernameController.text == '1234' &&
          _passwordController.text == '1234') {
        widget.onLoginSuccess();
      } else {
        setState(() {
          _errorMessage = 'Incorrect username or password';
        });
      }
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromRGBO(248, 244, 234, 1),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App name/logo
            const Text(
              "DriveWise",
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(86, 170, 200, 1),
              ),
            ),
            const SizedBox(height: 40),
            // Login Form
           Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color.fromRGBO(225, 225, 225, 1),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Centered "Login" text inside the form
        const Center(
          child: Text(
            "Login",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(49, 49, 49, 1),
            ),
          ),
        ),
        const SizedBox(height: 20), // Spacing below "Login" text

        const Text(
          "Email:",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Color.fromRGBO(112, 112, 112, 1),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            iconColor: const Color.fromRGBO(112, 112, 112, 1),
            hintText: "email@example.com",
            hintStyle: TextStyle(color: Color.fromRGBO(112, 112, 112, 0.7), fontWeight: FontWeight.normal),
            prefixIcon: const Icon(Icons.email),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            )
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter your email'
              : null,
        ),
        const SizedBox(height: 16),

        const Text(
          "Password:",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Color.fromRGBO(112, 112, 112, 1),
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            iconColor: const Color.fromRGBO(112, 112, 112, 1),
            hintText: "password@123", 
            hintStyle: TextStyle(color: Color.fromRGBO(112, 112, 112, 0.7), fontWeight: FontWeight.normal),
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: const Icon(Icons.visibility_off_outlined),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            )
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter your password'
              : null,
        ),
        const SizedBox(height: 5),

        GestureDetector(
          onTap: () {
            // Add forgot password functionality
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              color: Color.fromRGBO(86, 170, 200, 1),
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 30),

        ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(49, 49, 49, 1),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Center(
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),


            // Error message display
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

}
