import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wareg_app/Activity/Donasi.dart';
import 'package:wareg_app/Activity/Home.dart';
import 'package:wareg_app/Activity/Inventory.dart';
import 'package:wareg_app/Activity/Menu.dart';
import 'package:wareg_app/Activity/Profile.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({Key? key}) : super(key: key);

  @override
  _BottomNavPageState createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  var selectedTab = 0.obs;

  _setPage(int index) {
    selectedTab.value = index;
  }

  List _pages = [Home(), Menu(), Donasi(), InventoryPage(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _pages[selectedTab.value],
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedTab.value,
              onTap: (index) => _setPage(index),
              selectedItemColor: Color.fromRGBO(48, 122, 89, 1),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: const TextStyle(
                  fontFamily: "Poppins", color: Color.fromRGBO(48, 122, 89, 1)),
              unselectedLabelStyle:
                  const TextStyle(fontFamily: "Poppins", color: Colors.grey),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(LucideIcons.home), label: "Beranda"),
                BottomNavigationBarItem(
                    icon: Icon(LucideIcons.menuSquare), label: "Menu"),
                BottomNavigationBarItem(
                    icon: Icon(LucideIcons.heartHandshake), label: "Donasi"),
                BottomNavigationBarItem(
                    icon: Icon(LucideIcons.boxes), label: "Inventory"),
                BottomNavigationBarItem(
                    icon: Icon(LucideIcons.user), label: "Profile"),
              ]),
        ));
  }
}
