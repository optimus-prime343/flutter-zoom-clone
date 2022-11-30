import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/show_snackbar.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> handleGoogleLogin() async {
      await AuthService().signInWithGoogle(
        onSuccess: (user) {
          showSnackbar(context, 'Login successful');
        },
        onError: (message) {
          showSnackbar(context, message);
        },
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(32.0),
      onTap: handleGoogleLogin,
      child: Ink(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google-logo.png',
              height: 40,
            ),
            const SizedBox(width: 8.0),
            Text(
              'Sign in with Google',
              style: Theme.of(context).textTheme.button?.copyWith(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
