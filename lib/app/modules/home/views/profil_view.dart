import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_app/app/constant.dart';
import 'package:posyandu_app/app/modules/home/controllers/home_controller.dart';

class ProfilView extends GetView<HomeController> {
  ProfilView({super.key});
  final GlobalKey<FormState> formKey = GlobalKey();

  //if in box already have data, then use it
  //if not, then use default value

  @override
  Widget build(BuildContext context) {
    return controller.loading.isTrue
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
        : ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Profil',
                      style: headingStyle,
                    ),
                  ),
                  Container(
                    child: Image.asset('assets/images/ibu.png',
                        width: 100, height: 100),
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: TextFormField(
                            controller: controller.namaCtr,
                            decoration: inputDecoration('Masukkan Nama'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () => showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100))
                                      .then((value) {
                                    // print(DateFormat.yMMMd().format(value!).toString());
                                    controller.tglLahirCtr.text =
                                        DateFormat.yMMMd()
                                            .format(value!)
                                            .toString();
                                  }),
                                  child: const Text('Pilih Tanggal Lahir'),
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  controller: controller.tglLahirCtr,
                                  readOnly: true,
                                  decoration: inputDecoration('Tanggal Lahir'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: TextFormField(
                            controller: controller.golDarahCtr,
                            decoration:
                                inputDecoration('Masukkan Golongan Darah'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: TextFormField(
                            controller: controller.tbCtr,
                            keyboardType: TextInputType.number,
                            decoration:
                                inputDecoration('Masukkan Tinggi Badan'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: TextFormField(
                            controller: controller.bbCtr,
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration('Masukkan Berat Badan'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () => showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100))
                                      .then((value) {
                                    controller.tglMenikahCtr.text =
                                        DateFormat.yMMMd()
                                            .format(value!)
                                            .toString();
                                  }),
                                  child: const Text('Pilih Tanggal Menikah'),
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  controller: controller.tglMenikahCtr,
                                  readOnly: true,
                                  decoration:
                                      inputDecoration('Tanggal Menikah'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            Container(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    controller.loading.value = true;
                                    await controller.saveProfil(
                                        controller.namaCtr.text,
                                        controller.tglLahirCtr.text,
                                        controller.golDarahCtr.text,
                                        controller.tbCtr.text,
                                        controller.bbCtr.text,
                                        controller.tglMenikahCtr.text);

                                    controller.loading.value = false;
                                    Get.snackbar(
                                        'Success', 'Data berhasil dirubah');
                                  } else {
                                    Get.snackbar('Error', 'Data tidak valid');
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.green)),
                                child: const Text('Simpan Data'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 24),
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.logout();
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                child: const Text('Log Out'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ]),
              ),
            ],
          );
  }
}

InputDecoration inputDecoration(String labelText,
    {String? prefix, String? helperText}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    helperText: helperText,
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.grey),
    fillColor: Colors.white,
    filled: true,
    prefixText: prefix,
    prefixIconConstraints: const BoxConstraints(minWidth: 60),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black)),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black)),
  );
}
