import 'package:ecommerce/Views/widgets/text_field_widget.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:ecommerce/view_models/auth_cubit/auth_cubit_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final heightB = MediaQuery.of(context).size.height;
    final widthB = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEF7D82), // darker soft pink
              Color(0xFFF7B4D9), // deeper pink
              Color(0xFFFFE1C2), // deeper peach/cream
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: widthB * 0.07),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: heightB * 0.01),
                  Text(
                    "Don’t have an account? Create one to join us!",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: heightB * 0.04),

                  // Form
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black26,
                    child: Padding(
                      padding: EdgeInsets.all(widthB * 0.05),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFieldWidget(
                              name: "Username",
                              hintText: "Create your username",
                              prefixIcon: CupertinoIcons.person,
                              controller: nameController,
                            ),
                            TextFieldWidget(
                              name: "Email Address",
                              hintText: "Enter your email address",
                              prefixIcon: CupertinoIcons.mail,
                              controller: emailController,
                              validate: (value) => validateEmail(value ?? ''),
                            ),
                            SizedBox(height: heightB * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextFieldWidget(
                                  name: "Password",
                                  hintText: "Enter your password",
                                  prefixIcon: CupertinoIcons.lock,
                                  controller: passwordController,
                                  validate: (value) => validatePassword(
                                    value ?? '',
                                    emailController.text,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text("Forgot Password?"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: heightB * 0.04),
                  // Signup button with BlocConsumer
                  BlocConsumer<AuthCubitCubit, AuthCubitState>(
                    listenWhen: (previous, current) =>
                        current is AuthCubitSuccess ||
                        current is AuthCubitFailure,
                    listener: (context, state) {
                      if (state is AuthCubitSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("You are ready to Login"),
                          ),
                        );
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      } else if (state is AuthCubitFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is AuthCubitLoading ||
                        current is AuthCubitSuccess ||
                        current is AuthCubitFailure,
                    builder: (context, state) {
                      if (state is AuthCubitLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox(
                        width: widthB * 0.9,
                        height: heightB * 0.065,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 6,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AuthCubitCubit>(context).register(
                                emailController.text,
                                passwordController.text,
                                nameController.text,
                              );
                            }
                          },
                          child: Text(
                            "Sign Up",
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: heightB * 0.03),

                  // Divider OR
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.white70),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.white70),
                      ),
                    ],
                  ),

                  SizedBox(height: heightB * 0.02),

                  // Google Signup
                  BlocConsumer<AuthCubitCubit, AuthCubitState>(
                    listenWhen: (previous, current) =>
                        current is GoogleAuthenticated ||
                        current is GoogleAuthenticatingFailure,
                    listener: (context, state) {
                      if (state is GoogleAuthenticated) {
                        Navigator.pushNamed(context, AppRoutes.home);
                      } else if (state is GoogleAuthenticatingFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is GoogleAuthenticating ||
                        current is GoogleAuthenticated ||
                        current is GoogleAuthenticatingFailure,
                    builder: (context, state) {
                      if (state is GoogleAuthenticating) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            minimumSize: Size(widthB * 0.9, heightB * 0.065),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () async =>
                              await BlocProvider.of<AuthCubitCubit>(
                                context,
                              ).GoogleLogin(),
                          icon: Image.asset(
                            'assets/images/google_logo.png',
                            height: 24,
                          ),
                          label: const Text("Sign Up with Google"),
                        );
                      }
                    },
                  ),

                  SizedBox(height: heightB * 0.02),

                  // Facebook Signup
                  BlocConsumer<AuthCubitCubit, AuthCubitState>(
                    listenWhen: (previous, current) =>
                        current is FacebookAuthenticated ||
                        current is FacebookAuthenticatingFailure,
                    listener: (context, state) {
                      if (state is FacebookAuthenticated) {
                        Navigator.pushNamed(context, AppRoutes.home);
                      } else if (state is FacebookAuthenticatingFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is FacebookAuthenticating ||
                        current is FacebookAuthenticatingFailure ||
                        current is FacebookAuthenticated,
                    builder: (context, state) {
                      if (state is FacebookAuthenticating) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      return ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: Size(widthB * 0.9, heightB * 0.065),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () async =>
                            await BlocProvider.of<AuthCubitCubit>(
                              context,
                            ).FacebookLogin(),
                        icon: Image.asset(
                          'assets/images/facebook_logo.png',
                          height: 28,
                        ),
                        label: const Text("Sign Up with Facebook"),
                      );
                    },
                  ),

                  SizedBox(height: heightB * 0.03),

                  // Navigate to Login
                  SizedBox(height: heightB * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? validateEmail(String? value) {
  const pattern =
      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return value!.isNotEmpty && !regex.hasMatch(value)
      ? 'Enter a valid email address'
      : null;
}

String? validatePassword(String value, String email) {
  RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  if (value.isEmpty) {
    return 'Please enter password';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Should be at least 8 characters, one uppercase, one lowercase, one number';
    } else {
      return null;
    }
  }
}
