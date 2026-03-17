import 'package:get/get.dart';
import 'package:nj_pizza_delivery/app/auth/bindings/forget_password_controller_binding.dart';
import 'package:nj_pizza_delivery/app/auth/bindings/login_controller_binding.dart';
import 'package:nj_pizza_delivery/app/auth/bindings/registration_controller_binding.dart';
import 'package:nj_pizza_delivery/app/auth/forget_password.dart';
import 'package:nj_pizza_delivery/app/auth/login.dart';
import 'package:nj_pizza_delivery/app/auth/registration.dart';
import 'package:nj_pizza_delivery/app/auth/verify_opt_and_update_password.dart';
import 'package:nj_pizza_delivery/app/home/aboutMenu/about_menu.dart';
import 'package:nj_pizza_delivery/app/home/aboutMenu/binding/about_menu_controller_binding.dart';
import 'package:nj_pizza_delivery/app/home/aboutUs/about_us.dart';
import 'package:nj_pizza_delivery/app/home/aboutUs/bindings/about_us_controller_bindings.dart';
import 'package:nj_pizza_delivery/app/home/allCategoryProducts/all_category_products.dart';
import 'package:nj_pizza_delivery/app/home/allCategoryProducts/binding/all_category_products_controller_binding.dart';
import 'package:nj_pizza_delivery/app/home/cart/cart.dart';
import 'package:nj_pizza_delivery/app/home/contactUs/binding/contact_us_controller_binding.dart';
import 'package:nj_pizza_delivery/app/home/contactUs/contact_us.dart';
import 'package:nj_pizza_delivery/app/home/home/binding/home_controller_binding.dart';
import 'package:nj_pizza_delivery/app/home/home/home_view.dart';
import 'package:nj_pizza_delivery/app/home/myFavourite/my_favourite.dart';
import 'package:nj_pizza_delivery/app/home/orders/bindings/order_controller_binding.dart';
import 'package:nj_pizza_delivery/app/home/orders/orderDetail/order_detail_view.dart';
import 'package:nj_pizza_delivery/app/home/orders/orders_view.dart';
import 'package:nj_pizza_delivery/app/home/placeOrder/place_order_view.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/FAQ/bindings/faq_policy_controller_bindings.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/FAQ/faq_policy.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/cancellationPolicy/bindings/cancellation_policy_controller_bindings.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/cancellationPolicy/cancellation_policy.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/privacyPolicy/bindings/privacy_policy_controller_bindings.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/privacyPolicy/privacy_policy.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/refundPolicy/bindings/refund_policy_controller_bindings.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/shippingPolicy/bindings/shipping_policy_controller_bindings.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/shippingPolicy/shipping_policy.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/termsAndCondition/bindings/terms_condition_policy_controller_bindings.dart';
import 'package:nj_pizza_delivery/app/home/policyPages/termsAndCondition/terms_condition_policy.dart';
import 'package:nj_pizza_delivery/app/home/profile/profile.dart';
import 'package:nj_pizza_delivery/app/home/report/binding/report_controller_binding.dart';
import 'package:nj_pizza_delivery/app/home/report/report.dart';
import 'package:nj_pizza_delivery/app/home/specifyCategoryProducts/binding/specific_category_products_controller_binding.dart';
import 'package:nj_pizza_delivery/app/home/specifyCategoryProducts/specific_category_products.dart';
import 'package:nj_pizza_delivery/app/onboard/binding/onboard_controller_binding.dart';
import 'package:nj_pizza_delivery/app/onboard/onboard_view.dart';
import 'package:nj_pizza_delivery/app/splash/binding/splash_controller_binding.dart';
import 'package:nj_pizza_delivery/app/splash/splash.dart';
import '../app/auth/bindings/reset_password_binding.dart';
import '../app/home/policyPages/refundPolicy/refund_policy.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
      binding: SplashControllerBinding(),
    ),
    GetPage(
      name: Routes.ONBOARD,
      page: () => OnboardingView(),
      binding: OnboardControllerBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => PizzaLoginScreen(),
      binding: LoginControllerBinding(),
    ),
    GetPage(
      name: Routes.REGISTRATION,
      page: () => PizzaRegistrationScreen(),
      binding: RegistrationControllerBinding(),
    ),
    GetPage(
      name: Routes.FORGETPASSWORD,
      page: () => ForgetPasswordScreen(),
      binding: ForgetPasswordControllerBinding(),
    ),
    GetPage(
      name: Routes.RESETPASSWORD,
      page: () => ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.MYFAVORITE,
      page: () => FavoritesScreen(),
    ),
    GetPage(name: Routes.PROFILE, page: () => ProfileScreen()),
    GetPage(name: Routes.CART, page: () => CartScreen()),
    GetPage(name: Routes.PLACEORDER, page: () => PlaceOrderView()),
    GetPage(
      name: Routes.ORDERS,
      page: () => OrdersView(),
      binding: OrderControllerBinding(),
    ),
    GetPage(name: Routes.ORDERDETAIL, page: () => OrderDetailsPage()),
    GetPage(
      name: Routes.CONTACTUS,
      page: () => ContactUsScreen(),
      binding: ContactUsControllerBinding(),
    ),
    GetPage(
      name: Routes.REPORT,
      page: () => ReportScreen(),
      binding: ReportControllerBinding(),
    ),
    GetPage(
      name: Routes.REFUNDPOLICY,
      page: () => RefundPolicyPage(),
      binding: RefundPolicyControllerBindings(),
    ),
    GetPage(
      name: Routes.ABOUT_US,
      page: () => AboutUsPage(),
      binding: AboutUsControllerBindings(),
    ),
    GetPage(
      name: Routes.CANCELLATION_POLICY,
      page: () => CancellationPolicyPage(),
      binding: CancellationPolicyControllerBindings(),
    ),
    GetPage(
      name: Routes.FAQ,
      page: () => FAQPolicyPage(),
      binding: FAQPolicyControllerBindings(),
    ),
    GetPage(
      name: Routes.PRIVACY_POLICY,
      page: () => PrivacyPolicyPage(),
      binding: PrivacyPolicyControllerBindings(),
    ),
    GetPage(
      name: Routes.TERMS,
      page: () => TermsConditionPolicyPage(),
      binding: TermsConditionPolicyControllerBindings(),
    ),
    GetPage(
      name: Routes.SHIPPING_POLICY,
      page: () => ShippingPolicyPage(),
      binding: ShippingPolicyControllerBindings(),
    ),

    // new
    GetPage(
      name: Routes.ABOUTMENU,
      page: () => AboutMenuScreen(),
      binding: AboutMenuControllerBinding(),
    ),

    GetPage(
      name: Routes.SPECIFICATPRODUCTS,
      page: () => SpecificCategoryProductsScreen(),
      binding: SpecificCategoryProductsControllerBinding(),
    ),

    GetPage(
      name: Routes.ALLCATPRODUCTS,
      page: () => AllCategoryProductsScreen(),
      binding: AllCategoryProductsControllerBinding(),
    ),
  ];
}
