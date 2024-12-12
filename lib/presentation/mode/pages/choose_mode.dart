import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_button.dart';
import 'package:spotify_clone/common/widgets/button/mode_button.dart';
import 'package:spotify_clone/core/configs/assets/app_images.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/core/configs/theme/app_color.dart';
import 'package:spotify_clone/main.dart';
import 'package:spotify_clone/presentation/authentication/pages/signup_or_login.dart';
import 'package:spotify_clone/presentation/mode/bloc/theme_cubit.dart';

class ChooseMode extends StatelessWidget {
  const ChooseMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 40),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  AppImages.modeBG,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.15),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    AppVectors.logo,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Choose Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.grey,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ModeButton(
                      onPressed: () {
                        context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                      },
                      title: "Dark Mode",
                      mode: AppVectors.dark,
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    ModeButton(
                      onPressed: () {
                        context.read<ThemeCubit>().updateTheme(ThemeMode.light);
                      },
                      title: "Light Mode",
                      mode: AppVectors.light,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 70,
                ),
                BasicAppButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SignupOrLogin(),
                      ),
                    );
                  },
                  title: "Continue",
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
