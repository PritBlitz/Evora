import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'registration_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final dynamic event;

  EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          event.eventName,
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.memory(
                base64Decode(event.poster),
                width: double.infinity,
                height: 220.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.h),
            buildInfoCard([
              detailRow(Icons.calendar_today, "Date", event.eventDate),
              detailRow(Icons.access_time, "Duration", event.duration),
              detailRow(Icons.people, "Team Size", event.teamSize.toString()),
              detailRow(Icons.work_outline, "Internship", event.internship ? 'Yes' : 'No'),
            ]),
            SizedBox(height: 16.h),
            buildSectionTitle("🏆 Prizes"),
            buildPrizesCard(event),

            SizedBox(height: 16.h),
            buildSectionTitle("📄 Description"),
            buildDescriptionCard(event.description),
            SizedBox(height: 24.h),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => RegistrationScreen());
                },
                icon: Icon(Icons.app_registration, color: Colors.white, size: 20.sp),
                label: Text(
                  "Register Now",
                  style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 14.h),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailRow(IconData icon, String label, String value) {
    final Map<IconData, Color> iconColors = {
      Icons.calendar_today: Colors.orangeAccent,
      Icons.access_time: Colors.blueAccent,
      Icons.people: Colors.greenAccent,
      Icons.work_outline: Colors.redAccent,
      Icons.emoji_events: Colors.amber,
    };

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(icon, color: iconColors[icon] ?? Colors.deepPurpleAccent, size: 22.sp),
          SizedBox(width: 10.w),
          Text(
            "$label: ",
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget buildInfoCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(children: children),
    );
  }

  Widget buildDescriptionCard(String description) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        description,
        style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.white),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildPrizesCard(dynamic event) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prizeRow("🥇 1st Prize", event.rank1Prize),
          SizedBox(height: 8.h),
          prizeRow("🥈 2nd Prize", event.rank2Prize),
          SizedBox(height: 8.h),
          prizeRow("🥉 3rd Prize", event.rank3Prize),
        ],
      ),
    );
  }

  Widget prizeRow(String title, String prize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.emoji_events, color: Colors.amber, size: 22.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                prize,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
