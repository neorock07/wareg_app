import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget CardTextField(BuildContext context, {
  String? label,
  GlobalKey<FormState>? key,
  String? hint,
  TextInputType? type,
  TextEditingController? controller
}){
    return Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1, bottom: 5.h),
              child: Text("$label", style: TextStyle(
                fontFamily: "Poppins", 
                color: Colors.grey, 
                fontSize: 12.sp
              ),),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(242, 243, 243, 1), 
              borderRadius: BorderRadius.circular(5.dm)
            ),
            child: Padding(
              padding: EdgeInsets.all(5.dm), 
              child: TextFormField(
              validator: (String? sr) {
                if (sr == null || sr.isEmpty) {
                  return 'Tidak boleh kosong!';
                }
                return null;
              },
              keyboardType: (type == null)
                  ? null
                  : type,
              controller: controller,
              decoration: InputDecoration(
                hintText: (hint != null)? "$hint" : "",
              ),  
              style: TextStyle(
                  fontFamily: "Poppins", fontSize: 14.sp, color: Colors.black)),
              ),
          )
        ],
    );
}