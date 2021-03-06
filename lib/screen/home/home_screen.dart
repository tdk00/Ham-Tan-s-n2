import 'dart:developer';

import 'package:everyone_know_app/api/account/name_surname.dart';
import 'package:everyone_know_app/api/main/statuses.dart';
import 'package:everyone_know_app/color/app_color.dart';
import 'package:everyone_know_app/domain/state/navigation_cubit/navigation_cubit_cubit.dart';
import 'package:everyone_know_app/local/fake_locations.dart';
import 'package:everyone_know_app/mixin/manual_navigator.dart';
import 'package:everyone_know_app/screen/home/status_view.dart';
import 'package:everyone_know_app/utils/enums/navbar_item.dart';
import 'package:everyone_know_app/utils/size/size.dart';
import 'package:everyone_know_app/view/auth/choose_region_view.dart';
import 'package:everyone_know_app/view/text/text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/account/profile.dart';
import '../../constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ManualNavigatorMixin {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  int lastIndex = -1;
  String locationName = "Ağcabədi";
  String? regionId = '';
  var _future;
  Future<void> getRegionId() async {
    List<ProfileInfo> inf = await Profile.getProfileInfo();
    if (inf.isNotEmpty) {
      setState(() {
        lastIndex = (int.tryParse(inf[0].region) ?? 1) - 1;
        locationName = fakeLocations.elementAt((int.tryParse(inf[0].region) ?? 1) - 1);
        _future = Statuses.getAll((int.tryParse(inf[0].region) ?? 1));
        regionId = inf[0].region;
      });
    } else {
      locationName = fakeLocations.elementAt(1);
      _future = Statuses.getAll(1);
      print('sssssssss22222222222222');
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (lastIndex == -1) {
      getRegionId();
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 14,
                right: 12,
                top: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      width: screenWidth(context, 1),
                                      height: screenHeight(context, 0.25),
                                      margin: EdgeInsets.only(
                                        left: 13,
                                        right: screenWidth(context, 0.15),
                                        top: screenHeight(context, 0.12),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color.fromRGBO(238, 236, 249, 1),
                                      ),
                                      child: Scrollbar(
                                        thumbVisibility: true,
                                        child: ListView.builder(
                                          itemCount: fakeLocations.length,
                                          physics: const BouncingScrollPhysics(),
                                          itemBuilder: (ctx, index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                prefs.setInt("statusLocation", index + 1);
                                                setState(() {
                                                  _future = Statuses.getAll(index + 1);
                                                  Navigator.pop(context);
                                                  locationName = fakeLocations[index];
                                                  lastIndex = index;
                                                });
                                              },
                                              child: regionListItem(
                                                context,
                                                fakeLocations[index],
                                                index,
                                                lastIndex,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomTextView(
                          textPaste: locationName,
                          textSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: textColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 2),
                          child: Transform.rotate(
                            angle: 17.2,
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: textColor,
                              size: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<NavigationCubitCubit>(context).getNavBarItem(NavbarItem.profile);
                    },
                    child: FutureBuilder(
                      future: NameSurname.getProfilePic(),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        log(snapshot.data.toString());

                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          if (snapshot.data.toString() == "error") {
                            print('imgerror');
                            return Container(
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
                            );
                          } else {
                            return Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: profileEditImageColor,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    snapshot.data.toString(),
                                  ),
                                ),
                              ),
                            );
                          }
                        } else {
                          return Container(
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
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: messageBubble,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36.0),
                    topRight: Radius.circular(36.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40.0),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: CustomTextView(
                        textPaste: "Təkliflər",
                        textSize: 20,
                        textColor: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 20,
                        ),
                        child: SmartRefresher(
                          controller: _refreshController,
                          onRefresh: () async {
                            await getRegionId();
                            _refreshController.refreshCompleted();
                          },
                          child: FutureBuilder<List<UserInfo>>(
                            future: _future,
                            builder: (BuildContext context, AsyncSnapshot<List<UserInfo>> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.isNotEmpty) {
                                  final userInfo = <UserInfo>[];

                                  userInfo.addAll(snapshot.data!);

                                  return GridView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: userInfo.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.2),
                                    ),
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          final user = userInfo.elementAt(index);

                                          final result = await Statuses.getUserStatuses(user.id);

                                          final userId = user.id;

                                          final _prefs = await SharedPreferences.getInstance();

                                          log('$userId, ${_prefs.getString('user_id')}');

                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => StatusViewScreen(
                                                checkUserStory: userId == _prefs.getString('user_id'),
                                                storyItems: result,
                                                statusUserName: userInfo[index].name,
                                                statusUserImgUrl: userInfo[index].imageX,
                                                userInfo: user,
                                                regionId: regionId,
                                              ),
                                            ),
                                          );
                                        },
                                        child: friendOfferGridItem(snapshot.data![index].imageX, snapshot.data![index].name, snapshot.data![index].business),
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(
                                    child: CustomTextView(
                                      textPaste: 'Hal-hazırda bu region üzrə mövcud təklif yoxdur.',
                                      textSize: 18,
                                      textColor: textColor,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox friendOfferGridItem(String image, String name, String business) {
    int businessElementAt = 0;
    if (int.tryParse(business) != null) {
      if (int.parse(business) > 0 && int.parse(business) <= sampleBiznesModels.length) {
        businessElementAt = int.parse(business) - 1;
      }
    }
    String imageLink = image;
    return SizedBox(
      width: 90,
      height: 170,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                width: 2,
                color: buttonColor,
              ),
            ),
            child: Center(
              //   child: Container(
              //     width: 82,
              //     height: 82,
              //     margin: const EdgeInsets.all(3),
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       image: DecorationImage(
              //         image: NetworkImage(
              //           imageLink,
              //         ),
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //   ),
              child: Container(
                width: 82.0,
                height: 82.0,
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(3.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  imageLink,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, obj, stck) {
                    return Image.asset(
                      'assets/icon.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Flexible(
            child: CustomTextView(
              textPaste: name,
              textSize: 16,
              textColor: textColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomTextView(
            textPaste: sampleBiznesModels.elementAt(businessElementAt),
            textSize: 13,
            textAlign: TextAlign.center,
            textColor: textColor,
            fontWeight: FontWeight.w300,
          ),
        ],
      ),
    );
  }
}
