import 'package:get/get.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';

class EventController extends GetxController {
  var events = <Event>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchEvents();
    super.onInit();
  }

  void fetchEvents() async {
    try {
      isLoading(true);
      var eventList = await ApiService.fetchEvents();
      events.assignAll(eventList);
    } catch (e) {
      Get.snackbar("Error", "Failed to load events");
    } finally {
      isLoading(false);
    }
  }
}
