import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/appbar/appbar.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_button.dart';
import 'package:spotify_clone/common/widgets/form/form_filling.dart';
import 'package:spotify_clone/core/configs/assets/app_images.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/core/configs/theme/app_color.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';
import 'package:spotify_clone/domain/usecases/domain/signin.dart';
import 'package:spotify_clone/presentation/authentication/pages/registerPage.dart';
import 'package:spotify_clone/presentation/home/pages/homepage.dart';
import 'package:spotify_clone/presentation/authentication/bloc/authenticationEvent.dart';
import 'package:spotify_clone/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:spotify_clone/presentation/authentication/bloc/authentication_state.dart';
import 'package:spotify_clone/serviceLocator.dart';

class Signinpage extends StatefulWidget {
  const Signinpage({super.key});

  @override
  State<Signinpage> createState() => _SigninpageState();
}

class _SigninpageState extends State<Signinpage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                    "Sign In",
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
                    controller: emailController,
                    hintText: 'Username or Email',
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
                  Container(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Recovery Password",
                        style: TextStyle(
                          color:
                              context.isDarkMode ? AppColor.grey : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  BasicAppButton(
                    onPressed: () async {
                      var result = await sl<SignInUseCase>().call(
                          params: SigninUserReq(
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
                    title: "Sign In",
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
                  const SizedBox(
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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not A Member?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const RegisterPage(),
                            ),
                          );
                        },
                        child: Text("Register Now"),
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
