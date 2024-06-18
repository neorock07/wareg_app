import 'package:flutter/material.dart';


class ResepForm extends StatefulWidget {
  @override
  _ResepFormState createState() => _ResepFormState();
}

class _ResepFormState extends State<ResepForm> {
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> quantityControllers = [];
  List<String> units = [];

  @override
  void initState() {
    super.initState();
    addTextField();
  }

  void addTextField() {
    setState(() {
      nameControllers.add(TextEditingController());
      quantityControllers.add(TextEditingController());
      units.add('kg');
    });
  }

  @override
  void dispose() {
    for (var controller in nameControllers) {
      controller.dispose();
    }
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Masukkan Bahan Baku', style: TextStyle(color: Colors.black, fontFamily: "Bree", ),)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: nameControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: nameControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Nama Bahan Baku ${index + 1}',
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: quantityControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Jumlah',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        DropdownButton<String>(
                          value: units[index],
                          items: <String>['kg', 'g', 'l'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              units[index] = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: addTextField,
              icon: Icon(Icons.add),
              label: Text('Tambah Bahan Baku'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
