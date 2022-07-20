import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/UI/userkyc/birth_date.dart';
import 'package:threekm/providers/ProfileInfo/ProfileInfo_Provider.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class BasicInfo extends StatefulWidget {
  BasicInfo({Key? key}) : super(key: key);

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  //TextEditingController _fname = TextEditingController();
  String _fname = "";

  String _lname = "";
  late SharedPreferences _pref;
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      initPreferences();

      setState(() {});
    });

    super.initState();
  }

  Future<String?> initPreferences() async {
    _pref = await SharedPreferences.getInstance();
    fname.text = '${_pref.getString("userfname")}';
    lname.text = '${_pref.getString("userlname")}';
    //return _pref.getString("email");
  }

  Widget get buildPhoneNumber {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 60,
              child: TextFormField(
                initialValue: '+91',
                readOnly: true,
                decoration: const InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
                width: size(context).width / 1.4,
                child: TextFormField(
                  readOnly: true,
                  initialValue: '${_pref.getString("userphone")}',
                  //keyboardType: TextInputType.number,

                  decoration: const InputDecoration(
                    suffixIcon:
                        Image(image: AssetImage('assets/verified2.png')),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step 4/6',
                style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Basic Information',
                    style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TabBarNavigation(
                                    bottomIndex: 3,
                                  )),
                          (route) => false);
                    },
                    child: Text(
                      'Cancel',
                      style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size(context).height / 25,
              ),
              LinearProgressIndicator(
                valueColor: const AlwaysStoppedAnimation(Color(0xFF3E7EFF)),
                minHeight: 3,
                color: Colors.amber[400],
                backgroundColor: const Color(0xFFE7E7E7),
                value: 0.4,
                semanticsLabel: 'Linear progress indicator',
              ),
              SizedBox(
                height: size(context).height / 25,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // focusNode: _controller.node,
                controller: fname,

                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                maxLines: 1,
                maxLength: 20,
                decoration: InputDecoration(
                  suffix: Text(_fname.length == 0 ? '' : '${_fname.length}/20'),
                  hintText: "First name",
                  counterText: "",
                  hintStyle: ThreeKmTextConstants.tk16PXPoppinsBlackMedium
                      .copyWith(color: const Color(0xFF979EA4)),
                  filled: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                onChanged: (v) {
                  setState(() {
                    _fname = v;
                  });
                },
                onFieldSubmitted: (val) {
                  FocusScope.of(context).unfocus();
                  if (val.isNotEmpty &&
                      val.contains(".") &&
                      val.contains("@")) {
                    print("save");
                    //   controller.updateProfileInfo(email: emailController.text);
                  }
                },

                validator: (val) {
                  // if (val!.isEmpty || val == null) {
                  //   return "Email is empty";
                  // } else if (!val.contains(".")) {
                  //   return "Please enter valid Email";
                  // } else if (val.contains(" ")) {
                  //   return "Space is not allowed";
                  // } else if (!val.contains("@")) {
                  //   return "Please enter valid Email";
                  // }
                },
              ),
              SizedBox(
                height: size(context).height / 33,
              ),
              TextFormField(
                controller: lname,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                maxLines: 1,
                maxLength: 20,
                decoration: InputDecoration(
                  suffix: Text(_lname.length == 0 ? '' : '${_lname.length}/20'),
                  hintText: "Last name",
                  counterText: "",
                  hintStyle: ThreeKmTextConstants.tk16PXPoppinsBlackMedium
                      .copyWith(color: const Color(0xFF979EA4)),
                  filled: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                onChanged: (v) {
                  setState(() {
                    _lname = v;
                  });
                },
                onFieldSubmitted: (val) {
                  FocusScope.of(context).unfocus();
                  if (val.isNotEmpty &&
                      val.contains(".") &&
                      val.contains("@")) {
                    print("save");
                    //   controller.updateProfileInfo(email: emailController.text);
                  }
                },
                validator: (val) {
                  // if (val!.isEmpty || val == null) {
                  //   return "Email is empty";
                  // } else if (!val.contains(".")) {
                  //   return "Please enter valid Email";
                  // } else if (val.contains(" ")) {
                  //   return "Space is not allowed";
                  // } else if (!val.contains("@")) {
                  //   return "Please enter valid Email";
                  // }
                },
              ),
              SizedBox(
                height: size(context).height / 33,
              ),
              buildPhoneNumber,
              SizedBox(
                height: size(context).height / 33,
              ),
              SizedBox(
                  width: size(context).width,
                  child: TextFormField(
                    readOnly: true,
                    initialValue: '${_pref.getString("email")}',
                    //keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      suffixIcon:
                          Image(image: AssetImage('assets/verified2.png')),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  )),
              const Spacer(),
              Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              const StadiumBorder())),
                      onPressed: () {
                        if (fname.text != "" && lname.text != "") {
                          context
                              .read<ProfileInfoProvider>()
                              .updateProfileInfo(
                                  fname: fname.text, lname: lname.text)
                              .whenComplete(() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => BirthDate())));
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please add First and last name");
                        }
                        ;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Next',
                          style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
