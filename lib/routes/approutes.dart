import 'package:flavour_finder/views/buyer/chatbot_screen.dart';
import 'package:flavour_finder/views/detection/detection_screen.dart';
import 'package:flavour_finder/views/detection/recipe_detection.dart';
import 'package:flavour_finder/views/buyer/user_orders.dart';
import 'package:flavour_finder/views/detection/weather_detection.dart';
import 'package:get/get.dart';

import '../views/auth/forget_password_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/buyer/cart_view_screen.dart';
import '../views/buyer/checkout_screen.dart';
import '../views/buyer/user_dashboard.dart';
import '../views/buyer/user_home_screen.dart';
import '../views/buyer/user_settings_screen.dart';
import '../views/seller/add_recipe.dart';
import '../views/seller/edit_recipe.dart';
import '../views/seller/vendor_dashboard.dart';
import '../widgets/loading_widget.dart';

appRoutes() => [
      GetPage(
        name: '/login',
        page: () => const LoginScreen(),
      ),
      GetPage(
        name: '/register',
        page: () => const RegisterScreen(),
      ),
      GetPage(
        name: '/forgetPassword',
        page: () => const ForgetPasswordScreen(),
      ),
      GetPage(
        name: '/userDashboard',
        page: () => const UserDashboard(),
      ),
      GetPage(
        name: '/vendorDashboard',
        page: () => const VendorDashboard(),
      ),
      GetPage(
        name: '/loading',
        page: () => const LoadingScreen(),
      ),
      GetPage(
        name: '/addProduct',
        page: () => const AddProductScreen(),
      ),
      GetPage(
        name: '/editProduct',
        page: () => const EditProductScreen(),
      ),
      GetPage(
        name: '/userHome',
        page: () => const UserHomeScreen(),
      ),
      GetPage(
        name: '/userSettings',
        page: () => const UserSettingScreen(),
      ),
      GetPage(
        name: '/myCart',
        page: () => const CartViewScreen(),
      ),
      GetPage(
        name: '/checkout',
        page: () => const CheckoutScreen(),
      ),
      GetPage(
        name: '/userOrders',
        page: () => const UserOrders(),
      ),
      GetPage(
        name: '/detection',
        page: () => const DetectionScreen(),
      ),
      GetPage(
        name: '/recipeDetection',
        page: () => const RecipeDetection(),
      ),
      GetPage(
        name: '/weatherDetection',
        page: () => const WeatherDetection(),
      ),
      GetPage(
        name: '/chatBot',
        page: () => const ChatScreen(),
      ),
    ];
