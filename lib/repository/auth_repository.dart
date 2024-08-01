import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:track_my_things/modal/user_model.dart';
import 'package:track_my_things/repository/user_repository.dart';
import 'package:track_my_things/service/fcm_token.dart';
import 'package:track_my_things/service/shared_prefrence.dart';

class AuthRepository {
  Future<UserModel?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userData =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await AppPrefHelper.setUID(uid: userData.user!.uid);
      final userId = userData.user!.uid;
      if (userData.additionalUserInfo!.isNewUser) {
        final user = await UserRepository().createUser(userData.user);
        final phoneToken = await FCMToken().getDeviceToken();
        log('Phone Token already - $phoneToken');
        await AppPrefHelper.setDisplayName(
          displayName: userData.user!.displayName!,
        );
        await AppPrefHelper.setDefaultWarrantyPeriod(
          defaultWarrantyPeriod: user.defaultWarrantyPeriod!,
        );
        await AppPrefHelper.setEmail(email: userData.user!.email!);
        await AppPrefHelper.setPhoneNumber(
          phoneNumber: userData.user?.phoneNumber ?? '',
        );
        return user;
      } else {
        final phoneToken = await FCMToken().getDeviceToken();
        log('Phone Token - $phoneToken');
        final data = await UserRepository().getCurrentUserDetails(userId);
        await UserRepository().updateUser(data.copyWith(pushToken: phoneToken));

        return UserModel();
      }
    } catch (e) {
      log('SignInFailed $e');
      throw Exception('SignInFailed $e');
    }
  }

  Future<bool> signOutFromGoogle() async {
   
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      await AppPrefHelper.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
