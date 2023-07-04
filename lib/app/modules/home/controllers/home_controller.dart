import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_app/app/collection.dart';
import 'package:posyandu_app/app/data/models/login_model.dart';
import 'package:posyandu_app/app/data/models/profil_model.dart';
import 'package:posyandu_app/app/data/models/profile_model.dart';
import 'package:posyandu_app/app/modules/home/views/informasi_view.dart';
import 'package:posyandu_app/app/modules/home/views/jadwal_view.dart';
import 'package:posyandu_app/app/modules/home/views/profil_view.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //TODO: Implement HomeController

  final posyanduBox = Hive.box('posyandu');
  final profilBox = Hive.box('profil');
  final auth = Hive.box('auth');
  Rx<bool> loading = false.obs;
  // final LoginModel loginUser = Get.arguments;
  final LoginModel loginUser = LoginModel(
    username: Hive.box('auth').get('username'),
    email: Hive.box('auth').get('email'),
    phone: Hive.box('auth').get('phone'),
    user_id: Hive.box('auth').get('user_id'),
  );
  List<dynamic> listJadwal = Hive.box('posyandu').values.toList();
  List<dynamic> listKey = Hive.box('posyandu').keys.toList();

  TextEditingController jadwalController = TextEditingController();

  TextEditingController namaCtr = TextEditingController();
  TextEditingController tglLahirCtr = TextEditingController();
  TextEditingController golDarahCtr = TextEditingController();
  TextEditingController tbCtr = TextEditingController();
  TextEditingController bbCtr = TextEditingController();
  TextEditingController tglMenikahCtr = TextEditingController();

  final ProfileModel profilUser = ProfileModel();
  final RxInt tabIndex = 0.obs;
  late TabController tabController;

  final List<Widget> pages = [
    const InformasiView(),
    const JadwalPosyanduView(),
    ProfilView()
  ];

  void changeTab(int index) {
    tabIndex.value = index;
    tabController.animateTo(index);
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: pages.length, vsync: this);
    loadProfile();
  }

  @override
  void onReady() {
    super.onReady();
    notifService();
  }


  void tambahJadwal(String tanggal) {
    posyanduBox.put(tanggal, jadwalController.text);
  }

  void hapusJadwal(String tanggal) {
    posyanduBox.delete(tanggal);
  }

  //save profil
  Future<void> saveProfil(String nama, String tglLahir, String golDarah,
      String tb, String bb, String tglMenikah) async {
    final data = await MyCollection.profile
        .where("user_id", isEqualTo: auth.get('user_id'))
        .get() as QuerySnapshot<Map<String, dynamic>>;
    if (data.docs.isEmpty) {
      final dataDoc = MyCollection.profile.doc();
      await dataDoc.set({
        'id': dataDoc.id,
        'nama': nama,
        'tglLahir': tglLahir,
        'golDarah': golDarah,
        'tb': tb,
        'bb': bb,
        'tglMenikah': tglMenikah,
        'user_id': loginUser.user_id,
      });
      profilBox.put('nama', nama);
      profilBox.put('tglLahir', tglLahir);
      profilBox.put('golDarah', golDarah);
      profilBox.put('tb', tb);
      profilBox.put('bb', bb);
      profilBox.put('tglMenikah', tglMenikah);
    } else {
      await MyCollection.profile.doc(data.docs.first.data()["id"]).update(
        {
          'nama': nama,
          'tglLahir': tglLahir,
          'golDarah': golDarah,
          'tb': tb,
          'bb': bb,
          'tglMenikah': tglMenikah,
          'user_id': loginUser.user_id,
        },
      );
    }
  }

  void loadProfile() async {
    loading.value = true;
    final data = await MyCollection.profile
        .where("user_id", isEqualTo: auth.get('user_id'))
        .get() as QuerySnapshot<Map<String, dynamic>>;

    if (data.docs.isEmpty) {
      namaCtr.text = '';
      tglLahirCtr.text = '';
      golDarahCtr.text = '';
      tbCtr.text = '';
      bbCtr.text = '';
      tglMenikahCtr.text = '';
    } else {
      // print(data.docs.first.data());
      ProfileDbModel profileDbModel =
          ProfileDbModel.fromJson(data.docs.first.data());

      namaCtr.text = profileDbModel.nama;
      tglLahirCtr.text = profileDbModel.tglLahir;
      golDarahCtr.text = profileDbModel.golDarah;
      tbCtr.text = profileDbModel.tb;
      bbCtr.text = profileDbModel.bb;
      tglMenikahCtr.text = profileDbModel.tglMenikah;
    }
    loading.value = false;
  }

  void logout() {
    Hive.box('auth').clear();
    profilBox.clear();
    Get.offAllNamed('/auth');
  }

  void notifService() {
    if (listKey.isNotEmpty) {
      for (var i = 0; i < listKey.length; i++) {
        if (DateFormat.yMMMd().format(DateTime.parse(listKey[i])).toString() ==
                DateFormat.yMMMd()
                    .format(DateTime.parse(DateTime.now().toString()))
                    .toString() &&
            DateFormat.yMMMd().format(DateTime.parse(listKey[i])).toString() ==
                DateFormat.yMMMd()
                    .format(DateTime.parse(
                        DateTime.now().add(const Duration(days: 1)).toString()))
                    .toString()) {
          notifHariInidanBesok();
          print('har ini dan besok');
        }
        if (DateFormat.yMMMd().format(DateTime.parse(listKey[i])).toString() ==
            DateFormat.yMMMd()
                .format(DateTime.parse(DateTime.now().toString()))
                .toString()) {
          notifHariIni();
          print('harini');
        } else if (DateFormat.yMMMd()
                .format(DateTime.parse(listKey[i]))
                .toString() ==
            DateFormat.yMMMd()
                .format(DateTime.parse(
                    DateTime.now().add(const Duration(days: 1)).toString()))
                .toString()) {
          notifBesok();
          print('besok');
        }
      }
    }
  }

  notifBesok() {
    Get.snackbar('Notifikasi', 'Anda memiliki jadwal posyandu besok');
  }

  void notifHariIni() {
    Get.snackbar('Notifikasi', 'Anda memiliki jadwal posyandu Hari ini');
  }

  void notifHariInidanBesok() {
    Get.snackbar(
        'Notifikasi', 'Anda memiliki jadwal posyandu Hari ini dan Besok');
  }
}
