import 'package:flutter/material.dart';
import 'package:track_my_things/modal/product_modal.dart';
import 'package:track_my_things/routes/routes_names.dart';
import 'package:track_my_things/views/screens/language/select_language.dart';
import 'package:track_my_things/views/screens/about_me/about_me.dart';
import 'package:track_my_things/views/screens/add_product/add_product.dart';
import 'package:track_my_things/views/screens/auth/screens/account.dart';
import 'package:track_my_things/views/screens/auth/screens/google_sign_in.dart';
import 'package:track_my_things/views/screens/dashboard.dart';
import 'package:track_my_things/views/screens/full_image/full_image.dart';
import 'package:track_my_things/views/screens/product_details/product_details.dart';
import 'package:track_my_things/views/screens/settings/general_settings.dart';
import 'package:track_my_things/views/screens/splash_screen/splash_screen.dart';
import 'package:track_my_things/views/screens/update_product/update_product.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case RoutesName.dashboard:
        return MaterialPageRoute(
          builder: (context) {
            return const MyDashboard();
          },
        );
      case RoutesName.authScreen:
        return MaterialPageRoute(
          builder: (context) {
            return const GoogleSignIn();
          },
        );
      case RoutesName.addProduct:
        return MaterialPageRoute(
          builder: (context) {
            return const AddProduct();
          },
        );
      case RoutesName.updateProduct:
        final productModal = setting.arguments! as ProductModal;
        return MaterialPageRoute(
          builder: (context) {
            return UpdateProduct(
              productModal: productModal,
            );
          },
        );
      case RoutesName.productDetails:
        final productModal = setting.arguments! as ProductModal;
        return MaterialPageRoute(builder: (context) {
          return ProductDetails(productModal: productModal);
        });
      case RoutesName.fullImage:
        final imageUrl = setting.arguments! as String;
        return MaterialPageRoute(
          builder: (context) {
            return FullImage(
              imageUrl: imageUrl,
            );
          },
        );

      case RoutesName.splashScreen:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          },
        );
      case RoutesName.accountDetails:
        return MaterialPageRoute(
          builder: (context) {
            return const AccountDetails();
          },
        );
      case RoutesName.selectLanguage:
        return MaterialPageRoute(
          builder: (context) {
            return const SelectLanguage();
          },
        );
      case RoutesName.settings:
        return MaterialPageRoute(
          builder: (context) {
            return const GeneralSettings();
          },
        );
      case RoutesName.aboutMe:
        return MaterialPageRoute(
          builder: (context) {
            return const AboutMe();
          },
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: Text('Something went wrong'),
              ),
            );
          },
        );
    }
  }
}
