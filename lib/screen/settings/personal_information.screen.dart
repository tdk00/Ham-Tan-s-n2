import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/component/custom_appbar.dart';
import 'package:everyone_know_app/component/custom_button.dart';
import 'package:everyone_know_app/constants/constants.dart';
import 'package:everyone_know_app/utils/size/size.dart';
import 'package:everyone_know_app/view/auth/register_form_view.dart';
import 'package:everyone_know_app/widget/responsive.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../api/account/profile.dart';

class PersonalInformationScreen extends StatefulWidget {
  final String? ad;
  final String? soyad;
  final String? marriage;
  final String? business;
  final String? about;
  const PersonalInformationScreen({
    Key? key,
    this.ad,
    this.soyad,
    this.marriage,
    this.business,
    this.about
  }) : super(key: key);

  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  String? _chosenValue;
  String? _chosenValueBusiness;
  TextEditingController adController = TextEditingController();
  TextEditingController soyadController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  @override
  void initState(){
    super.initState();
    String ad = widget.ad??"";
    String soyad = widget.soyad??"";
    adController.text = ad;
    soyadController.text = soyad;
    aboutController.text = widget.about??"";
    tezeFunksiya();
  }

  void tezeFunksiya() async {
    List<ProfileInfo> mstatus = await Profile.getProfileInfo();
    if( mstatus.isNotEmpty )
    {
      setState(() {
        _chosenValue = mstatus[0].marriage == "E" ? "Evli" : ( mstatus[0].marriage == "S" ? "Subay" : null);
        _chosenValueBusiness = "Dərzi";
      });

    }
  }
  Widget build(BuildContext context) {
    print(_chosenValue);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ResponsiveWidget(
          child: Column(
            children: [
              const CustomAppBarComponent(
                appBarText: "Şəxsi məlumatlar",
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight(context, 0.04),
                ),
                child: RegisterFormView(
                  controller: adController,
                  formName: "Ad",
                  hintFontSize: 15,
                  formHintText: "Adınızı yazın",
                    formFieldBackColor: customTextFormFieldBackColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight(context, 0.03),
                ),
                child: RegisterFormView(
                  controller: soyadController,
                  formName: "Soyad",
                  hintFontSize: 15,
                  formHintText: "Soyadınızı yazın",
                  formFieldBackColor: customTextFormFieldBackColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight(context, 0.03),
                ),
                child: RegisterFormView(
                  formName: "Ailə vəziyyəti",
                  hintFontSize: 15,
                    formFieldBackColor: customTextFormFieldBackColor,
                  childWidget: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: DropdownButton<String>(
                      value: _chosenValue,
                      underline: const SizedBox(),
                      style: const TextStyle(color: Colors.black),
                      items: maritalStatus
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: const Text(
                        "Zəhmət olmasa seçin",
                        style: TextStyle(
                          color: textColorGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
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
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight(context, 0.03),
                ),
                child: RegisterFormView(
                  formName: "Biznesiniz",
                  hintFontSize: 15,
                  formFieldBackColor: customTextFormFieldBackColor,
                  childWidget: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: DropdownButton<String>(
                      value: _chosenValueBusiness,
                      underline: const SizedBox(),
                      style: const TextStyle(color: Colors.black),
                      items: sampleBiznesModels
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: const Text(
                        "Zəhmət olmasa seçin",
                        style: TextStyle(
                          color: textColorGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _chosenValueBusiness = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight(context, 0.03),
                ),
                child: RegisterFormView(
                  controller: aboutController,
                  formName: "Haqqınızda",
                  hintFontSize: 15,
                    formFieldBackColor: customTextFormFieldBackColor,
                  formHintText: "Qısa məlumat",
                ),
              ),
              const Spacer(
                flex: 2,
              ),
               Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: CustomButton(
                  buttonTextPaste: "Yadda saxla",
                  callback: () async {
                      var result = await Profile.saveProfileInfo(
                          adController.text,
                          soyadController.text,
                          _chosenValue == "Evli" ? "E" : (_chosenValue == "Subay" ? "S" : null).toString(),
                          _chosenValueBusiness.toString(),
                          aboutController.text);
                      if( result == "ok" )
                        {
                          Fluttertoast.showToast(msg: "Qeydə alındı");
                        }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
