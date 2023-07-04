import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: controller.pages,
      ),
      bottomNavigationBar: Obx(
        () => controller.loading.isTrue
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Sedang diproses...")
                  ],
                ),
              )
            : BottomNavigationBar(
                selectedItemColor: Colors.white,
                currentIndex: controller.tabIndex.value,
                onTap: controller.changeTab,
                backgroundColor: Colors.blue,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.medical_information_outlined),
                      label: 'Informasi',
                      backgroundColor: Colors.black),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month),
                      label: 'Jadwal',
                      backgroundColor: Colors.black),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profil',
                      backgroundColor: Colors.black),
                ],
              ),
      ),
    );
  }
}
