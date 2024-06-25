import 'package:flavour_finder/views/buyer/user_orders.dart';
import 'package:get/get.dart';

import '../views/auth/forget_password_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/buyer/cart_view_screen.dart';
import '../views/buyer/checkout_screen.dart';
import '../views/buyer/paint_wall_screen.dart';
import '../views/buyer/take_picture_screen.dart';
import '../views/buyer/user_dashboard.dart';
import '../views/buyer/user_home_screen.dart';
import '../views/buyer/user_settings_screen.dart';
import '../views/buyer/view_item_detail.dart';
import '../views/seller/add_product.dart';
import '../views/seller/edit_product.dart';
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
        name: '/takePicture',
        page: () => const TakePictures(),
      ),
      GetPage(
        name: '/paintWall',
        page: () => const PaintWallScreen(),
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
        name: '/viewDetail',
        page: () => const ViewItemDetail(),
      ),
      GetPage(
        name: '/userOrders',
        page: () => const UserOrders(),
      ),
    ];
