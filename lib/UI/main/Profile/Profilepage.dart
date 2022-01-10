import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';
import 'package:threekm/utils/util_methods.dart';
import 'package:threekm/widgets/animated_button_circle.dart';
import 'package:threekm/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: buildAppBar,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildProfileImage,
            space(height: 8),
            buildProfileName,
            space(height: 8),
            buildProfileButton(
              title: "Change Name",
              width: 105,
              onTap: () => showNameDialog(),
            ),
            space(height: 60),
            buildProfileRow(
              title: "Mobile",
              showDivider: true,
              child: buildPhoneNumber,
            ),
            buildProfileRow(
              title: "Email",
              showDivider: true,
              child: buildEmail,
            ),
            buildProfileRow(
              title: "Date of Birth",
              showDivider: true,
              child: buildDateOfBirth,
            ),
            buildProfileRow(
              title: "Gender",
              showDivider: true,
              child: buildGender,
            ),
            buildProfileRow(
              title: "Account Password",
              showDivider: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildProfileButton(
                    title: "Change Password",
                    width: 127,
                    onTap: () => showPasswordDialog(),
                  ),
                ],
              ),
            ),
            space(height: 80)
          ],
        ),
      ),
    );
  }

  // Widgets

  Widget buildCloseButton({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(12.68),
        child: Icon(Icons.close),
      ),
    );
  }

  Future<void> showPhoneDialog() async {
    await showGeneralDialog(
        context: context,
        barrierColor: Color(0xFF0F0F2D).withOpacity(0.75), // background color
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 400),
        useRootNavigator: false,
        pageBuilder: (_context, anim, anim2) {
          return Scaffold(
            backgroundColor: Color(0xFF0F0F2D).withOpacity(0.75),
            resizeToAvoidBottomInset: true,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildCloseButton(onTap: () {
                    // Get.find<ProfileController>().cleaForPhone();
                    Navigator.of(context).pop();
                  }),
                  PhonePopUp()
                ],
              ),
            ),
          );
        });
  }

  Future<void> showGenderDialog() async {
    await showGeneralDialog(
        context: context,
        barrierColor: Color(0xFF0F0F2D).withOpacity(0.75), // background color
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 400),
        useRootNavigator: false,
        pageBuilder: (_context, anim, anim2) {
          return Material(
            color: Color(0xFF0F0F2D).withOpacity(0.75),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildCloseButton(onTap: Navigator.of(context).pop),
                  GenderPopUp()
                ],
              ),
            ),
          );
        });
  }

  Future<void> showProfileImageDialog() async {
    await showGeneralDialog(
        context: context,
        barrierColor: Color(0xFF0F0F2D).withOpacity(0.75), // background color
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 400),
        useRootNavigator: false,
        pageBuilder: (_context, anim, anim2) {
          return Material(
            color: Color(0xFF0F0F2D).withOpacity(0.75),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildCloseButton(onTap: () {
                    // if (!Get.find<ProfileController>().buttonLoading) {
                    //   Get.find<ProfileController>().imageList = null;
                    //   Get.find<ProfileController>().imageName = null;
                    //   Navigator.of(context).pop();
                    // }
                  }),
                  ProfileImagePopUp()
                ],
              ),
            ),
          );
        });
  }

  Future<void> showNameDialog() async {
    await showGeneralDialog(
        context: context,
        barrierColor: Color(0xFF0F0F2D).withOpacity(0.75), // background color
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 400),
        useRootNavigator: false,
        pageBuilder: (_context, anim, anim2) {
          return Scaffold(
            backgroundColor: Color(0xFF0F0F2D).withOpacity(0.75),
            resizeToAvoidBottomInset: true,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildCloseButton(onTap: Navigator.of(context).pop),
                  NamePopUp()
                ],
              ),
            ),
          );
        });
  }

  Future<void> showPasswordDialog() async {
    await showGeneralDialog(
        context: context,
        barrierColor: Color(0xFF0F0F2D).withOpacity(0.75), // background color
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 400),
        useRootNavigator: false,
        pageBuilder: (_context, anim, anim2) {
          return Scaffold(
            backgroundColor: Color(0xFF0F0F2D).withOpacity(0.75),
            resizeToAvoidBottomInset: true,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildCloseButton(onTap: Navigator.of(context).pop),
                  ChangePasswordPopUp()
                ],
              ),
            ),
          );
        });
  }

  PreferredSizeWidget? get buildAppBar {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 22,
          ),
          onPressed: () => Navigator.of(context).pop()),
      title: Text(
        "My Profile".toUpperCase(),
        style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold.copyWith(
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget get buildProfileImage {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: 120,
            height: 120,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.only(top: 33),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThreeKmTextConstants.lightBlue,
            ),
            // child: _controller.profile.imageUrl == null
            //     ? Image.asset("assets/default_profile_image.png")
            //     : CachedNetworkImage(
            //         imageUrl: _controller.profile.imageUrl!,
            //         fit: BoxFit.fill,
            //         placeholder: (context, url) =>
            //             CupertinoActivityIndicator(),
            //       ),
            child: Image.asset("assets/default_profile_image.png"),
          ),
          Transform.translate(
            offset: Offset(45, -30),
            child: Container(
              height: 32,
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Center(
                child: GestureDetector(
                  onTap: showProfileImageDialog,
                  child: Icon(
                    Icons.edit,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildProfileRow(
      {required String title,
      required bool showDivider,
      required Widget child}) {
    return Container(
      padding: EdgeInsets.only(left: 18, right: 19),
      child: Container(
        padding: EdgeInsets.only(top: 34, bottom: 17),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: showDivider ? Color(0xFFF4F3F8) : Colors.white,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                color: Color(0xFF979EA4),
              ),
            ),
            child
          ],
        ),
      ),
    );
  }

  Widget get buildProfileName {
    return Text(
      // _controller.profile.profileName ??
      "Profile Name",
      style: GoogleFonts.poppins(
        fontSize: 24,
        color: Color(0xFF0F0F2D),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget buildEditButton({VoidCallback? onTap}) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF4F3F8),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          Icons.edit,
          size: 20,
        ),
      ),
    );
  }

  Widget buildProfileButton(
      {required String title, double? width, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Center(
          child: Text(
            "$title",
            style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold.copyWith(
              color: Color(0xFF3E7EFF),
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Color(0xFF3E7EFF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget get buildPhoneNumber {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "+91",
          style: ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
            color: Color(0xFF0F0F2D),
          ),
        ),
        space(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.translate(
              offset: Offset(0, 0),
              child: Transform.rotate(
                angle: -pi / 2,
                child: Container(
                  width: 23,
                  height: 20,
                  alignment: Alignment.centerRight,
                  child: Divider(
                    color: Colors.grey.withOpacity(1),
                    thickness: 1,
                    height: 36,
                  ),
                ),
              ),
            ),
          ],
        ),
        space(width: 8),
        // _controller.profile.phoneNumber != null
        //     ? Text(
        //         "${_controller.profile.phoneNumber}",
        //         style: ThreeKmTextConstants.tk16PXLatoBlackRegular.copyWith(
        //           color: Color(0xFF0F0F2D),
        //         ),
        //       )
        //     :
        Text(
          "Enter your phone number",
          style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium.copyWith(
            color: Color(0xFF979EA4),
            fontWeight: FontWeight.normal,
          ),
        ),
        space(width: 16),
        buildEditButton(onTap: showPhoneDialog),
      ],
    );
  }

  Widget get buildEmail {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 220,
          height: 50,
          margin: EdgeInsets.only(top: 0),
          child: TextField(
            // focusNode: _controller.node,
            // controller: _controller.textForEmail,
            textAlign: TextAlign.end,
            textAlignVertical: TextAlignVertical.top,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Enter your email here",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintStyle: GoogleFonts.poppins(
                fontSize: 16,
                color: Color(0xFF979EA4),
                fontWeight: FontWeight.normal,
              ),
            ),
            onEditingComplete: () {
              // _controller.saveEmail();
            },
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Color(0xFF0F0F2D),
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDateOfBirthFields(
      {required String text, BorderRadiusGeometry? radius}) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFF4F3F8),
        borderRadius: radius,
      ),
      child: Text(
        "$text",
        style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium
            .copyWith(color: Color(0xFF0F0F2D), fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget get buildDateOfBirth {
    String day = "15";
    // _controller.profile.dateOfBirth != null
    //     ? _controller.profile.dateOfBirth!.split("T")[0].split("-")[2]
    //     : "DD";
    String month = "11";
    //  _controller.profile.dateOfBirth != null
    //     ? _controller.profile.dateOfBirth!.split("T")[0].split("-")[1]
    //     : "MM";
    String year = "1998";
    // _controller.profile.dateOfBirth != null
    //     ? _controller.profile.dateOfBirth!.split("T")[0].split("-")[0]
    //     : "YYYY";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDateOfBirthFields(
          text: "${day.length <= 1 ? "0$day" : "$day"}",
          radius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
        space(width: 10),
        buildDateOfBirthFields(
            text: "${month.length <= 1 ? "0$month" : "$month"}"),
        space(width: 10),
        buildDateOfBirthFields(
          text: "$year",
          radius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        space(width: 14),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFF4F3F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: GestureDetector(
            //onTap: () => _controller.updateDateOfBirth(context),
            child: Icon(
              Icons.calendar_today,
              color: Color(0xFF3E7EFF),
            ),
          ),
        )
      ],
    );
  }

  Widget get buildGender {
    return GestureDetector(
      onTap: showGenderDialog,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFFF4F3F8),
        ),
        child: Row(
          children: [
            Text(
              "Select Your Gender",
              style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Color(0xFF979EA4),
              ),
            ),
            space(width: 10),
            Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF979EA4),
            ),
          ],
        ),
      ),
    );
    // : Row(
    //     children: [
    //       if (_controller.profile.gender?.toLowerCase() != "other") ...{
    //         SvgPicture.asset(
    //           _controller.profile.gender?.toLowerCase() == "male"
    //               ? "assets/male.svg"
    //               : _controller.profile.gender?.toLowerCase() == "female"
    //                   ? "assets/female.svg"
    //                   : "assets/other.png",
    //           height: 32,
    //           width: 32,
    //         ),
    //       } else ...{
    //         Image.asset(
    //           "assets/other.png",
    //           height: 32,
    //           width: 32,
    //         )
    //       },
    //       space(width: 12),
    //       Text(
    //         "${_controller.profile.gender}",
    //         style: GoogleFonts.poppins(
    //             color: Color(0xFF232629),
    //             fontSize: 18,
    //             fontWeight: FontWeight.w600),
    //       ),
    //       space(width: 71),
    //       buildEditButton(onTap: showGenderDialog)
    //     ],
    //   );
  }
}

//
//
//
//
//
// Pop up widgets
//
//
//
//
//
class ProfileImagePopUp extends StatelessWidget {
  const ProfileImagePopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25, top: 48, right: 25, bottom: 30),
      height: 643,
      width: double.infinity,
      margin: EdgeInsets.only(
        top: 24,
        bottom: 24,
        right: 8,
        left: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Crop and adjust".toUpperCase(),
            style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold.copyWith(
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F0F2D),
            ),
          ),
          space(
            height: 24,
          ),
          buildProfileButton(
            title: "Select other Photo",
            onTap: () {
              // Get.find<ProfileController>().pickImage();
            },
            width: 177,
          ),
          space(
            height: 62,
          ),
          Container(
              height: 289,
              width: 289,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Icon(
                Icons.collections,
                size: 100,
                color: Colors.grey,
              )
              // : Image.memory(
              //     _controller.imageList!,
              //     fit: BoxFit.fill,
              //   ),
              ),
          space(
            height: 72,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSaveButton(context),
            ],
          )
        ],
      ),
    );
  }

  // Widgets

  Widget buildProfileButton(
      {required String title, double? width, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.collections,
              color: Colors.blue,
            ),
            space(
              width: 8,
            ),
            Text(
              "$title",
              style: ThreeKmTextConstants.tk12PXPoppinsBlackSemiBold.copyWith(
                color: Color(0xFF3E7EFF),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Color(0xFF3E7EFF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget buildSaveButton(context) {
    return CustomButton(
      height: 52,
      width: 176,
      onTap: () async {
        // var pop = await Get.find<ProfileController>().changeProfilePicture();
        // if (pop == true) {
        //   Get.find<ProfileController>().imageName = null;
        //   Get.find<ProfileController>().imageList = null;
        //   Navigator.of(context).pop();
        // }
      },
      borderRadius: BorderRadius.circular(26),
      color: Color(0xFF3E7EFF),
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // if (!Get.find<ProfileController>().buttonLoading)
          // ...{
          AnimatedButtonCircle(),
          SizedBox(
            width: 12,
          ),
          Text(
            "Save Image",
            style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
                .copyWith(color: Colors.white),
          )
          // } else ...{
          //   Container(
          //     height: 30,
          //     child: CircularProgressIndicator(
          //       backgroundColor: Colors.transparent,
          //       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          //     ),
          //   )
          // }
        ],
      ),
    );
  }
}

class NamePopUp extends StatefulWidget {
  const NamePopUp({Key? key}) : super(key: key);

  @override
  _NamePopUpState createState() => _NamePopUpState();
}

class _NamePopUpState extends State<NamePopUp> {
  var firstname = TextEditingController();
  var lastname = TextEditingController();
  bool firstnameValid = true;
  bool lastnameValid = true;

  @override
  void initState() {
    super.initState();
    setNames();
  }

  void setNames() async {
    var pref = await SharedPreferences.getInstance();
    firstname.text = pref.getString(FIRSTNAME) ?? "";
    lastname.text = pref.getString(LASTNAME) ?? "";
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    firstname.dispose();
    lastname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25, top: 24, right: 25, bottom: 30),
      height: 370,
      width: double.infinity,
      margin: EdgeInsets.only(
        top: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Change Profile name".toUpperCase(),
            style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                .copyWith(fontWeight: FontWeight.w900),
          ),
          space(height: 20),
          buildTextField(
            hintText: "First Name Here",
            controller: firstname,
            valid: firstnameValid,
            stateChanged: (v) => setState(() => firstnameValid = v),
          ),
          space(height: 8),
          buildTextField(
            hintText: "Last Name Here",
            controller: lastname,
            valid: lastnameValid,
            stateChanged: (v) => setState(() => lastnameValid = v),
          ),
          space(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSaveButton(context),
            ],
          )
        ],
      ),
    );
  }

  Widget buildSaveButton(context) {
    return CustomButton(
      height: 52,
      width: 127,
      onTap: () async {
        // bool pop =
        //     await _controller.changeName(firstname.text, lastname.text);
        // if (pop) {
        //   Navigator.of(context).pop();
        // }
      },
      borderRadius: BorderRadius.circular(26),
      color: Color(0xFF3E7EFF),
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedButtonCircle(),
          SizedBox(
            width: 12,
          ),
          Text(
            "Save",
            style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
                .copyWith(color: Colors.white),
          )
          // } else ...{
          //   Container(
          //     height: 30,
          //     child: CircularProgressIndicator(
          //       backgroundColor: Colors.transparent,
          //       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          //     ),
          //   )
          // }
        ],
      ),
    );
  }

  Widget buildTextField({
    required String hintText,
    required TextEditingController controller,
    required bool valid,
    required ValueChanged<bool> stateChanged,
  }) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(bottom: 8),
      child: TextFormField(
        expands: hintText == "Enter Password" ? false : true,
        controller: controller,
        maxLines: hintText == "Enter Password" ? 1 : null,
        obscureText: hintText == "Enter Password",
        style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold.copyWith(
          fontWeight: FontWeight.w400,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && value.length < 3)
            stateChanged(false);
          else if (value.isNotEmpty && value.length > 3)
            stateChanged(true);
          else if (value.isEmpty) stateChanged(true);
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
              .copyWith(color: Color(0xFF979EA4), fontWeight: FontWeight.w400),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: valid ? Color(0xFFF4F3F8) : Colors.red, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: valid ? Color(0xFF43B978) : Colors.red, width: 1),
          ),
        ),
      ),
    );
  }
}

class PhonePopUp extends StatefulWidget {
  PhonePopUp({Key? key}) : super(key: key);

  @override
  _PhonePopUpState createState() => _PhonePopUpState();
}

class _PhonePopUpState extends State<PhonePopUp> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25, top: 24, right: 25, bottom: 30),
      height: 370,
      width: double.infinity,
      margin: EdgeInsets.only(
        top: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Change Mobile Number".toUpperCase(),
            style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                .copyWith(fontWeight: FontWeight.w900),
          ),
          space(height: 48),
          Text(
            "Enter New Mobile Number",
            style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold.copyWith(
                color: Color(0xFF979EA4), fontWeight: FontWeight.w500),
          ),
          space(height: 13),
          buildTextField(
            hintText: "**********",
            controller: controller,
          ),
          space(height: 30),
          buildSaveButton(
              //onTap: () => _controller.sendOtp(controller.text),
              )
        ],
      ),
    );
    // : Container(
    //     padding:
    //         EdgeInsets.only(left: 25, top: 24, right: 25, bottom: 30),
    //     height: 370,
    //     width: double.infinity,
    //     margin: EdgeInsets.only(
    //       top: 24,
    //     ),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //     ),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           "Change Mobile Number".toUpperCase(),
    //           style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
    //               .copyWith(fontWeight: FontWeight.w900),
    //         ),
    //         space(height: 48),
    //         RichText(
    //           text: TextSpan(
    //             text:
    //                 "A 4-digit OTP has been sent to ${controller.text} via SMS. ",
    //             style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
    //                 .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
    //             children: [
    //               TextSpan(
    //                 text: "Change Phone Number",
    //                 style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
    //                     .copyWith(
    //                   fontWeight: FontWeight.w600,
    //                   color: Colors.blue,
    //                   fontSize: 14,
    //                   decoration: TextDecoration.underline,
    //                 ),
    //                 recognizer: TapGestureRecognizer()
    //                   ..onTap =
    //                       () => _controller.changePhoneNumberPage(0),
    //               ),
    //             ],
    //           ),
    //         ),
    //         space(height: 32),
    //         Container(
    //           width: MediaQuery.of(context).size.width * 0.65,
    //           child: PinCodeTextField(
    //             enableActiveFill: true,
    //             enablePinAutofill: true,
    //             controller: controller2,
    //             keyboardType: TextInputType.number,
    //             autoDisposeControllers: false,
    //             inputFormatters: [
    //               FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))
    //             ],
    //             pinTheme: PinTheme(
    //               shape: PinCodeFieldShape.box,
    //               fieldHeight: 56,
    //               fieldWidth: 48,
    //               borderRadius: BorderRadius.circular(10),
    //               activeFillColor: Color(0xFFF4F3F8),
    //               inactiveFillColor: Color(0xFFF4F3F8),
    //               activeColor: Color(0xFFD5D5D5),
    //               inactiveColor: Color(0xFFD5D5D5),
    //               selectedFillColor: Color(0xFFF4F3F8),
    //             ),
    //             onChanged: (String value) {
    //               print(value);
    //             },
    //             length: 4,
    //             appContext: context,
    //           ),
    //         ),
    //         space(height: 30),
    //         buildSaveButton(
    //           title: "Submit OTP",
    //           width: 152,
    //           onTap: () async {
    //             bool pop = await _controller.verifyOtp(controller2.text);
    //             if (pop) {
    //               bool remove = await Get.find<ProfileController>()
    //                   .updatePhoneNumber(controller.text);
    //               if (remove) {
    //                 Navigator.of(context).pop();
    //               }
    //             }
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget buildSaveButton({VoidCallback? onTap, String? title, double? width}) {
    return CustomButton(
      height: 52,
      width: width ?? 127,
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      color: Color(0xFF3E7EFF),
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title == null ? "Send OTP" : title,
            style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
                .copyWith(color: Colors.white),
          )
          // } else ...{
          //   Container(
          //     height: 30,
          //     child: CircularProgressIndicator(
          //       backgroundColor: Colors.transparent,
          //       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          //     ),
          //   )
          // }
        ],
      ),
    );
  }

  Widget buildTextField(
      {required String hintText, required TextEditingController controller}) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF4F3F8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Color(0xFFD5D5D5),
        ),
      ),
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            "+91",
            style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          Transform.rotate(
            angle: -pi / 2,
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              child: Center(
                child: Divider(
                  color: Colors.grey.withOpacity(0.3),
                  thickness: 1,
                  height: 15,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 6),
              child: TextField(
                expands: hintText == "Enter Password" ? false : true,
                controller: controller,
                maxLines: hintText == "Enter Password" ? 1 : null,
                obscureText: hintText == "Enter Password",
                style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold.copyWith(
                  fontWeight: FontWeight.w400,
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  FilteringTextInputFormatter.deny(RegExp("[\\.|\\,]")),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                        .copyWith(
                            color: Color(0xFF979EA4),
                            fontWeight: FontWeight.w400),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordPopUp extends StatefulWidget {
  const ChangePasswordPopUp({Key? key}) : super(key: key);

  @override
  _ChangePasswordPopUpState createState() => _ChangePasswordPopUpState();
}

class _ChangePasswordPopUpState extends State<ChangePasswordPopUp> {
  var _current = TextEditingController();
  var _new = TextEditingController();
  var _newConfirm = TextEditingController();
  var _currentValid = true;
  var _currentHidden = true;
  var _newValid = true;
  var _newHidden = true;
  var _newConfirmValid = true;
  var _newConfirmHidden = true;

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _newConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25, top: 24, right: 25, bottom: 30),
      height: 400,
      width: double.infinity,
      margin: EdgeInsets.only(
        top: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Change Account Password".toUpperCase(),
            style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
                .copyWith(fontWeight: FontWeight.w900),
          ),
          space(height: 24),
          buildTextField(
            hintText: "Enter Current Password",
            controller: _current,
            valid: _currentValid,
            hidden: _currentHidden,
            onObscureChanged: (v) {
              setState(() {
                _currentHidden = v;
              });
            },
            stateChanged: (v) => setState(() => _currentValid = v),
          ),
          space(height: 8),
          buildTextField(
            hintText: "Enter New Password",
            controller: _new,
            hidden: _newHidden,
            onObscureChanged: (v) {
              setState(() {
                _newHidden = v;
              });
            },
            valid: _newValid && _new.text == _newConfirm.text,
            stateChanged: (v) => setState(() => _newValid = v),
          ),
          space(height: 8),
          buildTextField(
            hintText: "Repeat New Password",
            controller: _newConfirm,
            hidden: _newConfirmHidden,
            onObscureChanged: (v) {
              setState(() {
                _newConfirmHidden = v;
              });
            },
            valid: _newConfirmValid && _new.text == _newConfirm.text,
            stateChanged: (v) => setState(() => _newConfirmValid = v),
          ),
          space(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSaveButton(context),
            ],
          )
        ],
      ),
    );
  }

  Widget buildSaveButton(context) {
    return CustomButton(
      height: 52,
      width: 238,
      onTap: () async {
        // bool pop = await _controller.changePassword(
        //     _current.text, _new.text, _newConfirm.text);
        // if (pop) {
        //   Navigator.of(context).pop();
        // }
      },
      borderRadius: BorderRadius.circular(26),
      color: Color(0xFF3E7EFF),
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedButtonCircle(),
          SizedBox(
            width: 12,
          ),
          Text(
            "Save New Password",
            style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
                .copyWith(color: Colors.white),
          )
          // } else ...{
          //   Container(
          //     height: 30,
          //     child: CircularProgressIndicator(
          //       backgroundColor: Colors.transparent,
          //       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          //     ),
          //   )
          // }
        ],
      ),
    );
  }

  Widget buildTextField({
    required String hintText,
    required TextEditingController controller,
    required bool valid,
    required hidden,
    required ValueChanged<bool> onObscureChanged,
    required ValueChanged<bool> stateChanged,
  }) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(bottom: 8),
      child: TextField(
        expands: false,
        controller: controller,
        maxLines: 1,
        obscureText: hidden,
        style: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold.copyWith(
          fontWeight: FontWeight.w400,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && value.length < 6)
            stateChanged(false);
          else if (value.isNotEmpty && value.length >= 6)
            stateChanged(true);
          else if (value.isEmpty) stateChanged(true);
        },
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: GestureDetector(
            onTap: () => onObscureChanged(!hidden),
            child: Icon(
              Icons.remove_red_eye_outlined,
              color: hidden ? Colors.grey : Color(0xFF43B978),
            ),
          ),
          hintStyle: ThreeKmTextConstants.tk16PXPoppinsBlackSemiBold
              .copyWith(color: Color(0xFF979EA4), fontWeight: FontWeight.w400),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: valid ? Color(0xFFF4F3F8) : Colors.red, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: valid ? Color(0xFF43B978) : Colors.red, width: 1),
          ),
        ),
      ),
    );
  }
}

class GenderPopUp extends StatelessWidget {
  Widget buildGenderRow({required String asset, required String title}) {
    return GestureDetector(
      //onTap: () => _controller.changeGender(title),
      child: Row(
        children: [
          if (asset.substring(asset.lastIndexOf(".") + 1) == "png") ...{
            Image.asset(
              asset,
              width: 48,
              height: 48,
            ),
          } else ...{
            SvgPicture.asset(
              asset,
              width: 48,
              height: 48,
            ),
          },
          space(width: 16),
          Expanded(
            child: Text(
              title,
              style: ThreeKmTextConstants.tk14PXPoppinsBlackSemiBold
                  .copyWith(fontSize: 18),
            ),
          ),
          // Checkbox(
          //   value: title == _controller.gender,
          //   onChanged: (v) => _controller.changeGender(title),
          //   activeColor: Colors.green,
          //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 24),
      height: 466,
      width: double.infinity,
      margin: EdgeInsets.only(
        top: 24,
        left: 8,
        right: 8,
        bottom: 32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        children: [
          space(height: 40),
          Text(
            "Select gender".toUpperCase(),
            style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
                .copyWith(fontSize: 16),
          ),
          space(height: 56),
          buildGenderRow(asset: "assets/female.svg", title: "Female"),
          space(height: 24),
          buildGenderRow(asset: "assets/male.svg", title: "Male"),
          space(height: 24),
          buildGenderRow(asset: "assets/other.png", title: "Other"),
          space(height: 56),
          CustomButton(
            height: 52,
            width: 183,
            onTap: () async {
              // _controller.saveGender(_controller.gender, context);
            },
            borderRadius: BorderRadius.circular(26),
            color: Color(0xFF3E7EFF),
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
                    Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Save Gender",
                  style: ThreeKmTextConstants.tk14PXPoppinsBlackBold
                      .copyWith(color: Colors.white),
                )
                // } else ...{
                //   Container(
                //     height: 30,
                //     child: CircularProgressIndicator(
                //       backgroundColor: Colors.transparent,
                //       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                //     ),
                //   )
                // }
              ],
            ),
          ),
        ],
      ),
    );
  }
}
