import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wareg_app/Controller/PrefController.dart';
import 'package:intl/intl.dart';
import '../Controller/MapsController.dart';
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
            onPressed: () {},
            icon: const Icon(Icons.notifications),
            color: Colors.black,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardExample(), // Removed const
            const NavigationMenu(),
          ],
        ),
      ),
    );
  }
}

class CardExample extends StatelessWidget {
  CardExample({super.key}); // Removed const
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
        SizedBox(
          height: 700, // Set height for the PageView
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _activeButton = _getPageLabel(index);
              });
            },
            children: <Widget>[
              const RiwayatList(),
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
  const RiwayatList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const <Widget>[
          ListTile(
            leading: CircleAvatar(child: Text('A')),
            title: Text('Bakso sisa Kemarin'),
            subtitle: Text('10 Apr 2024 - 14.56'),
            trailing: Icon(Icons.favorite_rounded),
          ),
          ListTile(
            leading: CircleAvatar(child: Text('A')),
            title: Text('Bakso sisa Kemarin'),
            subtitle: Text('10 Apr 2024 - 14.56'),
            trailing: Icon(Icons.favorite_rounded),
          ),
          ListTile(
            leading: CircleAvatar(child: Text('A')),
            title: Text('Bakso sisa Kemarin'),
            subtitle: Text('10 Apr 2024 - 14.56'),
            trailing: Icon(Icons.favorite_rounded),
          ),
          ListTile(
            leading: CircleAvatar(child: Text('A')),
            title: Text('Bakso sisa Kemarin'),
            subtitle: Text('10 Apr 2024 - 14.56'),
            trailing: Icon(Icons.favorite_rounded),
          ),
          ListTile(
            leading: CircleAvatar(child: Text('A')),
            title: Text('Bakso sisa Kemarin'),
            subtitle: Text('10 Apr 2024 - 14.56'),
            trailing: Icon(Icons.favorite_rounded),
          ),
        ],
      ),
    );
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

    return ListView.builder(
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
            mpController.map_dataTarget['donatur_name'] = otherUser['username'];
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
    );
  }
}
