import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/email_password_login_form.dart';
import '../widgets/google_sign_in_button.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: height - 56.0,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                right: 16,
                left: 16,
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/undraw_access_account_re_8spm.svg',
                    height: 250.0,
                  ),
                  const SizedBox(height: 32.0),
                  const EmailPasswordLoginForm(),
                  const Expanded(child: SizedBox()),
                  const GoogleSignInButton(),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      const SizedBox(width: 4.0),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            SignupScreen.routeName,
                          );
                        },
                        child: const Text('Sign up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
