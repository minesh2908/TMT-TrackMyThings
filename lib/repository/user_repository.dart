import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warranty_tracker/modal/user_model.dart';
import 'package:warranty_tracker/repository/auth_repository.dart';
import 'package:warranty_tracker/service/notification_service.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';

class UserRepository {
  CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection('userCollection');

  Future<UserModel> createUser(User? user) async {
    try {
      final phoneToken = await NotificationService().getDeviceToken();
      //print('Phone Token - $phoneToken');
      await userCollection.doc(AppPrefHelper.getUID()).set({
        'userId': user?.uid,
        'email': user?.email,
        'name': user?.displayName,
        'phoneNumber': user?.phoneNumber,
        'defaultWarrantyPeriod': '12',
        'pushToken': phoneToken,
        'sortItemBy': 'Warranty end date',
      });

      return UserModel(
        userId: user?.uid,
        email: user?.email,
        name: user?.displayName,
        phoneNumber: user?.phoneNumber,
        defaultWarrantyPeriod: '12',
        pushToken: phoneToken,
        sortItemBy: 'Warranty end date',
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      // print('update user called');
      await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(user.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserModel> getCurrentUserDetails(String userId) async {
    try {
      final userSnapshot =
          await userCollection.where('userId', isEqualTo: userId).get();
      final userData = userSnapshot.docs.map(UserModel.fromSnapshot).first;

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
      return userData;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteUser(String userId) async {
    //print('Delete User');
    try {
      await userCollection.doc(userId).delete();

      await FirebaseAuth.instance.currentUser!.delete();

      await AuthRepository().signOutFromGoogle();
    } catch (e) {
      throw Exception(e);
    }
  }
}
