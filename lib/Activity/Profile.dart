import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:wareg_app/Controller/PrefController.dart';
import 'package:intl/intl.dart';
import '../Controller/MapsController.dart';
import '../Controller/transaction_controller.dart';
import '../Services/message_service.dart';
import '../Util/Ip.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var prefController = Get.put(PrefController());

  @override
  void initState() {
    super.initState();
    Get.put(MessageService()); // Ensure MessageService is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
          color: Colors.black,
        ),
        title: const Center(
          child: Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/notifications");
            },
            icon: const Icon(Icons.notifications),
            color: Colors.black,
          ),
        ],
      ),
      body: Column(
        children: [
          CardExample(),
          const Expanded(child: NavigationMenu()),
        ],
      ),
    );
  }
}

class CardExample extends StatelessWidget {
  CardExample({super.key});
  final PrefController prefController = Get.put(PrefController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: prefController.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading user data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No user data found'));
        } else {
          var userData = snapshot.data!;
          return Center(
            child: Card(
              color: const Color(0xFF307A59),
              margin: const EdgeInsets.all(13.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(userData['profilePicture']!),
                            radius: 30,
                          ),
                          title: Text(
                            userData['name']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['gender']!,
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                userData['email']!,
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            // Handle edit button press
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final PageController _pageController = PageController();
  String _activeButton = 'Riwayat';

  void _onButtonPressed(String label) {
    setState(() {
      _activeButton = label;
      _pageController.jumpToPage(_getPageIndex(label));
    });
  }

  int _getPageIndex(String label) {
    switch (label) {
      case 'Riwayat':
        return 0;
      case 'Point':
        return 1;
      case 'Pesan':
        return 2;
      default:
        return 0;
    }
  }

  String _getPageLabel(int index) {
    switch (index) {
      case 0:
        return 'Riwayat';
      case 1:
        return 'Point';
      case 2:
        return 'Pesan';
      default:
        return 'Riwayat';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = const Color(0xFF307A59);
    return Column(
      children: [
        const SizedBox(height: 16),
        ButtonSection(
          activeButton: _activeButton,
          color: color,
          onButtonPressed: _onButtonPressed,
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _activeButton = _getPageLabel(index);
              });
            },
            children: <Widget>[
              RiwayatList(),
              const Center(child: Text('Content for Point')),
              const ChatContent(),
            ],
          ),
        ),
      ],
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({
    super.key,
    required this.activeButton,
    required this.color,
    required this.onButtonPressed,
  });

  final String activeButton;
  final Color color;
  final Function(String) onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonWithText(
            color: color,
            label: 'Riwayat',
            isActive: activeButton == 'Riwayat',
            onPressed: () => onButtonPressed('Riwayat'),
          ),
          ButtonWithText(
            color: color,
            label: 'Point',
            isActive: activeButton == 'Point',
            onPressed: () => onButtonPressed('Point'),
          ),
          ButtonWithText(
            color: color,
            label: 'Pesan',
            isActive: activeButton == 'Pesan',
            onPressed: () => onButtonPressed('Pesan'),
          ),
        ],
      ),
    );
  }
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  final Color color;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isActive ? color : Colors.black,
              ),
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 20,
              color: color,
            ),
        ],
      ),
    );
  }
}

class RiwayatList extends StatelessWidget {
  RiwayatList({super.key});
  MapsController mpController = Get.put(MapsController());
  final TransactionController transactionController =
      Get.put(TransactionController());

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final DateFormat formatter = DateFormat('EEEE, dd MMM yyyy - HH:mm', 'id');
    return formatter.format(date);
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String translateRole(String role) {
    if (role == 'recipient') {
      return 'Sebagai Penerima';
    } else if (role == 'donor') {
      return 'Sebagai Pendonasi';
    } else {
      return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (transactionController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (transactionController.transactions.isEmpty) {
        return Center(child: Text('No transactions found.'));
      }

      return Container(
        color: Colors.grey[200],
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
          itemCount: transactionController.transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactionController.transactions[index];
            final postMediaUrls =
                (transaction['postMedia'] as List<dynamic>).map((media) {
              return media['url'].toString().replaceFirst(
                  'http://localhost:3000',
                  '${Ip().getType()}://${Ip().getIp()}');
            }).toList();
            final postTitle = transaction['postTitle'];
            final totalJumlah = transaction['detail'].fold<int>(
                0, (int sum, dynamic item) => sum + (item['jumlah'] as int));
            final updatedAt = formatDate(transaction['updatedAt']);
            final review = transaction['review'] != null
                ? transaction['review'].toString() + '/5'
                : 'No review';
            final role = translateRole(transaction['role']);
            final status = capitalize(transaction['status']);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          role,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          updatedAt,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          postTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              review,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            if (transaction['review'] != null)
                              Icon(Icons.star, color: Colors.yellow, size: 16),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: postMediaUrls.map((url) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: SpinKitCircle(
                                        color: Color.fromRGBO(48, 122, 99, 1),
                                        size: 50.0,
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  );
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Jumlah: $totalJumlah',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    if (role == 'Sebagai Penerima' &&
                        status.toLowerCase() == 'ongoing')
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            mpController.map_dataTarget['url'] =
                                transaction['postMedia'][0]['url'];
                            mpController.map_dataTarget['id'] =
                                transaction['postId'];
                            mpController.map_dataTarget['title'] =
                                transaction['postTitle'];
                            mpController.target_lat = double.parse(
                                transaction['postBody']['coordinate']
                                    .toString()
                                    .split(",")[0]);
                            mpController.target_long = double.parse(
                                transaction['postBody']['coordinate']
                                    .toString()
                                    .split(",")[1]);
                            mpController.map_dataTarget['donatur_name'] =
                                transaction['otherUserName'];
                            mpController.map_dataTarget['userId'] =
                                transaction['otherUserId'];
                            Navigator.pushNamed(context, "/onmap");
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class ChatContent extends StatefulWidget {
  const ChatContent({Key? key}) : super(key: key);

  @override
  _ChatContentState createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  MapsController mpController = Get.put(MapsController());
  final MessageService _messageService = Get.put(MessageService());
  List<dynamic>? conversations;
  bool isLoading = true;
  final ipAdd = Ip();

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    try {
      conversations = await _messageService.getConversations();
    } catch (e) {
      print('Failed to fetch conversations: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatMessage(String? message) {
    if (message == null) {
      return "mengirim file";
    }
    if (message.length > 30) {
      return message.substring(0, 30) + "...";
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (conversations == null || conversations!.isEmpty) {
      return Center(child: Text('No conversations found.'));
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: ListView.builder(
        itemCount: conversations!.length,
        itemBuilder: (context, index) {
          final conversation = conversations![index];
          final otherUser = conversation['otherUser'];
          final lastMessage = conversation['lastMessage'];
          final lastMessageTime = lastMessage['timestamp'] != null
              ? DateFormat('hh:mm a')
                  .format(DateTime.parse(lastMessage['timestamp']).toLocal())
              : '';
          final truncatedMessage = formatMessage(lastMessage['message']);

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(otherUser['profile_picture']
                  .toString()
                  .replaceFirst('http://localhost:3000',
                      '${ipAdd.getType()}://${ipAdd.getIp()}')),
            ),
            title: Text(otherUser['username']),
            subtitle: Text(truncatedMessage),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (conversation['unreadMessagesCount'] > 0)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      conversation['unreadMessagesCount'].toString(),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                Text(
                  lastMessageTime,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            onTap: () {
              mpController.map_dataTarget['userId'] = otherUser['id'];
              mpController.map_dataTarget['donatur_name'] =
                  otherUser['username'];
              Navigator.pushNamed(
                context,
                "/chat",
                arguments: {
                  'userId': otherUser['id'],
                  'donatur_name': otherUser['username'],
                },
              );
            },
          );
        },
      ),
    );
  }
}
