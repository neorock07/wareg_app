import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wareg_app/Controller/PasswordController.dart';

var passController = Get.put(PasswordController());

Widget CardPassword(BuildContext context,
    {String? label,
    GlobalKey<FormState>? key,
    String? hint,
    bool? isBorder = false,  
    TextInputType? type,
    RxBool? isObscure,
    TextEditingController? controller}) {
  return Column(
    children: [
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
            border: (isBorder == true)? Border.all(color: Colors.grey) : null,
            color: const Color.fromRGBO(242, 243, 243, 1),
            borderRadius: BorderRadius.circular(5.dm)),
        child: Padding(
          padding: EdgeInsets.all(5.dm),
          child: TextFormField(
              obscureText: !passController.visibility.value,
              validator: (String? sr) {
                if (sr == null || sr.isEmpty || sr.length < 8) {
                  return 'Tidak boleh kosong dan minimal 8 karakter!';
                }
                return null;
              },
              keyboardType: (type == null) ? null : type,
              controller: controller,
              decoration: InputDecoration(
                hintText: (hint != null) ? "$hint" : "",
                suffixIcon: IconButton(
                  icon: Icon(
                    (isObscure!.value == true)
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    isObscure!.value = !isObscure!.value;
                    passController.visibility.value = !passController.visibility.value;
                  },
                ),
              ),
              style: TextStyle(
                  fontFamily: "Poppins", fontSize: 14.sp, color: Colors.black)),
        ),
      )
    ],
  );
}
