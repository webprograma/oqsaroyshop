import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/additional/member_model.dart';
import 'package:instaclone/main.dart';
import 'package:instaclone/pages/vital_pages/customer_profile_page.dart';
import 'package:instaclone/pages/vital_pages/myfavouritePage.dart';
import 'package:instaclone/pages/vital_pages/mymainpage.dart';
import 'package:instaclone/pages/vital_pages/myprofilepage.dart';
import 'package:instaclone/pages/vital_pages/mysearchpage.dart';
import 'package:instaclone/pages/vital_pages/upload_page.dart';
import 'package:instaclone/servise/dbs_service.dart';

class HomePage extends StatefulWidget {
  static final String id = 'msow';
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? pageController;
  int _currentTap = 0;
  bool _isLoading = true;
  bool isCustomer = true;
  bool _disposed = false; // Add this variable

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _apiLoadMember();
  }

  @override
  void dispose() {
    _disposed = true; // Set disposed to true when disposing the widget
    super.dispose();
  }

  _apiLoadMember() {
    DBService.loadMember().then((value) {
      if (!_disposed) {
        // Check if widget is disposed before updating state
        showMemberInfo(value);
      }
    });
  }

  showMemberInfo(Member member) {
    if (!_disposed && mounted) {
      // Check if widget is disposed and mounted
      setState(() {
        _isLoading = false;
        isCustomer = member.isCustomer;
        if (member.isCustomer == false) {
          print('user is vendor');
        } else {
          print('user is customer');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          MyMainPage(),
          isCustomer == false
              ? UploadPage(
                  pageController: pageController,
                )
              : MySearchPage(),
          isCustomer == false ? MyProfilePage() : CustomerProfilePage(),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTap = index;
          });
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (int index) {
          setState(() {
            _currentTap = index;
            pageController!.animateToPage(index,
                duration: Duration(microseconds: 500), curve: Curves.easeIn);
          });
        },
        index: _currentTap,
        letIndexChange: (value) => true,
        animationDuration: Duration(milliseconds: 500),
        backgroundColor: Colors.transparent,
        color: Colors.blue,
        items: isCustomer == false ? saler : customer,
      ),
    );
  }

  List<CurvedNavigationBarItem> saler = [
    CurvedNavigationBarItem(
      child: Icon(
        Icons.home,
        size: 32,
        color: Colors.white,
      ),
    ),
    CurvedNavigationBarItem(
      child: Icon(
        Icons.add,
        size: 32,
        color: Colors.white,
      ),
    ),
    CurvedNavigationBarItem(
      child: Icon(
        Icons.account_circle_outlined,
        size: 32,
        color: Colors.white,
      ),
    ),
  ];
  List<CurvedNavigationBarItem> customer = [
    CurvedNavigationBarItem(
      child: Icon(
        Icons.home,
        size: 32,
        color: Colors.white,
      ),
    ),
    CurvedNavigationBarItem(
      child: Icon(
        Icons.search,
        size: 32,
        color: Colors.white,
      ),
    ),
    CurvedNavigationBarItem(
      child: Icon(
        Icons.account_circle_outlined,
        size: 32,
        color: Colors.white,
      ),
    ),
  ];
}
