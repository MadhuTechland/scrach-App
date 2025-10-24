import 'package:get/get.dart';
import 'package:scratch_app/app/home/home_controller.dart';
import 'package:scratch_app/app/profile/edit_profile_controller.dart';
import 'package:scratch_app/app/scratched/scratch_card_controller.dart';
import 'package:scratch_app/data/provider/api_client.dart';
import 'package:scratch_app/data/repository/scratch_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scratch_app/utils/app_constants.dart';
import 'package:scratch_app/data/repository/auth_repo.dart';
import 'package:scratch_app/auth/controller/auth_controller.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  Get.lazyPut(() => ApiClient(
        appBaseUrl: AppConstants.baseUrl,
        sharedPreferences: Get.find(),
      ));

  Get.lazyPut(() => AuthRepo(apiClient: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => PromotionController(apiClient: Get.find()));
  Get.put(ScratchCardRepo(apiClient: Get.find()));
  Get.put(ScratchCardController(scratchCardRepo: Get.find()));
  Get.lazyPut(() => EditProfileController(Get.find<AuthRepo>()));

}
