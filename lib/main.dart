// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shopping_item.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  ShoppingListState createState() => ShoppingListState();
}

class ShoppingListState extends State<ShoppingList> {
  List<Product> _items = [
    // Product(
    //     productId: "1",
    //     productName: "name 1",
    //     productDescription: "artist 1",
    //     productCategory: "sequence 1",
    //     isChecked: false),
    // Product(
    //     productId: "2",
    //     productName: "name 2",
    //     productDescription: "artist 2",
    //     productCategory: "sequence 2",
    //     isChecked: false),
    // Product(
    //     productId: "3",
    //     productName: "name 3",
    //     productDescription: "artist 3",
    //     productCategory: "sequence 3",
    //     isChecked: false),
    // Product(
    //     productId: "4",
    //     productName: "name 4",
    //     productDescription: "artist 4",
    //     productCategory: "sequence 4",
    //     isChecked: false),
  ];

  // ignore: prefer_final_fields
  List<String> _categories = [
    "Food",
    "Transport",
    "Personal",
    "Shopping",
    "Medical",
    "Rent",
    "Movie",
    "Salary"
  ];

  // String? _currentSelectedValue = "Food";

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('shop_list_key');

    if (jsonData == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No items")));
    } else {
      _items.addAll(Product.decode(jsonData));
      setState(() {});
    }
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonData = jsonEncode(_items);
    prefs.setString('shop_list_key', jsonData);
  }

  void clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  ShoppingListState() {
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(child: Text("Category: ")),
            Expanded(
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return _categories.where((String option) {
                    return option
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  debugPrint('You just selected $selection');
                },
              ),
            ),
          ],
        ),
      ),
      body: ReorderableListView(
        onReorder: onReorder,
        // scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        children: _getListItems(),
      ),
      persistentFooterButtons: [
        IconButton(
            tooltip: "Load",
            onPressed: () {
              setState(() {
                loadData();
              });
            },
            icon: const Icon(Icons.file_upload)),
        IconButton(
            tooltip: "Save",
            onPressed: () {
              setState(() {
                saveData();
              });
            },
            icon: const Icon(Icons.publish))
      ],
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;

    setState(() {
      Product product = _items[oldIndex];

      _items.removeAt(oldIndex);
      _items.insert(newIndex, product);

      saveData();
    });
  }

  List<Widget> _getListItems() => _items
      .asMap()
      .map((i, item) => MapEntry(i, _buildTenableListTile(item, i)))
      .values
      .toList();

  Widget _buildTenableListTile(Product item, int index) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          _items.removeAt(index);
          saveData();
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Removed $index")));
      },
      background: Container(color: Colors.red),
      child: ListTile(
        key: UniqueKey(),
        leading: Checkbox(
            value: item.isChecked,
            onChanged: (value) {
              setState(() {
                item.isChecked = !item.isChecked;
              });
            }),
        title: Text(
          '${item.productCategory}. ${item.productName}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${item.productDescription} ${item.productId}',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ShoppingList(),
    );
  }
}
