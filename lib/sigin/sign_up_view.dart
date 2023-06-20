import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fog_map/sigin/index.dart';
import 'package:get/get.dart';

import '../reuseable/input_feild.dart';
import '../reuseable/round_button.dart';

class SignUpView extends GetView<SignInController> {
  SignUpView({Key? key}) : super(key: key);

  final _formKwy = GlobalKey<FormState>();

  Widget _buildLogo() {
    return Container(
        child: Image(
      image: AssetImage('assets/images/signUp.jpg'),
    ));
  }

  Widget _signUpForm() {
    return Form(
        key: _formKwy,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0.h),
              child: InputTextField(
                  obsecure: false,
                  keyboardType: TextInputType.text,
                  icon: Icons.person_outline,
                  contr: controller.userController,
                  descrip: 'Enter your username',
                  focNode: controller.userFocus,
                  labelText: 'UserName'),
            ),
            InputTextField(
                obsecure: false,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email_outlined,
                contr: controller.emailController,
                descrip: 'Enter your email',
                focNode: controller.emailFocus,
                labelText: 'Email'),
            InputTextField(
                obsecure: true,
                keyboardType: TextInputType.visiblePassword,
                icon: Icons.lock_open,
                contr: controller.passwordController,
                descrip: 'Enter your password',
                focNode: controller.passwordFocus,
                labelText: 'Password'),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.015),
                _buildLogo(),
                SizedBox(
                  height: height * 0.05,
                ),
                _signUpForm(),
                SizedBox(height: 20.h),
                Obx(
                  () => Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: RoundButton(
                      title: 'SignUp',
                      loading: controller.state.loading.value,
                      onPress: () {
                        controller.registerUser(
                          controller.emailController.text.toString(),
                          controller.passwordController.text.toString(),
                        );
                        // Get.to(() => HomeScreen());
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => SignInPage());
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account?',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
