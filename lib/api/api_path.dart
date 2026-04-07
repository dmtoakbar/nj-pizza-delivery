import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiPath {
  static const register = 'auth/register';
  static const login = 'auth/login';
  static const getUser = 'auth/get-user';
  static const updateUser = 'auth/update-user';
  static const deleteUser = 'auth/delete-user';
  static const sentResetPasswordOtp = 'auth/send-reset-password-otp';
  static const verifyOtpAndUpdatePassword = 'auth/verify-reset-password-otp';
  static const products = 'products';
  static const extraToppings = 'extra-toppings';
  static const contactUs = 'contact-us';
  static const reportIssue = 'report-issue';
  static const placeOrder = 'place-order';
  static const orderHistory = 'order-history';
  static const orderDetail = 'order-detail';
  static final baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final medianPath = '$baseUrl/media/';
  static final policyPage = 'policy-pages';
  static final productCategoryList = 'product-category-list';
  static final homeBanners = 'home-banners';
  static final search = 'search';
  static final registerDeviceForNotification = 'register-device-for-notification';
  static final getUnreadCountNotification = 'get-unread-count';
  static final getNotificationList = 'get-notifications';
  static final markNotificationRead = 'mark-notification-read';
  static final addProductReview = 'add-product-review';
  static final getProductReview = 'get-product-review';
  static final getProductRatingSummary = 'get-product-rating-summary';
}
