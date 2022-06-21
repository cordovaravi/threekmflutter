import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/utils/constants.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

import 'identity_verification.dart';

class ConfirmInfo extends StatefulWidget {
  const ConfirmInfo({Key? key}) : super(key: key);

  @override
  State<ConfirmInfo> createState() => _ConfirmInfoState();
}

class _ConfirmInfoState extends State<ConfirmInfo> {
  late SharedPreferences? _pref;
  var date = "";
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      _pref = await SharedPreferences.getInstance();
      setState(() {});
    });
    super.initState();
  }

  formateDate(dateUtc) {
    var dateFormat = DateFormat("hh:mm aa dd MM yyyy");
    var utcDate = dateFormat.format(DateTime.parse(dateUtc));
    var localDate = dateFormat.parse(utcDate, true).toLocal().toString();

    String createdDate =
        DateFormat("dd MM yyyy").format(DateTime.parse(localDate));
    return createdDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm your Basic Information',
              style: ThreeKmTextConstants.tk18PXPoppinsBlackMedium,
            ),
            const SizedBox(
              height: 24,
            ),
            LinearProgressIndicator(
              valueColor: const AlwaysStoppedAnimation(Color(0xFF3E7EFF)),
              minHeight: 3,
              color: Colors.amber[400],
              backgroundColor: const Color(0xFFE7E7E7),
              value: 0.2,
              semanticsLabel: 'Linear progress indicator',
            ),
            const SizedBox(
              height: 46,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  _pref?.getString('avatar') != ""
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image(
                            image:
                                NetworkImage('${_pref?.getString('avatar')}'),
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                              color: Colors.grey[350], shape: BoxShape.circle),
                        ),
                  Text(
                    'Profile photo',
                    style: ThreeKmTextConstants.tk16PXPoppinsBlackMedium,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 44,
            ),
            SizedBox(
                width: size(context).width,
                child: TextFormField(
                  readOnly: true,
                  initialValue: "${_pref?.getString("userfname") ?? ""}",
                  //keyboardType: TextInputType.number,

                  decoration: const InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                )),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
                width: size(context).width,
                child: TextFormField(
                  readOnly: true,
                  initialValue: "${_pref?.getString("userlname") ?? ""}",
                  //keyboardType: TextInputType.number,

                  decoration: const InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                )),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
                width: size(context).width,
                child: TextFormField(
                  readOnly: true,
                  initialValue: "${formateDate('${_pref?.getString("dob")}')}",
                  //keyboardType: TextInputType.number,

                  decoration: const InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                )),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
                width: size(context).width,
                child: TextFormField(
                  readOnly: true,
                  initialValue: "${_pref?.getString("userphone")}",
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
            const SizedBox(
              height: 24,
            ),
            SizedBox(
                width: size(context).width,
                child: TextFormField(
                  readOnly: true,
                  initialValue: "${_pref?.getString("email")}",
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
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              StadiumBorder())),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => IdentityVerification()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Next',
                          style: ThreeKmTextConstants.tk16PXPoppinsWhiteBold,
                        ),
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
