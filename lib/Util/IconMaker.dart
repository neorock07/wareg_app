import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconMaker extends StatelessWidget {
const IconMaker({ super.key, required this.link  });
  
  final String link;  
  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 60.dm,
      width: 60.dm,
      child: Stack(
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
    );
  }
}