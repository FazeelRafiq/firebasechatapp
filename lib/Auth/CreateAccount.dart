import 'package:chatapp/Auth/Login.dart';
import 'package:chatapp/Models/UserModel.dart';
import 'package:chatapp/Models/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../Models/ImagePicker.dart';
import 'Methods.dart';
import 'dart:io';

class CreateAccount extends StatefulWidget {
  final UserModel? userModel;

  const CreateAccount({Key? key, this.userModel}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  File? _selectedImage;
  final RegExp _emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  final RegExp passRegExp = RegExp(
      r'(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$');

  final maskFormatter = new MaskTextInputFormatter(filter: {
    "#": RegExp(
        r'(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$')
  }, type: MaskAutoCompletionType.lazy);

  bool _isEmailValid = false;
  bool _isPassValid = false;

  void _validateEmail(String email) {
    setState(() {
      _isEmailValid = _emailRegExp.hasMatch(email);
    });
  }

  void _validPass(String pass) {
    setState(() {
      _isPassValid = passRegExp.hasMatch(pass);
    });
  }

  bool _passwordVisible = true;

  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: isLoading
            ? Center(
          child: Container(
            height: size.height / 20,
            width: size.height / 20,
            child: CircularProgressIndicator(),
          ),
        )
            : Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                Center(
                  child: Container(
                    width: size.width / 1.1,
                    child: const Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: size.width / 1.1,
                    child: Text(
                      "Create Account to Contiue!",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                UserImagePicker(onPickImage: (pickedImage) {
                  _selectedImage = pickedImage;
                }),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefix: Icon(Icons.person),
                        label: Text('Name')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    autocorrect: false,
                    controller: _email,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefix: Icon(Icons.email_outlined),
                        label: Text('Email')),
                    onChanged: (value) {
                      _validateEmail(value);
                    },
                    validator: (val) => val!.isEmpty ||
                        !val.contains("@") ||
                        !val.contains('.')
                        ? "enter a valid email"
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _password,
                    inputFormatters: [maskFormatter],
                    obscureText: _passwordVisible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefix: const SizedBox(
                          width: 50, child: Icon(Icons.password)),
                      label: const Text('Password'),
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    onChanged: (password) => onPasswordChanged(password),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _isPasswordEightCharacters
                                ? Colors.green
                                : Colors.red,
                            border: _isPasswordEightCharacters
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Icon(
                            _isPasswordEightCharacters
                                ? Icons.check
                                : Icons.clear,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Contains at least 8 characters")
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _hasPasswordOneNumber
                                ? Colors.green
                                : Colors.red,
                            border: _hasPasswordOneNumber
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Icon(
                            _hasPasswordOneNumber
                                ? Icons.check
                                : Icons.clear,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Contains at least 1 number")
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _hasPasswordSpecialChar
                                ? Colors.green
                                : Colors.red,
                            border: _hasPasswordSpecialChar
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Icon(
                            _hasPasswordSpecialChar
                                ? Icons.check
                                : Icons.clear,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Contains at least Special Chracter")
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _hasPasswordCapLet
                                ? Colors.green
                                : Colors.red,
                            border: _hasPasswordCapLet
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Icon(
                            _hasPasswordCapLet
                                ? Icons.check
                                : Icons.clear,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Contains at least Capital Letter")
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: size.height / 20,
                ),
                customButton(size),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isVisible = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasPasswordSpecialChar = false;
  bool _hasPasswordCapLet = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final capLetRegex = RegExp(r'[A-Z]');
    final specialCharRegex = RegExp(
      r'[|!#$%&()*+,-./:;<=>?@[\]^_{|}~]',
    );

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordOneNumber = true;

      _hasPasswordSpecialChar = false;
      if (specialCharRegex.hasMatch(password)) _hasPasswordSpecialChar = true;

      _hasPasswordCapLet = false;
      if (capLetRegex.hasMatch(password)) _hasPasswordCapLet = true;
    });
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_key.currentState!.validate()) {
          if (_name.text.isNotEmpty &&
              _email.text.isNotEmpty &&
              _password.text.isNotEmpty) {
            setState(() {
              isLoading = true;
            });
            createAccount(_name.text, _email.text, _password.text,_selectedImage)
                .then((user) {
              if (user != null) {
                setState(() {
                  isLoading = false;
                });
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
                print("Account Created Sucessfull");
              } else {
                print("Login Failed");
                setState(() {
                  isLoading = false;
                });
              }
            });
          } else {
            print("Please enter Fields");
          }
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue,
          ),
          alignment: Alignment.center,
          child: const Text(
            "Create Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return SizedBox(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}