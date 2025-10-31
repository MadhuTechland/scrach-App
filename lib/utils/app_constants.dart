
class AppConstants {
  static const String appName = 'Nudeal';
  static const String appVersion = '1.0';
  static const String baseUrl = 'https://mydeal.nr12brandsshop.in/public';
  static const String registerUri = '/api/register';
  static const String registerUserUri = '/api/register-mobile';
  static const String requestOtp = '/api/request-otp';
  static const String loginUri = '/api/login';
  static const String loginOut = '/api/logout';
  static const String verifyEmail = '/api/verifyEmail';
  static const String profileUpdate = '/api/ProfileUpdate';
  static const String fetchNotifications = '/api/fetchNotifications';
  static const String verifyOTP = '/api/verifyOTP1';
  static const String updateFCMToken = '/api/updateFcmToken';
  static const String updatePassword = '/api/updatepassword';
  static const String resetPassword = '/api/resetPassword';
  static const String forgotPassOTP ='/api/forgotPassOTP';
  static const String getPromos = '/api/getpromos';
  static const String getScratchedUsers = '/api/getScratchedUsers';
  static const String getUnscratchedUsers = '/api/getUnscratchedUsers';
  static const String promotions = '/api/promotions';
  static const String scratchCards = '/api/user/{userId}/scratch-cards';
  static const String updateProfileUri = '/api/user/update-profile';
  static const String uploadPromotionsUrl = "/api/upload-promotions";
  static const String sliderCount = "/api/slider-count";
  static const String deleteUser = "/api/delete-user/";
  static const String createCards = "api/scratchcards/create-assign/";

  
  static String get updateProfileUrl => baseUrl + updateProfileUri;

}