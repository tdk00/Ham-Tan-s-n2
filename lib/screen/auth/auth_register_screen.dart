import 'package:everyone_know_app/api/account/name_surname.dart';
import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/component/custom_button.dart';
import 'package:everyone_know_app/constants/constants.dart';
import 'package:everyone_know_app/mixin/manual_navigator.dart';
import 'package:everyone_know_app/screen/home/navigation_screen.dart';
import 'package:everyone_know_app/utils/size/size.dart';
import 'package:everyone_know_app/view/auth/register_form_view.dart';
import 'package:everyone_know_app/view/text/text_view.dart';
import 'package:everyone_know_app/widget/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthRegisterScreen extends StatefulWidget {
  const AuthRegisterScreen({Key? key}) : super(key: key);

  @override
  _AuthRegisterScreenState createState() => _AuthRegisterScreenState();
}

class _AuthRegisterScreenState extends State<AuthRegisterScreen> with ManualNavigatorMixin {
  String? _chosenValue;

  TextEditingController adController = TextEditingController();
  TextEditingController soyadController = TextEditingController();

  @override
  void dispose() {
    adController.dispose();
    soyadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ResponsiveWidget(
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight(context, 0.1),
                ),
                Center(
                  child: SvgPicture.asset('assets/logo.svg'),
                ),
                SizedBox(
                  height: screenHeight(context, 0.1),
                ),
                Container(
                  //   width: double.infinity,
                  //   height: double.infinity,
                  //   margin: EdgeInsets.only(
                  //     top: screenHeight(context, 0.2),
                  //   ),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(247, 247, 247, 1),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.5),
                      topLeft: Radius.circular(16.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 22,
                          top: 34,
                        ),
                        child: CustomTextView(
                          textPaste: "Qeydiyyat",
                          textSize: 25,
                          fontWeight: FontWeight.w600,
                          textColor: textColor,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 22,
                          top: 25,
                        ),
                        child: CustomTextView(
                          textPaste: "M??lumatlar??n??z?? ??lav?? edin",
                          textSize: 13,
                          fontWeight: FontWeight.w500,
                          textColor: textColor,
                        ),
                      ),
                      // todo Name FormFiled
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight(context, 0.03),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 75,
                          margin: const EdgeInsets.only(right: 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 22,
                                ),
                                child: CustomTextView(
                                  textPaste: "Ad",
                                  textSize: 14,
                                  textColor: textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 22,
                                  top: 5,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: whiteColor,
                                  ),
                                  padding: const EdgeInsets.only(left: 14),
                                  child: TextFormField(
                                    controller: adController,
                                    keyboardType: TextInputType.text,
                                    enabled: true,
                                    inputFormatters: const [],
                                    decoration: const InputDecoration(
                                      hintText: "Ad??n??z?? daxil edin",
                                      border: InputBorder.none,
                                      // todo Montserrat
                                      hintStyle: TextStyle(fontSize: 13, color: textColorGrey, fontWeight: FontWeight.w500, fontFamily: "Montserrat"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // todo Surname Forfield
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight(context, 0.02),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 75,
                          margin: const EdgeInsets.only(right: 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 22,
                                ),
                                child: CustomTextView(
                                  textPaste: "Soyad",
                                  textSize: 14,
                                  textColor: textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 22,
                                  top: 5,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: whiteColor,
                                  ),
                                  padding: const EdgeInsets.only(left: 14),
                                  child: TextFormField(
                                    controller: soyadController,
                                    keyboardType: TextInputType.text,
                                    enabled: true,
                                    inputFormatters: const [],
                                    decoration: const InputDecoration(
                                      hintText: " Soyad??n??z?? daxil edin",
                                      border: InputBorder.none,
                                      // todo Montserrat
                                      hintStyle: TextStyle(fontSize: 13, color: textColorGrey, fontWeight: FontWeight.w500, fontFamily: "Montserrat"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //todo Biznes FormFiled
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight(context, 0.03),
                        ),
                        child: RegisterFormView(
                          formName: "Biznesiniz",
                          hintFontSize: 15,
                          formFieldBackColor: Colors.white,
                          childWidget: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: DropdownButton<String>(
                              value: _chosenValue,
                              underline: const SizedBox(),
                              style: const TextStyle(color: Colors.black),
                              items: sampleBiznesModels.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: CustomTextView(
                                    textPaste: value,
                                  ),
                                );
                              }).toList(),
                              hint: const CustomTextView(
                                textPaste: "Z??hm??t olmasa se??in",
                                textSize: 13,
                                fontWeight: FontWeight.w500,
                                textColor: textColorGrey,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _chosenValue = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight(context, 0.07),
                      ),
                      CustomButton(
                        buttonTextPaste: "Ba??la",
                        callback: () async {
                          print(adController.text);
                          print(soyadController.text);
                          print(_chosenValue);
                          if (adController.text.isEmpty || soyadController.text.isEmpty || _chosenValue.toString().isEmpty) {
                            Fluttertoast.showToast(msg: "B??t??n xanalar?? doldurun", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                          } else {
                            var saveUserInfo = await NameSurname.save(adController.text, soyadController.text, int.parse(sampleBiznesModels.indexOf(_chosenValue ?? 'a').toString()));
                            // manualNavigatorTransition(
                            //   context,
                            //   const NavigationScreen(),
                            // );

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const NavigationScreen()),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ],
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
