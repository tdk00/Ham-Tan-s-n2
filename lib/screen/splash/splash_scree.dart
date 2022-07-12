import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/component/custom_button.dart';
import 'package:everyone_know_app/mixin/manual_navigator.dart';
import 'package:everyone_know_app/screen/auth/choose_region.dart';
import 'package:everyone_know_app/utils/size/size.dart';
import 'package:everyone_know_app/view/text/text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with ManualNavigatorMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackground,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                  ),
                  child: SvgPicture.asset('assets/logo.svg'),
                  //   child: const SplashImageWidget(
                  //     imageUrl:
                  //         "https://st.depositphotos.com/1006706/2671/i/600/depositphotos_26715369-stock-photo-which-way-to-choose-3d.jpg",
                  //   ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: screenHeight(context, 0.4),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 275,
                      height: 275,
                      margin: const EdgeInsets.only(
                        top: 80,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromRGBO(253, 251, 255, 1),
                        border: Border.all(
                          width: 40,
                          color: const Color.fromRGBO(248, 243, 255, 1),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                        left: screenWidth(context, 0.1),
                      ),
                      child: Image.asset('assets/images/circle1.png'),
                      //   child: const SplashImageWidget(
                      //     imageUrl:
                      //         "https://st.depositphotos.com/1006706/2671/i/600/depositphotos_26715369-stock-photo-which-way-to-choose-3d.jpg",
                      //   ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 45,
                        bottom: screenHeight(context, 0.02),
                      ),
                      child: Image.asset('assets/images/circle2.png'),
                      //   child: const SplashImageWidget(
                      //     widthSize: 82,
                      //     heightSize: 82,
                      //     imageUrl: "http://www.goodmorningimagesdownload.com/wp-content/uploads/2020/06/Alone-Boys-Girls-Images-6.jpg",
                      //   ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 32,
                        bottom: screenHeight(context, 0.01),
                      ),
                      child: Image.asset('assets/images/circle3.png'),
                      //   child: const SplashImageWidget(
                      //     widthSize: 54,
                      //     heightSize: 54,
                      //     imageUrl: "https://media.istockphoto.com/photos/hiker-on-top-of-the-mountain-enjoying-sunset-picture-id1284549418?b=1&k=20&m=1284549418&s=170667a&w=0&h=3LP-ngMkpGNWH605WJWUkvyYK7uYPHsiIXVs69yz0I4=",
                      //   ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: screenWidth(context, 0.23),
                        bottom: screenHeight(context, 0.01),
                      ),
                      child: Image.asset('assets/images/circle4.png'),
                      //   child: const SplashImageWidget(
                      //     widthSize: 96,
                      //     heightSize: 96,
                      //     imageUrl: "https://t3.ftcdn.net/jpg/02/92/27/64/360_F_292276450_c2RWJJlHcgUeA7Q0Gyr4IVNLIapSlfqE.jpg",
                      //   ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight(context, 0.25),
                        left: screenWidth(context, 0.25),
                      ),
                      child: Image.asset('assets/images/circle5.png'),
                      //   child: const SplashImageWidget(
                      //     widthSize: 55,
                      //     heightSize: 55,
                      //     imageUrl: "https://d5nunyagcicgy.cloudfront.net/external_assets/hero_examples/hair_beach_v391182663/original.jpeg",
                      //   ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 38),
                      child: CustomTextView(
                        textPaste: "Sizə yaxın\ntəklifləri kəşf edin",
                        fontWeight: FontWeight.w600,
                        textSize: 25,
                        textColor: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 38),
                      child: CustomTextView(
                        textPaste: "Siz də bizim böyük icmamıza qoşulun",
                        fontWeight: FontWeight.w500,
                        textSize: 14,
                        textColor: Colors.black,
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 50,
                      ),
                      child: CustomButton(
                        callback: () {
                          manualNavigatorTransition(
                            context,
                            const ChooseRegionScreen(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
