// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_app/Features/Auth/presentation/widgets/custom_button.dart';
import 'package:medical_app/Features/Auth/presentation/widgets/custom_textfield.dart';
import 'package:medical_app/constant.dart';
import 'package:medical_app/core/utils/assets_data.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/utils/app_router.dart';
import '../../busines_logic/auth_cubit/cubit/auth_cubit.dart';
import '../widgets/snackbarmessage.dart';

class LoginView extends StatelessWidget {
  String? email;
  String? password;
  static String id = 'loginView';
  GlobalKey<FormState> formKey = GlobalKey();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          showSpinner = true;
        } else if (state is LoginSuccess) {
          snackbarMessage(context, 'login success');
          GoRouter.of(context).push(AppRouter.kHomeview);
          showSpinner = false;
        } else if (state is LoginFailure) {
          showSpinner = false;
          snackbarMessage(context, state.errorMessage);
        }
      },
      child: ModalProgressHUD(
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
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
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
                              backgroundImage: AssetImage(AssetsData.splashpic),
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
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue',
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
                                  onChanged: (value) {
                                    email = value;
                                  },
                                  hint: 'Email',
                                  prefixIcon: Icons.person_outline,
                                ),
                                const SizedBox(height: 16),
                                custom_textField(
                                  hint: 'Password',
                                  obsecure: true,
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
                          buttonName: 'Login',
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              BlocProvider.of<AuthCubit>(context).loginUser(
                                  email: email!, password: password!);
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                GoRouter.of(context)
                                    .push(AppRouter.kRegisterview);
                              },
                              child: Text(
                                'Register',
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
      ),
    );
  }
}
