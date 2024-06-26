import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget FormText(BuildContext context,
    {TextEditingController? controller,
    String? label,
    String? hint,
    double? radius = 0,
    TextInputType? type,
    bool? isEnabled = true,
    GlobalKey<FormState>? key}) {
  return Column(children: [
    Padding(
      padding: EdgeInsets.only(left: 10.w, bottom: 5.h),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text("$label",
            style: TextStyle(
                color: Colors.grey,
                fontFamily: "Poppins",
                fontWeight: FontWeight.normal,
                fontSize: 12.sp)),
      ),
    ),
    Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius!),
            border: Border.all(color: Colors.grey),
            color: Color.fromRGBO(251, 251, 251, 1)),
        child: Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: TextFormField(
              validator: (String? sr) {
                  String pattern =
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

                RegExp regex = RegExp(pattern);

                if (!regex.hasMatch(sr!) && label == "Email") {
                  return 'Masukkan alamat email yang valid!';
                } else {
                  if (sr == null || sr.isEmpty) {
                    return 'Tidak boleh kosong!';
                  }
                }
                
                return null;
              },
              enabled: isEnabled,
              keyboardType: (type == null && type != TextInputType.multiline)
                  ? null
                  : type,
              maxLines: (type != TextInputType.multiline) ? null : 4,
              controller: controller,
              decoration: InputDecoration(
                hintText: "$hint",
              ),
              style: TextStyle(
                  fontFamily: "Poppins", fontSize: 14.sp, color: Colors.black)),
        ))
  ]);
}
