import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import '../screens/home_screen.dart';
import '../services/auth_service.dart';
import '../utils/show_snackbar.dart';
import 'custom_button.dart';

class EmailPasswordLoginForm extends StatefulWidget {
  const EmailPasswordLoginForm({super.key});

  @override
  State<EmailPasswordLoginForm> createState() => _EmailPasswordLoginFormState();
}

class _EmailPasswordLoginFormState extends State<EmailPasswordLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLoginPress() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      FocusScope.of(context).unfocus();
      await AuthService().signInWithEmailAndPassword(
        email: email,
        password: password,
        onSuccess: (user) {
          showSnackbar(context, 'Successfully logged in');
          Navigator.of(context).pushNamed(HomeScreen.routeName);
        },
        onError: (message) {
          showSnackbar(context, message);
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: ValidationBuilder().email().required().build(),
            decoration: const InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Icons.email_rounded),
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            obscureText: true,
            controller: _passwordController,
            validator: ValidationBuilder().minLength(6).required().build(),
            decoration: const InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(Icons.key_rounded),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 32.0),
          CustomButton(
            text: 'Login',
            onPressed: _handleLoginPress,
          )
        ],
      ),
    );
  }
}
