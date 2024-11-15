import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  // Constructor that takes a callback function to indicate login success
  const LoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMessage = '';

  // Function to handle login logic
  void _login() {
    // Check if the form is valid (both fields filled)
    if (_formKey.currentState!.validate()) {
      // Hard-coded credentials check
      if (_usernameController.text == 'correctUsername' &&
          _passwordController.text == 'correctPassword') {
        widget.onLoginSuccess(); // Call the success callback if login is valid
      } else {
        // Show error message if credentials are incorrect
        setState(() {
          _errorMessage = 'Incorrect username or password';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Form key to validate inputs
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Username input field
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Username"),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your username'
                    : null,
              ),

              // Password input field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true, // Hide password input
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your password'
                    : null,
              ),
              SizedBox(height: 20),
              // Login button
              ElevatedButton(
                onPressed: _login,
                child: Text("Login"),
              ),

              TextButton(
                onPressed: () {},
                child: Text("Forgot Password?"),
              ),
              // Display error message if login fails
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
