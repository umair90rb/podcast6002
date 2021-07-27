import 'package:comrade/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ConfirmEmail extends StatelessWidget {
  AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'An email sent to you when you register. Click the link provided to complete registration',
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Raleway",
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Didn't receive email?",
              style: TextStyle(
                fontFamily: "Raleway",
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  ProgressDialog dialog = ProgressDialog(context);
                  dialog.style(
                      message: 'Please wait...',
                      messageTextStyle: TextStyle(
                        fontFamily: "Raleway",
                      ));
                  await dialog.show();
                  await _auth.sendEmailVerificationLink();
                  await dialog.hide();
                  await _auth.signOut();
                  ScaffoldState().showSnackBar(SnackBar(
                      content: Text(
                    'Verification link sent! Check your email.',
                    style: TextStyle(
                      fontFamily: "Raleway",
                    ),
                  )));
                },
                child: Text(
                  'Resend Email',
                  style: TextStyle(
                    fontFamily: "Raleway",
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
