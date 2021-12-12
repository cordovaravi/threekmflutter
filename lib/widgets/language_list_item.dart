import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageListItem extends StatelessWidget {
  final bool selected;
  final String? name;
  final String? acronym;
  const LanguageListItem(
      {Key? key,
      required this.selected,
      required this.name,
      required this.acronym})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Container(
        //   width: 50,
        //   height: 50,
        //   margin: EdgeInsets.only(right: 48),
        //   decoration: BoxDecoration(
        //       color: Theme.of(context).backgroundColor,
        //       borderRadius: BorderRadius.circular(6),
        //       border: Border.all(
        //           color: selected ? Color(0xFF546AA6) : Colors.transparent)),
        //   child: Center(
        //     child: Text(
        //       acronym!,
        //       style: selected
        //           ? Theme.of(context)
        //               .textTheme
        //               .headline4!
        //               .copyWith(color: Color(0xFF546AA6))
        //           : Theme.of(context).textTheme.headline4,
        //     ),
        //   ),
        // ),
        Text(name!,
            textAlign: TextAlign.left,
            style: selected
                ? GoogleFonts.lato().copyWith(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)
                : GoogleFonts.lato().copyWith(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 32,
                    fontWeight: FontWeight.bold))
      ],
    );
  }
}
