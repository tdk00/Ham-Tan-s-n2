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
import 'package:intl/intl.dart';

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
      backgroundColor: const Color(0xFFEEEAF2),
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
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<MessageListCubit>().fetch();
              },
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
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            manualNavigatorTransition(
                              context,
                              ChatScreen(
                                userId: message.id!,
                                firstname: message.name,
                                lastname: message.surname,
                                image: message.imageX,
                                isStory: false,
                              ),
                            );
                          },
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                CustomTextView(
                                  textPaste: date(message.timestamp),
                                  textSize: 11,
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                            subtitle: ((message.message ?? '').trim() == '')
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.photo,
                                        size: 18.0,
                                        color: (message.isRead ?? false) ? textColorGrey : Colors.black,
                                      ),
                                      const SizedBox(width: 6.0),
                                      CustomTextView(
                                        textPaste: 'Şəkil göndərildi',
                                        textSize: 15,
                                        textColor: (message.isRead ?? false) ? textColorGrey : Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  )
                                : CustomTextView(
                                    textPaste: message.message,
                                    textSize: 15,
                                    textColor: (message.isRead ?? false) ? textColorGrey : Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String date(DateTime? timestamp) {
    DateFormat format = DateFormat("dd.MM.yyyy");
    final formattedTime = format.format(timestamp!);
    return formattedTime;
  }
}
