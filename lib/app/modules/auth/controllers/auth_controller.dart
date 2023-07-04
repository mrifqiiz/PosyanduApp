import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:posyandu_app/app/collection.dart';
import 'package:posyandu_app/app/data/models/login_model.dart';
import 'package:posyandu_app/app/data/models/user_model.dart';
import 'package:posyandu_app/app/modules/auth/views/auth_view.dart';

class AuthController extends GetxController {
  final posyanduBox = Hive.box('auth');
  LoginModel? profile;
  Rx<bool> loading = false.obs;
  Rx<FormType> formType = FormType.menu.obs;

  Future<void> login(String username, String password) async {
    final data = await MyCollection.users
        .where("username", isEqualTo: username)
        .get() as QuerySnapshot<Map<String, dynamic>>;
    if (data.docs.isEmpty) {
      Get.snackbar('Error', 'Username tidak ada');
    } else if (data.docs.isNotEmpty &&
        data.docs.first.data()["password"] != password) {
      Get.snackbar('Error', 'Password yg anda masukan salah');
    } else {
      final userModel = UserModel.fromJson(data.docs.first.data());
      profile = LoginModel(
        username: username,
        email: userModel.email as String,
        phone: userModel.phone as String,
        user_id: userModel.id as String,
      );
      posyanduBox.put('username', username);
      posyanduBox.put('password', password);
      posyanduBox.put('phone', userModel.phone);
      posyanduBox.put('email', userModel.email);
      posyanduBox.put('user_id', userModel.id);
      Get.offAllNamed('/home', arguments: profile);
    }
  }

  //create register function with hive box username, password, phone number, and email
  Future<void> register(String username, String password, String phoneNumber,
      String email) async {
    final data = await MyCollection.users
        .where("username", isEqualTo: username)
        .get() as QuerySnapshot<Map<String, dynamic>>;
    //if username and password not exist in hive box
    if (data.docs.isEmpty) {
      posyanduBox.put('username', username);
      posyanduBox.put('password', password);
      posyanduBox.put('phone', phoneNumber);
      posyanduBox.put('email', email);
      final dataDoc = MyCollection.users.doc();
      loading = true.obs;
      UserModel userModel = UserModel(
        id: dataDoc.id,
        username: username,
        password: password,
        phone: phoneNumber,
        email: email,
      );
      posyanduBox.put('user_id', userModel.id);
      profile = LoginModel(
        username: username,
        email: userModel.email as String,
        phone: userModel.phone as String,
        user_id: userModel.id as String,
      );

      await dataDoc.set(userModel.toJson());
      Get.snackbar('Success', 'Data berhasil ditambah');

      Get.offAllNamed('/home', arguments: profile);
    } else {
      Get.snackbar('Error', 'Username sudah terdaftar');
    }
  }

  @override
  void onInit() {
    super.onInit();
    openBox();
  }



  void openBox() async {
    await Hive.openBox('posyandu');
  }
}
