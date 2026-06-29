import 'package:field_track_todo/core/local_service/shared_preference_helper.dart';
import 'package:field_track_todo/routes/app_routes.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final name = 'John Doe'.obs;
  final email = 'john.doe@example.com'.obs;
  final initials = 'JD'.obs;
  final role = 'Field User'.obs;

  final tasksDoneToday = '1/5'.obs;
  final activeLocationsCount = 3.obs;

  Future<void> signOut() async {
    await SharedPreferencesHelper.clearAll();
    Get.offAllNamed(AppRoutes.login);
  }
}
