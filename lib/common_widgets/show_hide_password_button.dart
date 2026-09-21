import 'package:flutter/material.dart';
class ShowHidePasswordButton extends StatelessWidget {

  final bool showPassword;
  final VoidCallback? onTap;


  const ShowHidePasswordButton({
    required this.showPassword,
    required this.onTap,
    super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap:onTap ,
      child: showPassword
          ? const Icon(Icons.visibility_off_outlined)
          : const Icon(Icons.visibility_outlined),
    );
  }
}
