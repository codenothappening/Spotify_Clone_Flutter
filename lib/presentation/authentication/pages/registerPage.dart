import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/appbar/appbar.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_button.dart';
import 'package:spotify_clone/common/widgets/form/form_filling.dart';
import 'package:spotify_clone/core/configs/assets/app_images.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/data/models/auth/create_user_request.dart';
import 'package:spotify_clone/domain/usecases/domain/signup.dart';
import 'package:spotify_clone/presentation/authentication/pages/SigninPage.dart';
import 'package:spotify_clone/presentation/authentication/bloc/authenticationEvent.dart';
import 'package:spotify_clone/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:spotify_clone/presentation/authentication/bloc/authentication_state.dart';
import 'package:spotify_clone/serviceLocator.dart';

import '../../../core/configs/theme/app_color.dart';
import '../../home/pages/homepage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  // void _registerUser(BuildContext context) {
  //   final email = emailController.text.trim();
  //   final password = passwordController.text.trim();
  //   final fullName = fullNameController.text.trim();

  //   print("Password Entered : $password");

  //   if (password.length < 6) {
  //     // Show weak password error
  //     showDialog(
  //       context: context,
  //       builder: (context) => const AlertDialog(
  //         title: Text("Weak Password"),
  //         content: Text("Password should be at least 6 characters long."),
  //       ),
  //     );
  //   } else if (email.isEmpty || !email.contains('@')) {
  //     // Show email validation error
  //     showDialog(
  //       context: context,
  //       builder: (context) => const AlertDialog(
  //         title: Text("Invalid Email"),
  //         content: Text("Please enter a valid email address."),
  //       ),
  //     );
  //   } else {
  //     // Dispatch event to register user
  //     BlocProvider.of<AuthenticationBloc>(context).add(
  //       SignUpUser(email, password, fullName),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BasicAppbar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      height: 33,
                      AppVectors.logo,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "If you Need any Support",
                        style: TextStyle(color: AppColor.darkGrey),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Click Here",
                          style: TextStyle(
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FormFilling(
                    controller: fullNameController,
                    hintText: 'Full Name',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FormFilling(
                    controller: emailController,
                    hintText: 'Enter Email',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FormFilling(
                    controller: passwordController,
                    hintText: 'Password',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  BasicAppButton(
                    onPressed: () async {
                      var result = await sl<SignupUseCase>().call(
                          params: CreateUserReq(
                        fullName: fullNameController.text.toString(),
                        email: emailController.text.toString(),
                        password: passwordController.text.toString(),
                      ));
                      result.fold(
                        (l) {
                          var snackbar = SnackBar(content: Text(l));
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        },
                        (r) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Homepage()),
                            (route) => false,
                          );
                        },
                      );
                    },
                    title: "Create Account",
                    height: 80,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.withOpacity(0.5),
                          thickness: 1.5,
                          endIndent: 10,
                        ),
                      ),
                      Text(
                        "Or ",
                        style: TextStyle(
                          color:
                              context.isDarkMode ? Colors.grey : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey.withOpacity(0.5),
                          thickness: 1.5,
                          endIndent: 10,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                        ),
                        child: Image.asset(
                          AppImages.googleImage,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                        ),
                        child: Image.asset(
                          context.isDarkMode
                              ? AppImages.appleImageDark
                              : AppImages.appleImage,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an Account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Signinpage(),
                            ),
                          );
                        },
                        child: Text("Sign In"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
