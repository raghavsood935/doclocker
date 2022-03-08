import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_docsaver/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/datanextscreen.dart';
import '../Utilities/theme_data.dart';
import 'login_page.dart';

class CreateAccount extends StatefulWidget {
  User_Info obj;
  CreateAccount(this.obj);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool isLoading = false;
  String? dropDownValue;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final contactNumberEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  bool passwordVisibility1 = false;
  bool passwordVisibility2 = false;

  @override
  void initState() {
    passwordVisibility1 = false;
    passwordVisibility2 = false;
  }

  User_Info obj = User_Info(
      firstName: '', lastName: '', contactNumber: 0, email: '', password: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Enter Your Details !",
              style: TextStyle(
                fontFamily: GoogleFonts.lato().fontFamily,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              )),
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), // 4
              );
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //first name field
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{3,}$');
                              if (value!.isEmpty) {
                                return ("First Name cannot be Empty");
                              }
                              if (!regex.hasMatch(value)) {
                                return ("Enter Valid name(Min. 3 Character)");
                              }
                              return null;
                            },
                            controller: firstNameEditingController,
                            textInputAction: TextInputAction.next,
                            onSaved: (value) {
                              firstNameEditingController.text = value!;
                            },
                            decoration: InputDecoration(
                              labelText: 'Enter First Name',
                              labelStyle: TextStyle(
                                fontFamily: GoogleFonts.lato().fontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                // ignore: prefer_const_constructors
                                borderSide: BorderSide(
                                    color: Colors.deepPurple, width: 1),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.deepPurple, width: 1),
                                borderRadius: BorderRadius.circular(35),
                              ),
                            ),
                            style: theme.bodyText1),
                      ),

                      //last name field
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Last Name cannot be Empty");
                              }
                              return null;
                            },
                            controller: lastNameEditingController,
                            textInputAction: TextInputAction.next,
                            onSaved: (value) {
                              lastNameEditingController.text = value!;
                            },
                            decoration: InputDecoration(
                              labelText: 'Enter Last Name',
                              labelStyle: TextStyle(
                                fontFamily: GoogleFonts.lato().fontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                // ignore: prefer_const_constructors
                                borderSide: BorderSide(
                                    color: Colors.deepPurple, width: 1),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.deepPurple, width: 1),
                                borderRadius: BorderRadius.circular(35),
                              ),
                            ),
                            style: theme.bodyText1),
                      ),

                      //contact number field
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                            controller: contactNumberEditingController,
                            validator: (value) {
                              if (value!.length != 10) {
                                return ('Mobile Number must be of 10 digit');
                              } else {
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            onSaved: (value) {
                              contactNumberEditingController.text = value!;
                            },
                            decoration: InputDecoration(
                              labelText: 'Enter Mobile Number',
                              labelStyle: TextStyle(
                                fontFamily: GoogleFonts.lato().fontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepPurple, width: 1),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.deepPurple, width: 1),
                                borderRadius: BorderRadius.circular(35),
                              ),
                            ),
                            style: theme.bodyText1),
                      ),

                      //email field
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Please Enter Your Email");
                              }
                              // reg expression for email validation
                              if (!RegExp(
                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return ("Please Enter a valid email");
                              }
                              return null;
                            },
                            controller: emailEditingController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              emailEditingController.text = value!;
                            },
                            decoration: InputDecoration(
                              labelText: 'Enter Email',
                              labelStyle: TextStyle(
                                fontFamily: GoogleFonts.lato().fontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepPurple, width: 1),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.deepPurple, width: 1),
                                borderRadius: BorderRadius.circular(35),
                              ),
                            ),
                            style: theme.bodyText1),
                      ),

                      //password field
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                            controller: passwordEditingController,
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{6,}$');
                              if (value!.isEmpty) {
                                return ("Password is required for login");
                              }
                              if (!regex.hasMatch(value)) {
                                return ("Enter Valid Password(Min. 6 Character)");
                              }
                            },
                            onSaved: (value) {
                              passwordEditingController.text = value!;
                            },
                            textInputAction: TextInputAction.next,
                            obscureText: !passwordVisibility1,
                            decoration: InputDecoration(
                                labelText: 'Create Password',
                                labelStyle: TextStyle(
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple, width: 1),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple, width: 1),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                    () => passwordVisibility1 =
                                        !passwordVisibility1,
                                  ),
                                  child: Icon(
                                    passwordVisibility1
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.deepPurple,
                                    size: 22,
                                  ),
                                )),
                            style: theme.bodyText1),
                      ),

                      //Confirm password field
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                            controller: confirmPasswordEditingController,
                            validator: (value) {
                              if (confirmPasswordEditingController.text !=
                                  passwordEditingController.text) {
                                return "Password don't match";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              confirmPasswordEditingController.text = value!;
                            },
                            textInputAction: TextInputAction.done,
                            obscureText: !passwordVisibility2,
                            decoration: InputDecoration(
                                labelText: 'Verify Password',
                                labelStyle: TextStyle(
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple, width: 1),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple, width: 1),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                    () => passwordVisibility2 =
                                        !passwordVisibility2,
                                  ),
                                  child: Icon(
                                    passwordVisibility2
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.deepPurple,
                                    size: 22,
                                  ),
                                )),
                            style: theme.bodyText1),
                      ),

                      // "Sign-Up" ---> Button Widget //

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              obj = User_Info(
                                  firstName: firstNameEditingController.text,
                                  lastName: lastNameEditingController.text,
                                  contactNumber: int.parse(
                                      contactNumberEditingController.text),
                                  email: emailEditingController.text,
                                  password: passwordEditingController.text);

                              setState(() {
                                isLoading = true;
                              });
                              signUp(obj.email, obj.password);
                            },
                            child: (isLoading)
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1.5,
                                    ))
                                : Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: Colors.deepPurple)),
                              child: Text('L O G I N ',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  )),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()), // 4
                                );
                              },
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 130, vertical: 15),
                        child: Divider(thickness: 3, color: Colors.deepPurple),
                      )
                    ]),
              ),
            ),
          ),
        ));
  }

  void signUp(String email, String password) async {
    // if (_formKey.currentState!.validate()) {

    //       .catchError((e) {
    //     Fluttertoast.showToast(msg: e!.message);
    //   });
    // }
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {postDetailsToFirestore()});
  }

  postDetailsToFirestore() async {
    //calling firestore
    //calling user model
    //sending data
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    //writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = obj.firstName;
    userModel.lastName = obj.lastName;
    userModel.contactNumber = obj.contactNumber.toString();
    userModel.preference = obj.preference;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(
        msg: "Account created Successfully \n Please Login Now");

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }
}

// TextForm Field Widget //--

// class textFormField extends StatefulWidget {
//   final String? LabelText;
//   final TextEditingController? editingController;
//   final TextInputType? keyboardType;
//   final void Function(String?)? onSaved;
//   final TextInputAction? textInputAction;

//   // ignore: non_constant_identifier_names
//   textFormField(
//       {@required this.LabelText,
//       this.editingController,
//       this.keyboardType,
//       this.onSaved,
//       this.textInputAction});
//   // const textFormField({
//   //   Key? key,
//   // }) : super(key: key);

//   @override
//   State<textFormField> createState() => _textFormFieldState();
// }

// class _textFormFieldState extends State<textFormField> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//       child: TextFormField(
//           decoration: InputDecoration(
//             labelText: widget.LabelText,
//             labelStyle: GoogleFonts.poppins(
//                 textStyle: Theme.of(context).textTheme.bodyText1,
//                 fontSize: 14,
//                 color: Colors.black38),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: const Color(0xFFb2b2b2), width: 1),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Color(0xFFb2b2b2), width: 1),
//               borderRadius: BorderRadius.circular(5),
//             ),
//           ),
//           style: theme.bodyText1),
//     );
//   }
// }
