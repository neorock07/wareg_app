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
      body: const SingleChildScrollView(
        child: Column(
          children: [
            CardExample(),
            NavigationMenu(),
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                alignment: Alignment.topRight,
                children: [
                  const ListTile(
                    leading: CircleAvatar(
                      child: Text('G'),
                      radius: 30,
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
            children: const <Widget>[
              ProfilContent(
                heading1: 'Deskripsi',
                isi_heading1:
                    'Lake Oeschinen lies at the foot of the Blüemlisalp in the '
                    'Bernese Alps. Situated 1,578 meters above sea level, it '
                    'is one of the larger Alpine Lakes. A gondola ride from '
                    'Kandersteg, followed by a half-hour walk through pastures '
                    'and pine forest, leads you to the lake, which warms to 20 '
                    'degrees Celsius in the summer. Activities enjoyed here '
                    'include rowing, and riding the summer toboggan run.',
                heading2: 'Informasi',
                isi_heading2:
                    'Lake Oeschinen lies at the foot of the Blüemlisalp in the '
                    'Bernese Alps. Situated 1,578 meters above sea level, it '
                    'is one of the larger Alpine Lakes. A gondola ride from '
                    'Kandersteg, followed by a half-hour walk through pastures '
                    'and pine forest, leads you to the lake, which warms to 20 '
                    'degrees Celsius in the summer. Activities enjoyed here '
                    'include rowing, and riding the summer toboggan run.',
              ),
              RiwayatList(),
              Center(child: Text('Content for Point')),
              Center(child: Text('Content for Pesan')),
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

class ProfilContent extends StatelessWidget {
  const ProfilContent({
    super.key,
    required this.heading1,
    required this.isi_heading1,
    required this.heading2,
    required this.isi_heading2,
  });

  final String heading1;
  final String isi_heading1;
  final String heading2;
  final String isi_heading2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    heading1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  isi_heading1,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    heading2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  isi_heading2,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
