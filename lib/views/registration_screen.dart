import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/registration_controller.dart';
import '../models/user_model.dart';

class RegistrationScreen extends StatelessWidget {
  final RegistrationController regController = Get.put(RegistrationController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController teamController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();

  void clearFields() {
    nameController.clear();
    emailController.clear();
    ageController.clear();
    passwordController.clear();
    teamController.clear();
    collegeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.r,
                        spreadRadius: 2.r,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Register for Event",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      buildTextField("Name", nameController),
                      buildTextField("Email", emailController),
                      buildTextField("Age", ageController, keyboardType: TextInputType.number),
                      buildTextField("Password", passwordController, isPassword: true),
                      buildTextField("Team Name", teamController),
                      buildTextField("College Name", collegeController),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: () {
                          regController.registerUser(User(
                            name: nameController.text,
                            email: emailController.text,
                            age: int.tryParse(ageController.text) ?? 0,
                            password: passwordController.text,
                            teamName: teamController.text,
                            collegeName: collegeController.text,
                          ));
                          clearFields();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 32.w),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70, fontSize: 14.sp),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
