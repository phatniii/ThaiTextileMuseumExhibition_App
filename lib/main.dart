import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> textiles = [
    {'name': 'ผ้าไหม', 'age': '50 ปี', 'category': 'ผ้าไหม'},
    {'name': 'ผ้าฝ้าย', 'age': '20 ปี', 'category': 'ผ้าฝ้าย'},
    {'name': 'ผ้าไทครั่ง', 'age': '100 ปี', 'category': 'ไทครั่ง'}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('นิทรรศการพิพิธภัณฑ์ผ้าไทย', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: textiles.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(textiles[index]['name']),
              onDismissed: (direction) {
                setState(() {
                  textiles.removeAt(index); // ลบรายการเมื่อปัด
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${textiles[index]['name']} ถูกลบ')),
                );
              },
              background: Container(color: Colors.red), // สีพื้นหลังเมื่อปัด
              child: Card(
  margin: EdgeInsets.only(bottom: 16),
  elevation: 5,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: ListTile(
    contentPadding: EdgeInsets.all(16),
    title: Text(
      textiles[index]['name'],
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text('อายุผ้าไทย: ${textiles[index]['age']}'),
        SizedBox(height: 4),
        Text('ประเภท: ${textiles[index]['category']}'),
      ],
    ),
    // ลบลูกศรออกโดยไม่ใส่ `trailing`
    onTap: () {
      // ฟังก์ชันเมื่อคลิกแต่ละรายการ
    },
  ),
),

            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage(onSubmit: (newTextile) {
              setState(() {
                textiles.add(newTextile); // เพิ่มรายการผ้าใหม่
              });
            })),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[600],
      ),
    );
  }
}

class AddPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  AddPage({required this.onSubmit});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _category;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลผ้าไทย'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อผ้าไทย',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อผ้าไทย';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: 'อายุผ้าไทย (ปี)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกอายุผ้าไทย';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'วันที่จัดแสดง',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาเลือกวันที่';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _category,
                    hint: Text('เลือกประเภทผ้าไทย'),
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'กรุณาเลือกประเภทผ้าไทย';
                      }
                      return null;
                    },
                    items: ['ผ้าไหม', 'ผ้าฝ้าย', 'ผ้าไทครั่ง']
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                     //primary: Colors.teal[600],
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> newTextile = {
                          'name': _nameController.text,
                          'age': _ageController.text,
                          'date': _dateController.text,
                          'category': _category,
                        };
                        widget.onSubmit(newTextile);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
