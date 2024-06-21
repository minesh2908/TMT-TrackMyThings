import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:warranty_tracker/modal/user_model.dart';
import 'package:warranty_tracker/repository/user_repository.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';

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
        await AppPrefHelper.setDisplayName(
          displayName: userData.user!.displayName!,
        );
        await AppPrefHelper.setDefaultWarrantyPeriod(
          defaultWarrantyPeriod: '12',
        );
        await AppPrefHelper.setEmail(email: userData.user!.email!);
        await AppPrefHelper.setPhoneNumber(
          phoneNumber: userData.user?.phoneNumber ?? '',
        );
        print('=======================user google signed in');
        return user;
      } else {
        final userData = await UserRepository().getCurrentUserDetails(userId);
        await AppPrefHelper.setDisplayName(
          displayName: userData.name!,
        );

        await AppPrefHelper.setEmail(email: userData.email!);
        await AppPrefHelper.setPhoneNumber(
          phoneNumber: userData.phoneNumber ?? '',
        );
        await AppPrefHelper.setDefaultWarrantyPeriod(
          defaultWarrantyPeriod: userData.defaultWarrantyPeriod!,
        );
        log('-------------------');
        log(AppPrefHelper.getDisplayName());
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
      await AppPrefHelper.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
