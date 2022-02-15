import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/component/custom_appbar.dart';
import 'package:everyone_know_app/domain/model/message_list_model.dart';
import 'package:everyone_know_app/domain/state/message_list/message_list_cubit.dart';
import 'package:everyone_know_app/domain/state/navigation_cubit/navigation_cubit_cubit.dart';
import 'package:everyone_know_app/mixin/manual_navigator.dart';
import 'package:everyone_know_app/utils/enums/navbar_item.dart';
import 'package:everyone_know_app/utils/size/size.dart';
import 'package:everyone_know_app/view/text/text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'chat_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with ManualNavigatorMixin {
  @override
  void initState() {
    super.initState();
    context.read<MessageListCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 244, 250, 1),
      body: BlocConsumer<MessageListCubit, MessageListState>(
        listener: (context, state) {
          if (state is MessageListAlert) {
            Fluttertoast.showToast(msg: state.message);
          }
        },
        builder: (context, state) {
          if (state is MessageListFetched) {
            return _buildBody(state.messages);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildBody(List<MessageListModel> messages) {
    return SafeArea(
      child: Column(
        children: [
          CustomAppBarComponent(
            appBarText: "Söhbətlər",
            callback: () {
              BlocProvider.of<NavigationCubitCubit>(context).getNavBarItem(NavbarItem.home);
            },
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight(context, 0.05),
              ),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (ctx, index) {
                  final message = messages.elementAt(index);

                  return Padding(
                    padding: const EdgeInsets.only(top: 14, left: 10, right: 10),
                    child: GestureDetector(
                      onTap: () {
                        manualNavigatorTransition(
                          context,
                          ChatScreen(
                            userId: message.id!,
                            firstname: message.name,
                            lastname: message.surname,
                            image: message.imageX,
                          ),
                        );
                      },
                      //   child: MessageItem(
                      //     imageOrNameText: index > 0 ? "al" : "1",
                      //     msgNotif: index == 1 ? "Sabah dırnaq üçün yazılmaq istəyirəm, alınır?" : "Məsmə sabah gəlim paltarın ölcüsünü primerka edək",
                      //     msgName: "Anaxanım${index + 1}",
                      //     msgNoVisibleColor: index == 0 ? textColorGrey : textColor,
                      //   ),
                      child: ListTile(
                        leading: message.imageX == null
                            ? Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: profileEditImageColor,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      "assets/icon.png",
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: profileEditImageColor,
                                ),
                                child: Image.network(
                                  message.imageX!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, obj, stck) {
                                    return Image.asset(
                                      'assets/icon.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: CustomTextView(
                                textPaste: '${message.name ?? ''} ${message.surname ?? ''}',
                                textSize: 16,
                                textColor: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const CustomTextView(
                              textPaste: "21/11/2021",
                              textSize: 11,
                              textColor: textColorGrey,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        subtitle: CustomTextView(
                          textPaste: message.message,
                          textSize: 13,
                          textColor: textColorGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
