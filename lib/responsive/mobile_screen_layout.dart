import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pec_chat/utils/colors.dart';
import 'package:pec_chat/utils/global_variable.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    // Animating Page
    pageController.jumpToPage(page);
  }

  Widget _buildTabItem(IconData icon, String label, int index) {
    String iconName = '';
    if (index == 0) {
      iconName = 'Feed';
    } else if (index == 1) {
      iconName = 'Search';
    } else if (index == 2) {
      iconName = 'Post';
    } else if (index == 3) {
      iconName = 'Notification';
    } else if (index == 4) {
      iconName = 'Profile';
    }

    return Padding(
      padding: const EdgeInsets.all(8.0), // Add padding to the icon
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _page == index ? Colors.teal[700] : Colors.grey,
            ),
            padding: const EdgeInsets.all(10), // Adjust the padding here
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          Text(
            iconName,
            style: TextStyle(
              fontSize: 12,
              color: _page == index ? Colors.teal[700] : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: Padding(
      padding: EdgeInsets.all(5), 
      child: SvgPicture.asset(
                'assets/images/pec_chat.svg',
                color: Colors.black,
                height: 400,
                width: 400,
                
              ),
    ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 5; i++)
                  GestureDetector(
                    onTap: () => navigationTapped(i),
                    child: _buildTabItem(
                      i == 0
                          ? Icons.home_filled
                          : i == 1
                              ? Icons.search_sharp
                              : i == 2
                                  ? Icons.add_a_photo
                                  : i == 3
                                      ? Icons.notifications
                                      : Icons.person,
                      homeScreenItems[i].toString(),
                      i,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: homeScreenItems,
            ),
          ),
        ],
      ),
    );
  }
}
