import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChatActivity extends StatefulWidget {
  @override
  _ChatActivityState createState() => _ChatActivityState();
}

class _ChatActivityState extends State<ChatActivity> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Chat",
          style: TextStyle(
              fontFamily: "Bree", color: Colors.black, fontSize: 18.sp),
        ),
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            "Jokowi",
            style: TextStyle(
                fontFamily: "Bree", color: Colors.black, fontSize: 18.sp),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                LucideIcons.bell,
                color: Colors.black,
              )),
          SizedBox(
            width: 5.dm,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: false,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10.dm, right: 15.dm, top: 10.dm, bottom: 10.dm),
                      child: Align(
                        alignment: (index! % 2 == 0)
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Container(
                          // width: 20.w,
                          decoration: BoxDecoration(
                              color: (index! % 2 == 0)
                                  ? const Color.fromRGBO(48, 122, 89, 1)
                                  : const Color.fromRGBO(233, 233, 239, 1),
                              borderRadius: (index! % 2 == 0)
                                  ? BorderRadius.only(
                                      bottomLeft: Radius.circular(10.dm),
                                      topRight: Radius.circular(10.dm),
                                      topLeft: Radius.circular(10.dm),
                                    )
                                  : BorderRadius.only(
                                      // bottomLeft: Radius.circular(10.dm),
                                      topRight: Radius.circular(10.dm),
                                      topLeft: Radius.circular(10.dm),
                                      bottomRight: Radius.circular(10.dm))),
                          child: Padding(
                            padding: EdgeInsets.all(10.dm),
                            child: Column(
                              crossAxisAlignment: (index %2 == 0)? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              mainAxisAlignment: (index %2 == 0)? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${_messages![index!]}",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 13.sp,
                                      color: (index! % 2 == 0)
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "20:43 AM",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 10.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Icon(
                                      LucideIcons.checkCheck,
                                      color: Colors.blue,
                                      size: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // LayoutBuilder(
                    //   builder: (context, constraints) {
                    //     return Container(
                    //       // constraints: BoxConstraints(
                    //       //   maxWidth: ,
                    //       // ),
                    //       decoration: BoxDecoration(
                    //         color: const Color.fromRGBO(48, 122, 89, 1),
                    //         borderRadius: BorderRadius.only(
                    //           topLeft: Radius.circular(10.dm),
                    //           topRight: Radius.circular(10.dm),
                    //           bottomLeft: Radius.circular(10.dm),
                    //         ),
                    //       ),
                    //       padding: const EdgeInsets.all(10.0),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.end,
                    //         children: [
                    //           Text(
                    //             _messages[index],
                    //             style: TextStyle(
                    //               fontFamily: "Poppins",
                    //               fontSize: 12.sp,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //           SizedBox(height: 5.sp),
                    //           Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.end,
                    //             children: [
                    //               Text(
                    //                 "20:43 AM",
                    //                 style: TextStyle(
                    //                   fontFamily: "Poppins",
                    //                   fontSize: 10.sp,
                    //                   color: Colors.grey,
                    //                 ),
                    //               ),
                    //               Icon(
                    //                 LucideIcons.checkCheck,
                    //                 color: Colors.blue,
                    //                 size: 10,
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 234, 238, 1),
                        borderRadius: BorderRadius.circular(30.dm)),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                          fontSize: 14.sp),
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 5,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 10.w, top: 10.h),
                          border: InputBorder.none,
                          hintText: "halo ?",
                          suffixIcon: IconButton(
                              onPressed: _sendMessage,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(48, 122, 89, 1)),
                              ),
                              icon: const Icon(
                                LucideIcons.send,
                                size: 25,
                                color: Colors.white,
                              ))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
