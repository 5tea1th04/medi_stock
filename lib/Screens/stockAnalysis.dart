// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// class StockAnalysis extends StatefulWidget{
//   static String id = "Stock_Screen";
//   const StockAnalysis({super.key});
//
//   @override
//   State<StatefulWidget> createState() {
//     return _StockAnalysis();
//   }
// }
// class _StockAnalysis extends State<StockAnalysis>{
//   final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('items');
//   List<Map<String, dynamic>> _items = [];
//   List<Map<String, dynamic>> _filteredItems = [];
//   TextEditingController _searchController = TextEditingController();
//   @override
//   void initState(){
//     super.initState();
//     _fetchItemsFromDatabase();
//     _searchController.addListener((){
//       _filterItems();
//     });
//   }
//   void _fetchItemsFromDatabase() {
//     _dbRef.onValue.listen((event) {
//       final data = event.snapshot.value as Map<dynamic, dynamic>?;
//       if (data != null) {
//         final List<Map<String, dynamic>> loadedItems = [];
//         data.forEach((key, value) {
//           loadedItems.add({
//             'id': key,
//             'name': value['name'],
//           });
//         });
//         setState(() {
//           _items = loadedItems;
//           _filteredItems = loadedItems; // Initially, show all items
//         });
//       }
//     });
//   }
//   Future<void> _addItem(String name) async {
//     await _dbRef.push().set({'name': "Vaidant"});
//   }
//   void _filterItems() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredItems = _items
//           .where((item) => item['name'].toString().toLowerCase().contains(query))
//           .toList();
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stock Details'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _items.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//               itemCount: _filteredItems.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_filteredItems[index]['name']),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _addItem('Item ${_items.length + 1}');  // Add a new item
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';

class StockAnalysis extends StatefulWidget {
  static String id = "Stock_Screen";

  const StockAnalysis({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StockAnalysis();
  }
}

class _StockAnalysis extends State<StockAnalysis> {
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _filteredItems = [];
  List<int> _itemsCount = [];
  List<int> _filteredItemsCount = [];
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadItems(); // Load hardcoded items
    _searchController.addListener(() {
      _filterItems();
    });
  }

  // Load predefined list of items
  void _loadItems() {
    final List<Map<String, dynamic>> loadedItems = [
      {'id': '1', 'name': 'Medicine 1', 'stock': 30},
      {'id': '2', 'name': 'Medicine 2', 'stock': 100},
      {'id': '3', 'name': 'Medicine 3', 'stock': 50},
      {'id': '4', 'name': 'Medicine 4', 'stock': 80},
      {'id': '5', 'name': 'Medicine 5', 'stock': 320},
    ];
    setState(() {
      _items = loadedItems;
      _filteredItems = loadedItems;
      _itemsCount = loadedItems.map<int>((item) => item['stock']).toList();
      _filteredItemsCount =
          loadedItems.map<int>((item) => item['stock']).toList();
      ; // Initially show all items
    });
  }

  // Filter items based on the search query
  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _items
          .where(
              (item) => item['name'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Row(
            children: [
              Expanded(
                  child: Text(
                    "  Medicine",
                    style: TextStyle(fontSize: 18),
                  )),
              Text(
                "Stock  ",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          Expanded(
            child: _items.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: _filteredItems[index]['stock'] < 80?Text(_filteredItems[index]['name'],style: const TextStyle(color: Colors.red),):Text(_filteredItems[index]['name']),
                      ),
                      _filteredItems[index]['stock'] < 80
                          ? Text(_filteredItems[index]['stock'].toString(), style: const TextStyle(color: Colors.red),)
                          : Text(_filteredItems[index]['stock'].toString()),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context,
              builder: (context)
              {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Name'),
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Stock'),
                            controller: _stockController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a stock quantity';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _addItem(_nameController.text,
                                    int.parse(_stockController.text));
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Add Item'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
  void _addItem(String name,int stock) {
    final newItem = {
      'id': (_items.length + 1).toString(),
      'name': name,
      'stock': stock,
    };
    setState(() {
      _items.add(newItem);
      _filteredItems.add(newItem);
      _itemsCount.add(0);
      _filteredItemsCount.add(0);
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}