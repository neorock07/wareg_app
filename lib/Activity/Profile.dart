import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Controller/API/Postingan/GetByLokasi.dart';
import 'package:wareg_app/Controller/API/Transaksi/TransaksiController.dart';
import 'package:wareg_app/Controller/PrefController.dart';
import 'package:intl/intl.dart';
import 'package:wareg_app/Controller/notification_controller.dart';
import 'package:wareg_app/Partials/CardButton.dart';
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
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    Get.put(MessageService());
    notificationController.checkNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, "/home");
          },
          color: Colors.black,
        ),
        title: const Center(
          child: Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          Obx(() => Stack(
                children: [
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
              )),
          SizedBox(
            width: 5.dm,
          )
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

class CardExample extends StatefulWidget {
  CardExample({super.key});

  @override
  _CardExampleState createState() => _CardExampleState();
}

class _CardExampleState extends State<CardExample> {
  final PrefController prefController = Get.put(PrefController());
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  final TextEditingController _nameController = TextEditingController();
  bool _isEditingName = false;
  RxBool isPressed = false.obs;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var userData = await prefController.getUserData();
    log(userData['profilePicture'].toString());
    if (userData.isNotEmpty) {
      setState(() {
        _nameController.text = userData['name'] ?? '';
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
    if (_imageFile != null) {
      await _uploadProfilePicture(_imageFile!);
    }
  }

  Future<void> _uploadProfilePicture(File image) async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/users/profile/picture'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files
        .add(await http.MultipartFile.fromPath('profile_picture', image.path));

    var response = await request.send();
    if (response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);
      if (jsonResponse['success']) {
        String newProfilePicture = jsonResponse['newProfilePicture'].toString();
        setState(() {
          prefController.setProfilePicture(newProfilePicture);
        });
        await prefs.setString('profile_picture', newProfilePicture);
        print('Profile picture updated successfully');
      }
    } else {
      print('Failed to update profile picture');
    }
  }

  Future<void> _updateUserName() async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    var response = await http.put(
      Uri.parse('$_baseUrl/users/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': _nameController.text}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        prefController.setName(jsonResponse['name']);
      });
      await prefs.setString('user_name', jsonResponse['name']);
      print('Name updated successfully');
    } else {
      print('Failed to update name');
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';

    await http.post(
      Uri.parse('$_baseUrl/auth/logout'),
      headers: {'Authorization': 'Bearer ${prefs.getString('token')}'},
    );
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    var ipAdd = Ip();
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
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Card(
                color: Color.fromRGBO(48, 122, 89, 1),
                margin: const EdgeInsets.all(13.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: _pickImage,
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                          child: ClipOval(
                                            child: _imageFile != null
                                                ? Image.file(
                                                    _imageFile!,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    userData['profilePicture']!,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Align text to the start
                                        children: [
                                          if (_isEditingName)
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    200, // Set a maximum width for the text field
                                              ),
                                              child: TextField(
                                                controller: _nameController,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                onSubmitted: (value) {
                                                  _updateUserName();
                                                  setState(() {
                                                    _isEditingName = false;
                                                  });
                                                },
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      "Enter your name", // Optional: placeholder text
                                                  hintStyle: TextStyle(
                                                      color: Colors.white30),
                                                ),
                                              ),
                                            )
                                          else
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isEditingName = true;
                                                });
                                              },
                                              child: Text(
                                                _nameController.text.isEmpty
                                                    ? "Tap to edit name"
                                                    : _nameController
                                                        .text, // Show a placeholder if no name
                                                style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          const SizedBox(height: 5),
                                          Text(
                                            userData['gender']!,
                                            style: const TextStyle(
                                                fontFamily: "Poppins",
                                                color: Colors.white70),
                                          ),
                                          Text(
                                              userData['email']!,
                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Colors.white70),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Obx(() => CardButton(
                                          context, isPressed,
                                          width_a: 0.78,
                                          width_b: 0.8,
                                          height_a: 0.05,
                                          height_b: 0.06,
                                          borderRadius: 10,
                                          color: Colors.white, onTap: (_) {
                                        isPressed.value = true;
                                        _logout();
                                        log("ini coeg");
                                      },
                                          child: Center(
                                              child: Text("Logout",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "Poppins",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ))))),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _isEditingName = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
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
  String _activeButton = 'Post';

  void _onButtonPressed(String label) {
    setState(() {
      _activeButton = label;
      _pageController.jumpToPage(_getPageIndex(label));
    });
  }

  int _getPageIndex(String label) {
    switch (label) {
      case 'Post':
        return 0;
      case 'Point':
        return 1;
      case 'Pesan':
        return 2;
      case 'Riwayat':
        return 3;
      default:
        return 0;
    }
  }

  String _getPageLabel(int index) {
    switch (index) {
      case 0:
        return 'Post';
      case 1:
        return 'Point';
      case 2:
        return 'Pesan';
      case 3:
        return 'Riwayat';
      default:
        return 'Post';
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
        const SizedBox(height: 5),
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
              const UserPostsPage(),
              const PointPage(),
              const ChatContent(),
              const RiwayatList(),
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
            label: 'Post',
            isActive: activeButton == 'Post',
            onPressed: () => onButtonPressed('Post'),
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
          ButtonWithText(
            color: color,
            label: 'Riwayat',
            isActive: activeButton == 'Riwayat',
            onPressed: () => onButtonPressed('Riwayat'),
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

class RiwayatList extends StatefulWidget {
  const RiwayatList({Key? key}) : super(key: key);
  @override
  _RiwayatListState createState() => _RiwayatListState();
}

class _RiwayatListState extends State<RiwayatList> {
  MapsController mpController = Get.put(MapsController());
  final TransactionController transactionController =
      Get.put(TransactionController());
  var transaksiKon = Get.put(TransaksiController());

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
  void initState() {
    super.initState();
    transactionController.fetchTransactions();
  }

  Future<void> _refreshTransactions() async {
    await transactionController.fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        transactionController.fetchTransactions(); // Fetch data again
        return true;
      },
      child: Obx(() {
        if (transactionController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (transactionController.transactions.isEmpty) {
          return Center(child: Text('No transactions found.'));
        }

        return RefreshIndicator(
          onRefresh: _refreshTransactions,
          child: Container(
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
                final totalJumlah = transaction['detail'].fold<int>(0,
                    (int sum, dynamic item) => sum + (item['jumlah'] as int));
                final updatedAt = formatDate(transaction['updatedAt']);
                final review = transaction['review'] != null
                    ? transaction['review'].toString() + '/5'
                    : 'No review';
                final role = translateRole(transaction['role']);
                final status = capitalize(transaction['status']);

                return InkWell(
                  onTap: () {
                    if (role == 'Sebagai Penerima' &&
                        status.toLowerCase() == 'ongoing') {
                      mpController.map_dataTarget['url'] =
                          transaction['postMedia'][0]['url'];
                      mpController.map_dataTarget['id'] = transaction['postId'];
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
                      Navigator.pushNamed(context, "/onmap").then(
                          (_) => transactionController.fetchTransactions());
                    } else if (role == 'Sebagai Pendonasi' &&
                        status.toLowerCase() == 'ongoing') {
                      transaksiKon.transaksi_id = transaction['id'];
                      Navigator.pushNamed(context, "/onmap_donor").then((_) =>
                          transaksiKon.getTransaksiDonor(transaction['id']));
                    } else {
                      transaksiKon.transaksi_id = transaction['id'];
                      Navigator.pushNamed(context, "/completed");
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.dm),
                    child: Container(
                      // margin: const EdgeInsets.symmetric(
                      //     vertical: 10, horizontal: 15),
                      // color: Colors.white,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.dm)),
                      child: Padding(
                        padding: EdgeInsets.all(10.dm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  role,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                      fontFamily: "Poppins"),
                                ),
                                Text(
                                  updatedAt,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                      fontFamily: "Poppins"),
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
                                      fontSize: 16.sp,
                                      fontFamily: "Poppins"),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      review,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: "Poppins"),
                                    ),
                                    if (transaction['review'] != null)
                                      Icon(Icons.star,
                                          color: Colors.yellow, size: 16),
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
                                                color: Color.fromRGBO(
                                                    48, 122, 99, 1),
                                                size: 50.0,
                                              ),
                                            );
                                          }
                                        },
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
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
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.circular(10.dm)),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.dm),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                          fontFamily: "Poppins"),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Jumlah: $totalJumlah',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: "Poppins"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
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

  Future<void> _refreshConversations() async {
    setState(() {
      isLoading = true;
    });
    await fetchConversations();
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

    return RefreshIndicator(
      onRefresh: _refreshConversations,
      child: Padding(
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
              title: Text(otherUser['username'],
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12.sp,
                  )),
              subtitle: Text(truncatedMessage,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12.sp,
                  )),
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
      ),
    );
  }
}

class PointPage extends StatefulWidget {
  const PointPage({Key? key}) : super(key: key);
  @override
  _PointPageState createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  int points = 0;
  int initialLimit = 0;
  int currentLimit = 0;
  int todayLimit = 0;
  int neededPoints = 0;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await fetchPoints();
    await fetchInitialLimit();
  }

  Future<void> fetchPoints() async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$_baseUrl/points'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        points = json.decode(response.body)['points'];
      });
    } else {
      print('Failed to load points');
    }
  }

  Future<void> fetchInitialLimit() async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$_baseUrl/points/extend'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        initialLimit = json.decode(response.body)['message'];
        currentLimit = initialLimit;
        todayLimit = json.decode(response.body)['current'];
      });
    } else {
      print('Failed to load initial limit');
    }
  }

  Future<void> exchangePoints() async {
    var ipAdd = Ip();
    String? _baseUrl = '${ipAdd.getType()}://${ipAdd.getIp()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    for (int i = 0; i < (currentLimit - initialLimit); i++) {
      final response = await http.post(
        Uri.parse('$_baseUrl/points/extend'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'amount': 20}),
      );

      if (response.statusCode == 201) {
        print('Points exchanged successfully');
      } else {
        print('Failed to exchange points');
        return;
      }
    }

    // Fetch points and limit again to update UI
    await fetchPoints();
    await fetchInitialLimit();
  }

  Future<void> _showConfirmationDialog() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Tambah Limit'),
          content: Text(
              'Apakah anda yakin ingin menambah sebanyak ${currentLimit - initialLimit} limit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Ya'),
            ),
          ],
        );
      },
    );

    if (confirmed) {
      await exchangePoints();
      setState(() {
        neededPoints = 0;
      });
    }
  }

  Future<void> _refreshPoints() async {
    await fetchPoints();
    await fetchInitialLimit();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPoints,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Point Anda',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '$points Point',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: "Poppins",
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      LucideIcons.checkCircle,
                      color: Colors.green,
                      size: 24.sp,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'Tambah limit pengambilan anda dengan tukarkan point yang didapat, per 1 kali kesempatan senilai 20 point.',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tambah Limit',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (currentLimit > initialLimit) {
                          setState(() {
                            currentLimit--;
                            neededPoints -= 20;
                          });
                        }
                      },
                      icon: Icon(Icons.remove_circle_outline),
                      color: Colors.black,
                    ),
                    Text(
                      '$currentLimit',
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentLimit++;
                          neededPoints += 20;
                        });
                      },
                      icon: Icon(Icons.add_circle_outline),
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Jumlah limit pengambilan Anda saat ini : $initialLimit/hari',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Limit pengambilan Anda hari ini : $todayLimit',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '*Jumlah limit pengambilan yang ditambah hanya berlaku selama 1 minggu.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 16.h),
            Column(
              children: [
                Text(
                  'Total point yang dibutuhkan : $neededPoints',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 8.h),
                ElevatedButton.icon(
                  onPressed: points >= neededPoints && neededPoints > 0
                      ? () async {
                          await _showConfirmationDialog();
                        }
                      : null,
                  icon: Icon(
                    LucideIcons.checkCircle,
                    size: 20.sp,
                  ),
                  label: Text(
                    'Tukarkan Point',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: "Poppins",
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF307A59), // Background color
                    onPrimary: Colors.white, // Text color
                    minimumSize:
                        Size(double.infinity, 36.h), // Full width button
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserPostsPage extends StatefulWidget {
  const UserPostsPage({Key? key}) : super(key: key);

  @override
  _UserPostsPageState createState() => _UserPostsPageState();
}

class _UserPostsPageState extends State<UserPostsPage> {
  final GetPostController postController = Get.put(GetPostController());

  @override
  void initState() {
    super.initState();
    postController.fetchPostUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (postController.isLoading5.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              await postController.fetchPostUser();
            },
            child: postController.posts5.isEmpty
                ? Center(child: Text('No posts found.'))
                : ListView.builder(
                    itemCount: postController.posts5.length,
                    itemBuilder: (context, index) {
                      final post = postController.posts5[index];
                      final createdAt = DateFormat('dd/MM/yyyy HH:mm:ss')
                          .format(DateTime.parse(post['createdAt']).toLocal());
                      final expiredAt = DateFormat('dd/MM/yyyy HH:mm:ss')
                          .format(DateTime.parse(post['expiredAt']).toLocal());

                      final mediaUrls = post['media'].isNotEmpty
                          ? (post['media'] as List)
                              .map<String>((media) => (media['url'] as String)
                                  .replaceFirst('http://localhost:3000',
                                      '${Ip().getType()}://${Ip().getIp()}'))
                              .toList()
                          : ['https://via.placeholder.com/150'];

                      return Padding(
                        padding: EdgeInsets.all(10.dm),
                        child: Container(
                          // margin: EdgeInsets.all(10.0),
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post['title'],
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                mediaUrls.length > 1
                                    ? CarouselSlider(
                                        options: CarouselOptions(
                                          height: 150.h,
                                          enlargeCenterPage: true,
                                          autoPlay: true,
                                        ),
                                        items: mediaUrls.map((url) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5.h),
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Image.network(
                                                    url,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Icon(Icons.error),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height: 150.h,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Image.network(
                                            mediaUrls[0],
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'Alamat : ',
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${post['body']['alamat']}',
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12.sp,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Deskripsi : ',
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${post['body']['description']}',
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 12.sp,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Dibuat : ',
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '$createdAt',
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12.sp,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Kadaluarsa : ',
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '$expiredAt',
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12.sp,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        await postController
                                            .deletePost(post['id']);
                                        postController
                                            .fetchPostUser(); // Refresh the list after deletion
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        }
      }),
    );
  }
}
