import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  final GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();
  TextEditingController unameCtr = TextEditingController();
  TextEditingController phoneCtr = TextEditingController();

  AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(
      child: Obx(
        () {
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
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: controller.formType.value == FormType.menu
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          alignment: Alignment.center,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Image.asset(
                                    'assets/images/posyandu.png',
                                    width: 200,
                                    height: 200,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.formType.value = FormType.login;
                                  },
                                  child: Container(
                                    width: 300,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'LOGIN',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        )
                      : controller.formType == FormType.login
                          ? loginForm()
                          : registerForm());
        },
      ),
    ));
  }

  Form loginForm() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: Image.asset(
            'assets/images/posyandu.png',
            width: 150,
            height: 150,
          ),
        ),
        const Center(
          child: Text('LOGIN',
              style: TextStyle(
                  fontSize: 24, letterSpacing: 2, fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 10),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          controller: unameCtr,
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Please Enter Username'
                : null;
          },
          decoration: inputDecoration('Username', Icons.person),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Please Enter Password'
                : null;
          },
          controller: passwordCtr,
          decoration: inputDecoration('Password', Icons.lock),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState?.validate() ?? false) {
              controller.loading.value = true;
              await controller.login(unameCtr.text, passwordCtr.text);
              controller.loading.value = false;
            }
          },
          child: const Text('Login'),
        ),
        TextButton(
          onPressed: () {
            controller.formType.value = FormType.register;
          },
          child: const Text('Belum punya akun? Daftar disini'),
        ),
      ]),
    );
  }

  Form registerForm() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: Image.asset(
            'assets/images/posyandu.png',
            width: 150,
            height: 150,
          ),
        ),
        const Center(
          child: Text('DAFTAR',
              style: TextStyle(
                  fontSize: 24, letterSpacing: 2, fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 10),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          controller: unameCtr,
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Please Enter Username'
                : null;
          },
          decoration: inputDecoration('Username', Icons.person),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.emailAddress,
          controller: emailCtr,
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Please Enter Email'
                : null;
          },
          decoration: inputDecoration('E-mail', Icons.email),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.phone,
          controller: phoneCtr,
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Please Enter Phone Number'
                : null;
          },
          decoration: inputDecoration('Phone Number', Icons.phone),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Please Enter Password'
                : null;
          },
          controller: passwordCtr,
          decoration: inputDecoration('Password', Icons.lock),
          obscureText: true,
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            return (value == null || value.isEmpty || value != passwordCtr.text)
                ? 'Passwords does not match'
                : null;
          },
          decoration: inputDecoration('Retype Password', Icons.lock),
          obscureText: true,
        ),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState?.validate() ?? false) {
              controller.loading.value = true;
              await controller.register(
                unameCtr.text,
                passwordCtr.text,
                phoneCtr.text,
                emailCtr.text,
              );
              controller.loading.value = false;
            }
          },
          child: const Text('Daftar'),
        ),
        TextButton(
          onPressed: () {
            controller.formType.value = FormType.login;
          },
          child: const Text('Sudah punya akun? Login disini'),
        )
      ]),
    );
  }
}

InputDecoration inputDecoration(String labelText, IconData iconData,
    {String? prefix, String? helperText}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    helperText: helperText,
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.grey),
    fillColor: Colors.white,
    filled: true,
    prefixText: prefix,
    prefixIcon: Icon(
      iconData,
      size: 20,
      color: Colors.black,
    ),
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

enum FormType { login, register, menu }
