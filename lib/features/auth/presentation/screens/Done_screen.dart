import 'package:evetick/core/const/app_color.dart';
import 'package:evetick/core/const/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.darkBlue,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 500),
              Center(
                child: SvgPicture.asset(
                  'assets/images/wave.svg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                  ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 56, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/dark_logo.svg',
                    height: 49,
                    width: 74,
                  ),
                  SizedBox(height: 104),
                  SvgPicture.asset('assets/images/done.svg'),
                  SizedBox(height: 32),
                  Text(
                    'Done!',
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Successfully registered to \n EveTick',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.lightGray,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 250),
                  Button(
                    action: 'Start Exploring', 
                    width: double.infinity,
                    onTap: (){},
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
