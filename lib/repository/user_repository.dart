import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warranty_tracker/modal/user_model.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';

class UserRepository {
  CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection('userCollection');

  Future<UserModel> createUser(User? user) async {
    try {
      await userCollection.doc(AppPrefHelper.getUID()).set({
        'userId': user?.uid,
        'email': user?.email,
        'name': user?.displayName,
        'phoneNumber': user?.phoneNumber,
        'defaultWarrantyPeriod': '12',
      });

      return UserModel(
        userId: user?.uid,
        email: user?.email,
        name: user?.displayName,
        phoneNumber: user?.phoneNumber,
        defaultWarrantyPeriod: '12',
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await userCollection.doc(user.userId).set(user.toMap());
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

      print(
        'From already created user - ${AppPrefHelper.getDefaultWarrantyPeriod()}',
      );
      print(userData.defaultWarrantyPeriod);
      print('---------------');
      print(userData);
      return userData;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await userCollection.doc(userId).delete();

      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}
