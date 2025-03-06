import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/event_controller.dart';
import 'event_detail_screen.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final EventController eventController = Get.put(EventController());
  String selectedCategory = "All";
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Explore Events',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 6,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Navigate to notifications screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            ),
            _buildCategoryFilters(),
            Obx(() {
              if (eventController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              final filteredEvents = eventController.events.where((event) {
                return (selectedCategory == "All" || event.eventType == selectedCategory) &&
                    event.eventName.toLowerCase().contains(searchController.text.toLowerCase());
              }).toList();

              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: filteredEvents.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  return _eventCard(event);
                },
              );
            }),
            SizedBox(height: 100.h), // Added space at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    List<String> categories = ["All", "Hackathon", "Coding", "Workshop", "Webinar"];
    return SizedBox(
      height: 50.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = categories[index];
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: selectedCategory == categories[index] ? Colors.blueAccent : Colors.grey[900],
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _eventCard(event) {
    return GestureDetector(
      onTap: () {
        Get.to(() => EventDetailScreen(event: event));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: Colors.grey[900]?.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.2),
              blurRadius: 10.r,
              spreadRadius: 2.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              child: Image.memory(
                base64Decode(event.poster),
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventName,
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _eventDetail(Icons.calendar_today, "Date", event.eventDate),
                  _eventDetail(Icons.access_time, "Duration", event.duration),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventDetail(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 20.sp),
        SizedBox(width: 8.w),
        Text(
          "$label: ",
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
