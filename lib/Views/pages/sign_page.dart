import 'package:ecommerce/Views/widgets/text_field_widget.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/utils/app_routes.dart';
import 'package:ecommerce/view_models/auth_cubit/auth_cubit_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightB = MediaQuery.of(context).size.height;
    final widthB = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFF7A88), // slightly darker pink
              Color(0xFFF7A8D0), // deeper pink
              Color(0xFFFFD7B0), // deeper peach
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: widthB * 0.06,
                  vertical: heightB * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Login Account",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: const [
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
                      "Please login with your registered account",
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: Colors.white70),
                    ),
                    SizedBox(height: heightB * 0.035),

                    // Card container
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: widthB * 0.05,
                        vertical: heightB * 0.03,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 18,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFieldWidget(
                              name: "Email or Phone Number",
                              hintText: "Enter your email or phone number",
                              prefixIcon: CupertinoIcons.mail,
                              controller: emailController,
                              validate: (value) => validateEmail(value ?? ''),
                            ),
                            SizedBox(height: heightB * 0.018),
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
                                  obscured: true,
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

                    SizedBox(height: heightB * 0.035),

                    // === Sign In (kept original Bloc logic) ===
                    BlocConsumer<AuthCubitCubit, AuthCubitState>(
                      listenWhen: (previous, current) =>
                          current is AuthCubitSuccess ||
                          current is AuthCubitFailure,
                      listener: (context, state) {
                        if (state is AuthCubitSuccess) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.home,
                            (route) => false,
                          );
                        } else if (state is AuthCubitFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      buildWhen: (previous, current) =>
                          current is AuthCubitLoading ||
                          current is AuthCubitSuccess ||
                          current is AuthCubitFailure,
                      builder: (context, state) {
                        if (state is AuthCubitLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return SizedBox(
                          width: widthB * 0.9,
                          height: heightB * 0.065,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<AuthCubitCubit>(context).login(
                                  emailController.text,
                                  passwordController.text,
                                );
                              }
                            },
                            child: Text(
                              "Sign In",
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

                    SizedBox(height: heightB * 0.016),

                    // Navigate to registration (kept)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.registration);
                        },
                        child: Text(
                          "Don't have an account?",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ),

                    // OR divider
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: heightB * 0.01),
                      child: Row(
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
                    ),

                    SizedBox(height: heightB * 0.006),

                    // === Google (kept original Bloc logic) ===
                    BlocConsumer<AuthCubitCubit, AuthCubitState>(
                      listenWhen: (previous, current) =>
                          current is GoogleAuthenticated ||
                          current is GoogleAuthenticatingFailure,
                      listener: (context, state) {
                        if (state is GoogleAuthenticated) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.home,
                            (route) => false,
                          );
                        } else if (state is GoogleAuthenticatingFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      buildWhen: (previous, current) =>
                          current is GoogleAuthenticating ||
                          current is GoogleAuthenticated ||
                          current is GoogleAuthenticatingFailure,
                      builder: (context, state) {
                        if (state is GoogleAuthenticating) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            minimumSize: Size(widthB * 0.9, heightB * 0.065),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
                          label: const Text("Sign in with Google"),
                        );
                      },
                    ),

                    SizedBox(height: heightB * 0.014),

                    // === Facebook (kept original Bloc logic) ===
                    BlocConsumer<AuthCubitCubit, AuthCubitState>(
                      listenWhen: (previous, current) =>
                          current is FacebookAuthenticated ||
                          current is FacebookAuthenticatingFailure,
                      listener: (context, state) {
                        if (state is FacebookAuthenticated) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.home,
                            (route) => false,
                          );
                        } else if (state is FacebookAuthenticatingFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
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
                              borderRadius: BorderRadius.circular(20),
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
                          label: const Text("Sign in with Facebook"),
                        );
                      },
                    ),
                    SizedBox(height: heightB * 0.02),
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
