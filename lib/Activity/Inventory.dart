import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Activity/inventory_form_page.dart';
import 'package:wareg_app/Controller/inventory_controller.dart';
import 'package:wareg_app/Controller/notification_controller.dart';
import 'package:wareg_app/Partials/inventory_card.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final InventoryController inventoryController =
      Get.put(InventoryController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  String currentFilter = 'valid';

  @override
  void initState() {
    super.initState();
    fetchData();
    notificationController.checkNotification();
  }

  Future<void> fetchData() async {
    switch (currentFilter) {
      case 'zero-quantity':
        await inventoryController.fetchInventory('/inventory/zero-quantity');
        break;
      case 'expired':
        await inventoryController.fetchInventory('/inventory/expired');
        break;
      default:
        await inventoryController.fetchInventory('/inventory/valid');
    }
  }

  void _onFormSubmit() {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: Center(
          child: const Text(
            'Inventory',
            style: TextStyle(color: Colors.black, fontFamily: "Poppins"),
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
                              fontSize: 8.sp,
                              fontFamily: "Poppins"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              )),
          SizedBox(
            width: 5,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFilterButton('Terbaru', 'valid'),
              _buildFilterButton('Habis', 'zero-quantity'),
              _buildFilterButton('Expired', 'expired'),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (inventoryController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (inventoryController.items.isEmpty) {
          return Center(
              child: Text(
            'No items found.',
            style: TextStyle(fontSize: 14.sp, fontFamily: "Poppins"),
          ));
        } else {
          return ListView.builder(
            itemCount: inventoryController.items.length,
            itemBuilder: (context, index) {
              final item = inventoryController.items[index];
              return InventoryCard(
                item: item,
                onDelete: () async {
                  await inventoryController.deleteItem(item['id']);
                  await fetchData();
                },
                onUpdate: (updatedItem) async {
                  await inventoryController.updateItem(updatedItem);
                  await fetchData();
                },
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InventoryFormPage(onSubmit: _onFormSubmit),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterButton(String label, String filter) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          currentFilter = filter;
          fetchData();
        });
      },
      style: ElevatedButton.styleFrom(
        primary: currentFilter == filter
            ? Color.fromRGBO(48, 122, 89, 1)
            : Colors.grey,
      ),
      child: Text(label,
          style: TextStyle(
              color: Colors.white, fontFamily: "Poppins", fontSize: 12.sp)),
    );
  }
}
