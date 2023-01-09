import 'dart:convert';

class Product {
  final String productId, productName, productDescription, productCategory;
  bool isChecked;

  Product(
      {required this.productId,
      required this.productName,
      required this.productDescription,
      required this.productCategory,
      required this.isChecked});

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productDescription': productDescription,
      'productCategory': productCategory,
      'isChecked': isChecked,
    };
  }

  factory Product.fromJson(Map<String, dynamic> jsonData) {
    return Product(
      productId: jsonData['productId'],
      productName: jsonData['productName'],
      productDescription: jsonData['productDescription'],
      productCategory: jsonData['productCategory'],
      isChecked: jsonData['isChecked'],
    );
  }

  static Map<String, dynamic> toMap(Product product) => {
        'productId': product.productId,
        'productName': product.productName,
        'productDescription': product.productDescription,
        'productCategory': product.productCategory,
        'isChecked': product.isChecked,
      };

  static String encode(List<Product> products) =>
      json.encode(List<dynamic>.from(products.map((x) => x.toJson())));
  // json.encode(
  //       products
  //           .map<Map<String, dynamic>>((product) => Product.toMap(product))
  //           .toList(),
  //     );

  static List<Product> decode(String products) =>
      List<Product>.from(json.decode(products).map((x) => Product.fromJson(x)));
  // (json.decode(products) as List<Product>)
  //     .map<Product>((item) => Product.fromJson(item))
  //     .toList();
}

// class ShoppingItem {
//   int _id = UniqueKey() as int;

//   bool _isChecked = false;
//   String _title = "";
//   String _description = "";
//   String _category = "";

//   ShoppingItem(this._id, this._title, this._description, this._category, this._isChecked);

//   // ShoppingItem(bool v_isChecked, String v_Title, String v_description, String v_group) {
//   //   _id = UniqueKey() as int;
//   //   _isChecked = v_isChecked;
//   //   _title = v_Title;
//   //   _description = v_description;
//   //   _category = v_group;
//   // }

// }

// Widget shoppingItemTile(ShoppingItem item) {
//   List<ShoppingItem> lista = new List<ShoppingItem>;

//   return Dismissible(
//     key: UniqueKey(),
//     onDismissed: (direction) {
//       setState() {
//         ShoppingItem value = ShoppingItem(UniqueKey(), 'Titlu', 'Descriere', 'Categorie', false);

//         lista.add(value);
//       },
//       child: 
//     },
//   )

// }
