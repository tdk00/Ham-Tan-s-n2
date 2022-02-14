import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/mixin/manual_navigator.dart';
import 'package:everyone_know_app/screen/settings/settings_screen.dart';
import 'package:everyone_know_app/utils/size/size.dart';
import 'package:everyone_know_app/view/text/text_view.dart';
import 'package:everyone_know_app/widget/profile/profile_edit_image.dart';
import 'package:flutter/material.dart';

import '../../api/account/profile.dart';
import '../../constants/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with ManualNavigatorMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              manualNavigatorTransition(
                context,
                const SettingScreen(),
              );
            },
            icon: const Icon(
              Icons.settings_outlined,
              size: 25,
              color: buttonColor,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const CustomTextView(
          textPaste: "Profile",
          fontWeight: FontWeight.w400,
          textColor: buttonColor,
          textSize: 18,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
    future: Profile.getProfileInfo(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData && snapshot.data.length > 0) {
        return
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 155,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: 115,
                        margin: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: buttonColor,
                        ),
                        child:  Center(
                          child: CustomTextView(
                            textPaste: snapshot.data[0].name !="null" ? snapshot.data[0].name : "" + snapshot.data[0].surname !="null" ? snapshot.data[0].surname : "",
                            textSize: 18,
                            textColor: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: ProfileEditImage(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 33,
                  top: screenHeight(context, 0.05),
                ),
                child: const CustomTextView(
                  textPaste: 'Məlumat',
                  textSize: 16,
                  textColor: textColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(
                  left: 33,
                  right: 11,
                  top: 14,
                ),
                child: CustomTextView(
                  textPaste:
                  snapshot.data[0].about !="null" ? snapshot.data[0].about : "",
                  textSize: 14,
                  textAlign: TextAlign.start,
                  textColor: textColorGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 33,
                  top: screenHeight(context, 0.03),
                ),
                child: const CustomTextView(
                  textPaste: 'Biznes',
                  textSize: 16,
                  textColor: textColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 33,
                  top: 14,
                ),
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: buttonColor,
                  ),
                  child:  Center(
                    child: CustomTextView(
                      textPaste: sampleBiznesModels.elementAt(
                          ((int.tryParse(snapshot.data[0].business) ?? 0) + 1) <
                              sampleBiznesModels.length &&
                              ((int.tryParse(snapshot.data[0].business) ?? 0) + 1) > -1
                              ? ((int.tryParse(snapshot.data[0].business) ?? 0) + 1)
                              : 0) ,
                      textSize: 14,
                      textColor: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          );
      }
      else
        {
          return Column();
        }
    }

        ),
      ),
    );
  }
}
