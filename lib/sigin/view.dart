import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fog_map/sigin/sign_up_view.dart';
import 'package:fog_map/views/home.dart';
import 'package:get/get.dart';
import '../reuseable/input_feild.dart';
import '../reuseable/round_button.dart';
import 'controller.dart';

class SignInPage extends GetView<SignInController> {
  SignInPage({Key? key}) : super(key: key);
  final _formKwy = GlobalKey<FormState>();

  Widget _buildLogo() {
    return Container(
        child: Image(
      image: AssetImage('assets/images/loggin.jpg'),
    ));
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Log In',
        style: TextStyle(color: Colors.black, fontSize: 30.sp),
      ),
      backgroundColor: Colors.white,
      elevation: 0.3,
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKwy,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.0.h, bottom: 4.h),
            child: InputTextField(
                obsecure: false,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email_outlined,
                contr: controller.emailController,
                descrip: 'Enter your email',
                focNode: controller.emailFocus,
                labelText: 'Email'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0.h),
            child: InputTextField(
                obsecure: true,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.lock_open,
                contr: controller.passwordController,
                descrip: 'Enter your password',
                focNode: controller.passwordFocus,
                labelText: 'Password'),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdPartyServices(String loginType, String logo) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 54.h,
        width: 280.w,
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              logo == '' ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            logo == ''
                ? Container()
                : Container(
                    padding: EdgeInsets.only(left: 44.w, right: 30.w),
                    child: Image.asset('assets/icons/$logo.png'),
                  ),
            Text(
              'Sign in with $loginType',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              children: [
                _buildAppBar(),
                _buildLogo(),
                _buildForm(),
                InkWell(
                  onTap: () {
                    // Get.toNamed(AppRoutes.Forgot_Password);
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 20.w),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: RoundButton(
                    title: 'LogIn',
                    // loading: controller.state.loading.value,
                    onPress: () {
                      if (_formKwy.currentState!.validate()) {
                        controller.logInUser(
                          controller.emailController.text.trim(),
                          controller.passwordController.text.trim(),
                        );
                      }
                    },
                  ),
                ),
                // _buildThirdPartyServices('Google', 'google'),
                SizedBox(height: 15.h),
                InkWell(
                  onTap: () {
                    Get.to(() => SignUpView());
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account?',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Sign Up',
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
