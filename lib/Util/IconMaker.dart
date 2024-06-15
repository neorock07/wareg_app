import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconMaker extends StatelessWidget {
const IconMaker({ super.key, required this.link, required this.title });
  
  final String link;
  final String title;  
  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 66.dm,
      width: 66.dm,
      child: Column(
        children: [
          Container(
            height: 15.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.dm),
              color: Colors.white
            ),
            child: Align(
              alignment: Alignment.center,
              child: Center(
                child: Text("$title", style: TextStyle(
                  fontFamily: "Poppins",
                  
                ),),
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                height: 50.dm,
                width: 50.dm,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.dm),
                  color: const Color.fromRGBO(42, 122, 89, 1),
                ),
                child: Center(
                  child: Container(
                    height: 45.dm,
                  width: 45.dm,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.dm),
                    color: const Color.fromRGBO(42, 122, 89, 1),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(link, scale: 1)
                      )
                  ),
                  ),
                ),
              ),
            ],  
          ),
        ],
      ),
    );
  }
}