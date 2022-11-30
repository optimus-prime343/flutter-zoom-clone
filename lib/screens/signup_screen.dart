import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_validator/form_validator.dart';

import '../services/auth_service.dart';
import '../utils/show_snackbar.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> handleSignup() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      await AuthService().signupWithEmailAndPassword(
        email: email,
        password: password,
        onSuccess: (user) {
          showSnackbar(context, 'Successfully created a new account');
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
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: height * 0.93,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/undraw_account_re_o7id.svg',
                      height: height * 0.5,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: ValidationBuilder().email().required().build(),
                      decoration: const InputDecoration(
                        hintText: 'Email address',
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: height * 0.03),
                    TextFormField(
                      controller: _passwordController,
                      validator:
                          ValidationBuilder().minLength(6).required().build(),
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.key_rounded),
                      ),
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                    ),
                    SizedBox(height: height * 0.04),
                    CustomButton(
                      text: 'Confirm signup',
                      onPressed: handleSignup,
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account ?'),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              LoginScreen.routeName,
                            );
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
