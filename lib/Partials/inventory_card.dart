import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:wareg_app/Util/Ip.dart';

class InventoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function() onDelete;
  final Function(Map<String, dynamic>) onUpdate;
  final Ip ipAdd = Ip();

  InventoryCard(
      {required this.item, required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    final name = item['name'] ?? 'Unnamed Item';
    final quantity = item['quantity'].toString();
    final expiredAt = item['expiredAt'] != null
        ? dateFormatter.format(DateTime.parse(item['expiredAt']).toLocal())
        : 'No expiration date';
    final imageUrl = _getFormattedFilePath(item['image'] ?? '');

    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Container(
                      width: 80,
                      height: 80,
                      child: Center(
                        child: SpinKitCircle(
                          color: Colors.green,
                          size: 30.0,
                        ),
                      ),
                    );
                  }
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$quantity Pcs',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text('Tanggal Kadaluwarsa:'),
                  Text(
                    expiredAt,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                  onPressed: () {
                    _showEditDialog(context, item);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> item) {
    TextEditingController quantityController =
        TextEditingController(text: item['quantity'].toString());
    TextEditingController dateController = TextEditingController(
      text: item['expiredAt'] != null
          ? DateFormat('dd/MM/yyyy HH:mm:ss')
              .format(DateTime.parse(item['expiredAt']).toLocal())
          : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item['name'] ?? 'Unnamed Item'),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Expired At'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      DateTime finalDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      dateController.text = DateFormat('dd/MM/yyyy HH:mm:ss')
                          .format(finalDateTime);
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Map<String, dynamic> updatedItem = {
                  'id': item['id'],
                  'name': item['name'],
                  'quantity': int.parse(quantityController.text),
                  'expiredAt': DateFormat("yyyy-MM-ddTHH:mm").format(
                      DateFormat('dd/MM/yyyy HH:mm:ss')
                          .parse(dateController.text)),
                };
                onUpdate(updatedItem);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String _getFormattedFilePath(String filePath) {
    if (filePath.contains('http://localhost:3000')) {
      return filePath.replaceFirst(
          'http://localhost:3000', '${ipAdd.getType()}://${ipAdd.getIp()}');
    }
    return filePath;
  }
}
