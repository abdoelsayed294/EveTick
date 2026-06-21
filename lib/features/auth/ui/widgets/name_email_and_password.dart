import 'package:evetick/core/helpers/app_regex.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/widgets/app_text_form_field.dart';
import 'package:evetick/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:evetick/features/auth/logic/signup_cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NameEmailAndPassword extends StatefulWidget {
  const NameEmailAndPassword({super.key});

  @override
  State<NameEmailAndPassword> createState() => _NameEmailAndPasswordState();
}

class _NameEmailAndPasswordState extends State<NameEmailAndPassword> {
  bool isObscureText = true;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    return Form(
      key: context.read<SignupCubit>().formKey,
      child: Column(
        children: [
          AppTextFormField(
            label: 'Full Name',
            hintText: 'Enter your Name',
            
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Please enter a valid name';
              }
            },
            controller: context.read<SignupCubit>().nameController,
          ),
          verticalSpace(16),
          AppTextFormField(
            label: 'Email Address',
            hintText: 'Enter your email',
            suffixIcon: Icon(
              Icons.email_outlined,
              color: ColorsManager.lightGray,
              size: 24.sp,
            ),
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Please enter a valid email';
              }
            },
            controller: context.read<SignupCubit>().emailController,
          ),
          verticalSpace(16),

          AppTextFormField(
            label: 'Password',
            hintText: 'Enter your password',
            isObscureText: isObscureText,
            controller: context.read<SignupCubit>().passwordController,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isObscureText = !isObscureText;
                });
              },
              child: Icon(
                isObscureText ? Icons.visibility_off : Icons.visibility,
                color: ColorsManager.lightGray,
                size: 24.sp,
              ),
            ),
            validator: (value) {
              if(value == null || value.isEmpty || AppRegex.isPasswordValid(value)){
                return 'Please enter a valid password';
              }
            },
          ),
        ],
      ),
    );
  }
}
