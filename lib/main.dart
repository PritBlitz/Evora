import 'package:eventforge/views/add_event_screen.dart';
import 'package:eventforge/views/event_screen.dart';
import 'package:eventforge/views/profile_screen.dart';
import 'package:eventforge/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eventforge/views/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Event App',
          theme: ThemeData.dark(),
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    EventScreen(),
    const SearchScreen(),
    const AddEventScreen(),
    const ProfileScreen(),
    const ChatScreen(), // Added chatbot screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.blueGrey,
        buttonBackgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        height: 60.h,
        index: _selectedIndex,
        items: [
          Icon(Icons.home, size: 30.sp, color: Colors.black),
          Icon(Icons.search, size: 30.sp, color: Colors.black),
          Icon(Icons.add, size: 30.sp, color: Colors.black),
          Icon(Icons.person, size: 30.sp, color: Colors.black),
          Icon(Icons.chat, size: 30.sp, color: Colors.black), // Chat icon
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
