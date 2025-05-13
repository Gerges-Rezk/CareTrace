import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/Features/Auth/busines_logic/auth_cubit/cubit/auth_cubit.dart';
import 'package:medical_app/Features/Auth/presentation/widgets/custom_button.dart';
import 'package:medical_app/Features/Auth/presentation/widgets/custom_textfield.dart';
import 'package:medical_app/Features/Auth/presentation/widgets/snackbarmessage.dart';
import 'package:medical_app/constant.dart';
import 'package:medical_app/core/utils/assets_data.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Registerview extends StatefulWidget {
  static String id = 'registerView';

  const Registerview({super.key});

  @override
  State<Registerview> createState() => _RegisterviewState();
}

class _RegisterviewState extends State<Registerview> {
  bool showSpinner = false;
  final GlobalKey<FormState> formKey = GlobalKey();
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          setState(() {
            showSpinner = true;
          });
        } else if (state is RegisterSuccess) {
          setState(() {
            showSpinner = false;
          });
          snackbarMessage(context, 'Register success');
          Navigator.pop(context);
        } else if (state is RegisterFailure) {
          setState(() {
            showSpinner = false;
          });
          snackbarMessage(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kPrimaryColor,
                    kPrimaryColor.withOpacity(0.7),
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          Center(
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 75,
                                backgroundImage:
                                    AssetImage(AssetsData.splashpic),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: Text(
                              'CareTrace',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign up to get started',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimaryColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  custom_textField(
                                    hint: 'Email',
                                    email: email,
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    prefixIcon: Icons.person_outline,
                                  ),
                                  const SizedBox(height: 16),
                                  custom_textField(
                                    hint: 'Password',
                                    password: password,
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    prefixIcon: Icons.lock_outline,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            buttonName: 'Register',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                BlocProvider.of<AuthCubit>(context)
                                    .registerUser(
                                        email: email!, password: password!);
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
