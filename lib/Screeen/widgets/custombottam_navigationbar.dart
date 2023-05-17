
import 'package:flutter/material.dart';
import 'package:resto_app_ui/Screeen/pages/boobmark.dart';

import 'package:resto_app_ui/Screeen/pages/dashboard.dart';
import 'package:resto_app_ui/Screeen/home_screen.dart';
import 'package:resto_app_ui/Screeen/pages/profile.dart';
import 'package:resto_app_ui/Screeen/pages/vedio.dart';

class CustomBottamNavigationBar extends StatefulWidget {
  const CustomBottamNavigationBar({Key? key}) : super(key: key);

  @override
  State<CustomBottamNavigationBar> createState() => _CustomBottamNavigationBarState();
}

class _CustomBottamNavigationBarState extends State<CustomBottamNavigationBar> {
  final Color baseColor=Colors.red;
  final Color unSelected=Colors.red.withOpacity(0.3);
  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    Dashboard(),
    vedio(),
    Bookmark(),
    Profile()
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeScreen();
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                Dashboard(); // if user taps on this dashboard tab will be active
                            currentTab = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.dashboard,
                              color: currentTab == 0 ? baseColor : unSelected,
                            ),

                          currentTab==0?  Text(
                              'Home',
                              style: TextStyle(fontSize: 15,
                                color: currentTab == 0 ? baseColor : unSelected,
                              ),
                            ):Text('')
                          ],
                        ),
                      ),
                      //SizedBox(width: 30,),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                vedio();// if user taps on this dashboard tab will be active
                            currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.video_library_outlined,
                              color: currentTab == 1 ? baseColor : unSelected,
                            ),
                            currentTab==1?Text(
                              'Vedio',
                              style: TextStyle(
                                color: currentTab == 1 ? baseColor : unSelected,
                              ),
                            ):Text('')
                          ],
                        ),
                      )
                    ],
                  ),

                  // Right Tab bar icons

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                Profile(); // if user taps on this dashboard tab will be active
                            currentTab = 2;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.bookmark,
                              color: currentTab == 2 ? baseColor : unSelected,
                            ),
                            currentTab==2?Text(
                              'Bookmark',
                              style: TextStyle(
                                color: currentTab == 2 ? baseColor : unSelected,
                              ),
                            ):Text('')
                          ],
                        ),
                      ),
                      SizedBox(width: 30,),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                Bookmark(); // if user taps on this dashboard tab will be active
                            currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              color: currentTab == 3 ? baseColor : unSelected,
                            ),
                            currentTab==3?Text(
                              'Profile',
                              style: TextStyle(
                                color: currentTab == 3 ? baseColor : unSelected,
                              ),
                            ):Text('')
                          ],
                        ),
                      )
                    ],
                  )

                ],
              ),
            ),
          ),
        );

  }
}
