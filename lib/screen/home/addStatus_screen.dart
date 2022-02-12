import 'dart:io';

import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/component/custom_appbar.dart';
import 'package:everyone_know_app/component/custom_button.dart';
import 'package:everyone_know_app/domain/state/create_status_cubit/create_status_cubit.dart';
import 'package:everyone_know_app/utils/size/size.dart';
import 'package:everyone_know_app/view/text/text_view.dart';
import 'package:everyone_know_app/widget/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddStatusScreen extends StatefulWidget {
  const AddStatusScreen({Key? key}) : super(key: key);

  @override
  _AddStatusScreenState createState() => _AddStatusScreenState();
}

class _AddStatusScreenState extends State<AddStatusScreen> {

  @override
  void initState() {
    super.initState();
    context.read<CreateStatusCubit>().chooseImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ResponsiveWidget(
          child: BlocConsumer<CreateStatusCubit, CreateStatusState>(
            listener: (context, state) {
              if(state is CreateStatusImageNotSelected) {
                Navigator.of(context).pop();
              }
               if (state is CreateStatusLoaded) {
                Fluttertoast.showToast(
                    msg: "Status ugurla yaradildi : " +
                        state.createStatus.text.toString());

                        Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              if (state is CreateStatusLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(state is CreateStatusImageSelected) {
                return Stack(
               
                children: [
                  Image.file(
                    state.image,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.contain,
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: CustomAppBarComponent(appBarText: "Əlavə et"),
                  ),
                   Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                    padding: const EdgeInsets.only(bottom: kToolbarHeight),
                    child: CustomButton(
                      buttonTextPaste: "Yekunlaşdır",
                      callback: ()async  {
                         SharedPreferences _prefs =await  SharedPreferences.getInstance();
                        BlocProvider.of<CreateStatusCubit>(context)
                            .createStatusCubit(
                          _prefs.getString('user_id') ?? '1',
                          
                           state.image,
                        );
                        Fluttertoast.showToast(
                          msg: "Status ugurla yaradildi",
                          toastLength: Toast.LENGTH_LONG,
                        );
                       
                      },
                    ),
                   ),
                  ),
                ],
              );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBarComponent(appBarText: "Əlavə et"),
                  SizedBox(
                    height: screenHeight(context, 0.05),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: ()  {
                        context.read<CreateStatusCubit>().chooseImage();
                      
                      },
                      child: const SizedBox(
                        width: 120,
                        height: 200,
                        child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 35,
                                  color: Colors.black,
                                ),
                              ),
                           
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
