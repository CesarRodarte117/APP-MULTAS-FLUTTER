import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Login Page'),
            ElevatedButton(
              onPressed: () {
                // Implement login logic here
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
