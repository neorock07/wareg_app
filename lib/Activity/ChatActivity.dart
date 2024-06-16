import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import '../Controller/MapsController.dart';
import '../Controller/message_controller.dart';
import 'package:image_picker/image_picker.dart';
import '../Util/Ip.dart';

class ChatActivity extends StatefulWidget {
  @override
  _ChatActivityState createState() => _ChatActivityState();
}

class _ChatActivityState extends State<ChatActivity> {
  MapsController mpController = Get.put(MapsController());
  final TextEditingController _controller = TextEditingController();
  final MessageController _messageController = Get.put(MessageController());
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  final ipAdd = Ip();
  bool _isListenerInitialized = false;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token");
      _messageController.saveFcmToken(token);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _fetchMessages();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isListenerInitialized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("Message received. ${message.notification?.body}");
        _messageController.appendMessage(message.data);
        _scrollToBottom();
      });
      _isListenerInitialized = true;
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    // Add logic to handle background messages here
  }

  Future<void> _fetchMessages() async {
    await _messageController
        .fetchMessages(mpController.map_dataTarget['userId']);
    _scrollToBottom();
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      _messageController
          .sendMessage(message, mpController.map_dataTarget['userId'])
          .then((_) {
        _scrollToBottom();
      });
      _controller.clear();
    }
  }

  void _sendFile(String filePath) {
    _messageController
        .sendFile(filePath, mpController.map_dataTarget['userId'])
        .then((_) {
      _scrollToBottom();
    });
  }

  Future<void> _pickFile(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _sendFile(pickedFile.path);
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () {
                      _pickFile(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _pickFile(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTimestamp(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp).toLocal();
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  String _getFormattedFilePath(String filePath) {
    if (filePath.contains('http://localhost:3000')) {
      return filePath.replaceFirst(
          'http://localhost:3000', '${ipAdd.getType()}://${ipAdd.getIp()}');
    }
    return filePath;
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
            mpController.map_dataTarget['donatur_name'],
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
              child: Obx(() {
                if (_messageController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: false,
                    itemCount: _messageController.messages.length,
                    itemBuilder: (context, index) {
                      final message = _messageController.messages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.dm,
                              right: 15.dm,
                              top: 10.dm,
                              bottom: 10.dm),
                          child: Align(
                            alignment: (message['isSentByMe'])
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: (message['isSentByMe'])
                                      ? const Color.fromRGBO(48, 122, 89, 1)
                                      : const Color.fromRGBO(233, 233, 239, 1),
                                  borderRadius: (message['isSentByMe'])
                                      ? BorderRadius.only(
                                          bottomLeft: Radius.circular(10.dm),
                                          topRight: Radius.circular(10.dm),
                                          topLeft: Radius.circular(10.dm),
                                        )
                                      : BorderRadius.only(
                                          topRight: Radius.circular(10.dm),
                                          topLeft: Radius.circular(10.dm),
                                          bottomRight: Radius.circular(10.dm))),
                              child: Padding(
                                padding: EdgeInsets.all(10.dm),
                                child: Column(
                                  crossAxisAlignment: (message['isSentByMe'])
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  mainAxisAlignment: (message['isSentByMe'])
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    if (message['message'] != null &&
                                        message['message'] != '')
                                      Text(
                                        "${message['message']}",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 13.sp,
                                            color: (message['isSentByMe'])
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    if (message['file'] != null &&
                                        message['file'] != '')
                                      Image.network(_getFormattedFilePath(
                                          message['file'])),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          _formatTimestamp(
                                              message['timestamp']),
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 10.sp,
                                            color: (message['isSentByMe'])
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                        ),
                                        Icon(
                                          LucideIcons.checkCheck,
                                          color: Colors.green,
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
                      );
                    },
                  );
                }
              }),
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
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _showPicker(context),
                                icon: const Icon(
                                  LucideIcons.paperclip,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                  onPressed: () =>
                                      _sendMessage(_controller.text),
                                  icon: const Icon(
                                    LucideIcons.send,
                                    size: 25,
                                    color: Colors.green, // Change to green
                                  )),
                            ],
                          )),
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
