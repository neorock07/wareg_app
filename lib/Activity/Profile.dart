import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wareg_app/Controller/PrefController.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var prefController = Get.put(PrefController());

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
            const CardExample(),
            const NavigationMenu(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Profile"),
                  ElevatedButton(
                    onPressed: () {
                      prefController.clearData().then((value) {
                        Navigator.pushReplacementNamed(context, "/login");
                      });
                    },
                    child: const Text("Logout"),
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

class CardExample extends StatelessWidget {
  const CardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color(0xFF307A59),
        margin: const EdgeInsets.all(13.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                alignment: Alignment.topRight,
                children: [
                  const ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('images/profile.jpg'),
                    ),
                    title: Text(
                      'Ganjar Pranowo',
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
                          'Semarang, Jawa Tengah, Indonesia',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          '5 makanan terdonasikan',
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
}

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final PageController _pageController = PageController();
  String _activeButton = 'Profil';

  void _onButtonPressed(String label) {
    setState(() {
      _activeButton = label;
      _pageController.jumpToPage(_getPageIndex(label));
    });
  }

  int _getPageIndex(String label) {
    switch (label) {
      case 'Profil':
        return 0;
      case 'Riwayat':
        return 1;
      case 'Point':
        return 2;
      case 'Pesan':
        return 3;
      default:
        return 0;
    }
  }

  String _getPageLabel(int index) {
    switch (index) {
      case 0:
        return 'Profil';
      case 1:
        return 'Riwayat';
      case 2:
        return 'Point';
      case 3:
        return 'Pesan';
      default:
        return 'Profil';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = const Color(0xFF307A59);
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const SizedBox(height: 16),
        ButtonSection(
          activeButton: _activeButton,
          color: color,
          onButtonPressed: _onButtonPressed,
        ),
        SizedBox(
          height: screenHeight - 176, // Set height for the PageView
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _activeButton = _getPageLabel(index);
              });
            },
            children: _buildPages(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPages() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextSection(
            title: 'Deskripsi',
            content:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec lectus sit amet augue dapibus hendrerit at sed ex. Duis varius nisi at aliquet porttitor.',
          ),
          const SizedBox(height: 16),
          const TextSection(
            title: 'Informasi Kontak',
            content:
                'Email: ganjar@example.com\nTelepon: +62 123 4567\nAlamat: Jl. Contoh No. 123, Semarang',
          ),
        ],
      ),
      const NotificationList(),
      const NotificationList(),
      const NotificationList(),
    ];
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
            label: 'Profil',
            isActive: activeButton == 'Profil',
            onPressed: () => onButtonPressed('Profil'),
          ),
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

class TextSection extends StatelessWidget {
  const TextSection({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        Card(
          child: ListTile(
            leading: Icon(Icons.notifications_sharp),
            title: Text('Notification 1'),
            subtitle: Text('This is a notification'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.notifications_sharp),
            title: Text('Notification 2'),
            subtitle: Text('This is a notification'),
          ),
        ),
      ],
    );
  }
}
