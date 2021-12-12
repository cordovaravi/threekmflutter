import 'package:flutter/material.dart';

class AnimatedButtonCircle extends StatefulWidget {
  const AnimatedButtonCircle({Key? key}) : super(key: key);

  @override
  _AnimatedButtonCircleState createState() => _AnimatedButtonCircleState();
}

class _AnimatedButtonCircleState extends State<AnimatedButtonCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      reverseDuration: Duration(seconds: 2),
    );
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          height: 18,
          width: 18,
          alignment: Alignment.center,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: 18 * controller.value,
                width: 18 * controller.value,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
              child!,
            ],
          ),
        );
      },
      child: Container(
        height: 8,
        width: 8,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      ),
    );
  }
}

// var firstname = TextEditingController();
// var lastname = TextEditingController();
// bool firstnameValid = true;
// bool lastnameValid = true;
//
// @override
// void dispose() {
//   firstname.dispose();
//   lastname.dispose();
//   super.dispose();
// }

// valid: firstnameValid,
// stateChanged: (v) => setState(() => firstnameValid = v),

//
//
//  required bool valid,
//     required ValueChanged<bool> stateChanged,

// onChanged: (value) {
// if (value.isNotEmpty && value.length < 3)
// stateChanged(false);
// else if (value.isNotEmpty && value.length > 3)
// stateChanged(true);
// else if (value.isEmpty) stateChanged(true);
// },
