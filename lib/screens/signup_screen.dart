import 'package:flutter/material.dart';
import 'package:flutter_radec_1/screens/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //
                _header(context),
                _inputFields(context),
                //
                //
              ],
            ),
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      children: const [
        Text(
          "Create Account",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Enter details to get started",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 20)
      ],
    );
  }

  _inputFields(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: fullNameController,
          decoration: InputDecoration(
              hintText: "Full Name",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
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
        TextField(
          controller: confirmController,
          decoration: InputDecoration(
            hintText: "Confirm Password",
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
              var fullName = fullNameController.text.trim();
              var email = emailController.text.trim();
              var password = passwordController.text.trim();
              var confirmPass = confirmController.text.trim();
              // empty confirmation
              if (fullName.isEmpty ||
                  email.isEmpty ||
                  password.isEmpty ||
                  confirmPass.isEmpty) {
                Fluttertoast.showToast(msg: 'Please fill all fields');
                return;
              }
              // length of password confirmation
              if (password.length < 6) {
                Fluttertoast.showToast(
                    msg: 'Weak Password, at least 6 characters are required');
                return;
              }
              // equal confirmation
              if (password != confirmPass) {
                Fluttertoast.showToast(msg: 'Passwords do not match');
                return;
              }
              // request to firebase auth
              ProgressDialog progressDialog = ProgressDialog(
                context,
                title: const Text('Signing Up'),
                message: const Text('Please wait'),
              );

              progressDialog.show();

              try {
                FirebaseAuth auth = FirebaseAuth.instance;

                UserCredential userCredential =
                    await auth.createUserWithEmailAndPassword(
                        email: email, password: password);

                if (userCredential.user != null) {
                  // store user information in Realtime database

                  DatabaseReference userRef =
                      FirebaseDatabase.instance.reference().child('users');

                  String uid = userCredential.user!.uid;
                  int dt = DateTime.now().millisecondsSinceEpoch;

                  await userRef.child(uid).set({
                    'fullName': fullName,
                    'email': email,
                    'uid': uid,
                    'dt': dt,
                    'profileImage': ''
                  });

                  Fluttertoast.showToast(msg: 'Success');

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  Fluttertoast.showToast(msg: 'Failed');
                }

                progressDialog.dismiss();
              } on FirebaseAuthException catch (e) {
                progressDialog.dismiss();
                if (e.code == 'email-already-in-use') {
                  Fluttertoast.showToast(msg: 'Email is already in Use');
                } else if (e.code == 'weak-password') {
                  Fluttertoast.showToast(msg: 'Password is weak');
                }
              } catch (e) {
                progressDialog.dismiss();
                Fluttertoast.showToast(msg: 'Something went wrong');
              }
            },
            child: const Text('Sign Up')),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have akun '),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }));
                },
                child: const Text('Login Now')),
          ],
        )
      ],
    );
  }
}
