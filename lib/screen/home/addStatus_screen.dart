import 'dart:io';

import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/component/custom_appbar.dart';
import 'package:everyone_know_app/component/custom_button.dart';
import 'package:everyone_know_app/domain/repository/create_user.repo.dart';
import 'package:everyone_know_app/domain/state/create_status_cubit/create_status_cubit.dart';
import 'package:everyone_know_app/utils/size/size.dart';
import 'package:everyone_know_app/view/text/text_view.dart';
import 'package:everyone_know_app/widget/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddStatusScreen extends StatefulWidget {
  const AddStatusScreen({Key? key}) : super(key: key);

  @override
  _AddStatusScreenState createState() => _AddStatusScreenState();
}

class _AddStatusScreenState extends State<AddStatusScreen> {
  final CreateUserRepository statusRepository = CreateUserRepository();
  late final CreateStatusCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CreateStatusCubit(statusRepository);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<CreateStatusCubit, CreateStatusState>(
          listener: (context, state) {
            if (state is CreateStatusLoaded) {
              Fluttertoast.showToast(msg: "Status uğurla yaradıldı : " + state.createStatus.text.toString());
              Navigator.of(context).pop();
            }

            if (state is CreateStatusError) {
              Fluttertoast.showToast(msg: state.error);
            }
          },
          builder: (context, state) {
            if (state is CreateStatusLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return _buildBody();
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: ResponsiveWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBarComponent(appBarText: "Əlavə et"),
            SizedBox(height: screenHeight(context, 0.05)),
            _buildImage(),
            Padding(
              padding: EdgeInsets.only(
                left: 21,
                top: screenHeight(context, 0.07),
                bottom: 15.0,
              ),
              child: const CustomTextView(
                textPaste: "Təsvir",
                textSize: 16,
                textColor: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              width: double.infinity,
              height: screenHeight(context, 0.2),
              margin: const EdgeInsets.only(
                left: 21,
                right: 21,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: const Color.fromRGBO(218, 225, 243, 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 11,
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  onChanged: _cubit.updateText,
                  maxLines: 10,
                  // controller: textEditingController,
                  decoration: const InputDecoration(
                    hintText: "Qeydi bura əlavə edin",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textColorGrey,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: CustomButton(
                buttonTextPaste: "Yekunlaşdır",
                callback: () {
                  _cubit.createStatusCubit();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return CupertinoButton(
      onPressed: () {
        _cubit.chooseImage();
      },
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .25,
          child: StreamBuilder<File?>(
            stream: _cubit.pickedImage$,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 35,
                    color: Colors.black,
                  ),
                );
              }

              return Image.file(
                snapshot.data!,
              );
            },
          ),
        ),
      ),
    );
  }
}
