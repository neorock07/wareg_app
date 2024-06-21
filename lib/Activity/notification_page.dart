import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../Controller/notification_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    notificationController.fetchNotifications();
    notificationController.checkNotification();
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final DateFormat formatter = DateFormat('EEEE, dd MMM yyyy - HH:mm', 'id');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
              fontFamily: "Bree", color: Colors.black, fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/notifications");
            },
            icon: const Icon(
              LucideIcons.bell,
              color: Colors.black,
            ),
          ),
          if (notificationController.hasUnread.value)
            Positioned(
              right: 11,
              top: 11,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      body: Obx(() {
        if (notificationController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (notificationController.notifications.isEmpty) {
          return Center(child: Text('No notifications found.'));
        } else {
          return ListView.builder(
            itemCount: notificationController.notifications.length,
            itemBuilder: (context, index) {
              final notification = notificationController.notifications[index];
              final createdAt = formatDate(notification['createdAt']);
              final isRead = notification['isRead'];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: Color.fromRGBO(48, 122, 89, 1),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        notification['name'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        notification['data']['message'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          createdAt,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
