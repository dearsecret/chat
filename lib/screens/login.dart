import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../components/add_image.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoginScreen = false;
  bool showSpinner = false;

  String userName = '';
  String userPassword = '';
  String userEmail = '';

  File? userPickedImage;

  void pickedImage(File image) {
    userPickedImage = image;
  }

  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AddImage(pickedImage);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg.jpeg"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 90, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: isLoginScreen ? "로그인" : "회원가입",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          children: const [
                            TextSpan(
                                text: "하고 혜택을 누려보세요.",
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: MediaQuery.of(context).size.height / 4,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
                margin: const EdgeInsets.all(10),
                height: isLoginScreen
                    ? MediaQuery.of(context).size.height / 4
                    : MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: const Offset(0, 1)),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLoginScreen = true;
                                });
                              },
                              child: Text(
                                "로그인",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isLoginScreen
                                        ? Colors.black
                                        : Colors.black.withOpacity(0.5),
                                    letterSpacing: 1.4,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.amber),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLoginScreen = false;
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "회원가입",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: !isLoginScreen
                                            ? Colors.black
                                            : Colors.black.withOpacity(0.5),
                                        letterSpacing: 1.4,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.amber),
                                  ),
                                  if (!isLoginScreen)
                                    GestureDetector(
                                        onTap: () {
                                          showAlert(context);
                                        },
                                        child: Icon(
                                          Icons.image,
                                          color: !isLoginScreen
                                              ? Colors.cyan
                                              : Colors.grey,
                                        ))
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (isLoginScreen)
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key: const ValueKey(1),
                                    onSaved: (value) {
                                      userEmail = value!;
                                    },
                                    onChanged: (value) {
                                      userEmail = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 4) {
                                        return "이메일을 확인해주세요.";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "이메일",
                                        prefixIcon: Icon(Icons.email),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.indigo),
                                        ),
                                        contentPadding: EdgeInsets.all(5)),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    key: const ValueKey(2),
                                    onSaved: (value) {
                                      userPassword = value!;
                                    },
                                    onChanged: (value) {
                                      userPassword = value;
                                    },
                                    obscureText: true,
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 4) {
                                        return "비밀번호를 확인하세요";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "비밀번호",
                                        prefixIcon: Icon(Icons.lock),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.indigo),
                                        ),
                                        contentPadding: EdgeInsets.all(5)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (!isLoginScreen)
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key: const ValueKey(3),
                                    onSaved: (value) {
                                      userName = value!;
                                    },
                                    onChanged: (value) {
                                      userName = value;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "아이디",
                                        prefixIcon: Icon(Icons.account_circle),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.indigo),
                                        ),
                                        contentPadding: EdgeInsets.all(5)),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    key: const ValueKey(4),
                                    onSaved: (value) {
                                      userPassword = value!;
                                    },
                                    onChanged: (value) {
                                      userPassword = value;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "비밀번호",
                                        prefixIcon: Icon(Icons.lock),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.indigo),
                                        ),
                                        contentPadding: EdgeInsets.all(5)),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    key: const ValueKey(5),
                                    onSaved: (newValue) {
                                      userEmail = newValue!;
                                    },
                                    onChanged: (newValue) {
                                      userEmail = newValue;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "이메일",
                                        prefixIcon: Icon(Icons.email),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.indigo),
                                        ),
                                        contentPadding: EdgeInsets.all(5)),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: isLoginScreen
                  ? MediaQuery.of(context).size.height / 2 - 20
                  : MediaQuery.of(context).size.height * 4 / 7,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 75,
                  width: 75,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 1, spreadRadius: 1, offset: Offset(0, 1))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      showSpinner = true;
                      if (!isLoginScreen) {
                        if (userPickedImage == null) {
                          setState(() {
                            showSpinner = false;
                          });
                          return;
                        }
                        _tryValidation();

                        try {
                          final newUser = await _authentication
                              .createUserWithEmailAndPassword(
                                  email: userEmail, password: userPassword);
                          final refImage = FirebaseStorage.instance
                              .ref()
                              .child("picked_image")
                              .child('${newUser.user!.uid}png');

                          await refImage.putFile(userPickedImage!);
                          final url = await refImage.getDownloadURL();

                          await FirebaseFirestore.instance
                              .collection("user")
                              .doc(newUser.user!.uid)
                              .set({
                            "userName": userName,
                            "email": userEmail,
                            "picked_image": url,
                          });
                          if (newUser.user != null) {
                            if (context.mounted) {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) {
                              //     return const ChatScreen();
                              //   }),
                              // );
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          }
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        _tryValidation();
                        try {
                          final user =
                              await _authentication.signInWithEmailAndPassword(
                                  email: userEmail, password: userPassword);
                          if (user.user != null) {
                            if (context.mounted) {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) {
                              //     return const ChatScreen();
                              //   }),
                              // );
                            }
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        gradient: LinearGradient(
                            colors: [Colors.black, Colors.white],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight),
                      ),
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
