import 'package:flutter/material.dart';
import 'package:flutter_radec_1/screens/signup_screen.dart';
import 'package:flutter_radec_1/screens/task_list_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(context),
            _inputField(context),
          ],
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      children: const [
        Text(
          "Welcome RADEC",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Enter your credential to login",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: () async {
              var email = emailController.text.trim();
              var password = passwordController.text.trim();
              if (email.isEmpty || password.isEmpty) {
                // show error toast
                Fluttertoast.showToast(msg: 'Please fill all fields');
                return;
              }
              // request to firebase auth
              ProgressDialog progressDialog = ProgressDialog(
                context,
                title: const Text('Logging In'),
                message: const Text('Please wait'),
              );

              progressDialog.show();

              try {
                FirebaseAuth auth = FirebaseAuth.instance;

                UserCredential userCredential =
                    await auth.signInWithEmailAndPassword(
                        email: email, password: password);

                if (userCredential.user != null) {
                  progressDialog.dismiss();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return const TaskListScreen();
                  }));
                }
              } on FirebaseAuthException catch (e) {
                progressDialog.dismiss();

                if (e.code == 'user-not-found') {
                  Fluttertoast.showToast(msg: 'User not found');
                } else if (e.code == 'wrong-password') {
                  Fluttertoast.showToast(msg: 'Wrong password');
                }
              } catch (e) {
                Fluttertoast.showToast(msg: 'Something went wrong');
                progressDialog.dismiss();
              }
            },
            child: const Text('Login')),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Not Registered Yet'),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const SignUpScreen();
                  }));
                },
                child: const Text('Register Now')),
          ],
        )
      ],
    );
  }
}
