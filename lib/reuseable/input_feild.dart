import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final bool obsecure;
  IconData icon;
  TextEditingController contr;
  FocusNode focNode;
  String labelText;
  String descrip;
  // Icon suffixicon;

  InputTextField({
    super.key,
    required this.contr,
    required this.descrip,
    required this.focNode,
    required this.labelText,
    required this.keyboardType,
    required this.obsecure,
    required this.icon,
    // this.suffixicon = Icons.,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      child: TextFormField(
        controller: contr,
        obscureText: obsecure,
        keyboardType: keyboardType,
        focusNode: focNode,
        validator: (value) {},
        onFieldSubmitted: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(icon),

          hintText: descrip,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
              bottomLeft: Radius.circular(30.r),
            ),
          ),
        ),
      ),
    );
  }
}
