import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class RegistrationController extends GetxController {
  var isRegistering = false.obs;

  Future<void> registerUser(User user) async {
    isRegistering(true);
    try {
      bool success = await ApiService.registerUser(user);
      if (success) {
        Get.snackbar("Success", "Registration successful!");
      } else {
        Get.snackbar("Error", "Registration failed!");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong!");
    } finally {
      isRegistering(false);
    }
  }
}
