import 'package:flutter/material.dart';

import '../constraints/header_text.dart';

class InfoBlock extends StatelessWidget {
 final String title;
  final  String value;
  final CrossAxisAlignment crossAxisAlignment;
  const InfoBlock({super.key,required this.title,required this.value,this.crossAxisAlignment=CrossAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        HeaderText(text: title.toUpperCase(), size: 10),
        HeaderText(text: value, size: 16),
      ],
    );
  }
}
