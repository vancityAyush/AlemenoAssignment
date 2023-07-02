import 'package:Alemeno/gen/colors.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../gen/fonts.gen.dart';
import '../provider/animal_provider.dart';

class MessageScreen extends StatelessWidget {
  final String message;
  const MessageScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<AnimalProvider>(context, listen: false).reset();
        return true;
      }, // Disable back button
      child: Scaffold(
        body: Center(
          child: Text(
            message.tr(),
            style: TextStyle(
              fontSize: 48.sp,
              color: AppColors.accent,
              fontFamily: Fonts.lilitaOne,
              letterSpacing: 10,
            ),
          ),
        ),
      ),
    );
  }
}
