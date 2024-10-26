class Product {
  final String id;
  final String name;
  final String categoryId;
  final String color;
  final double purchasePrice;
  final double salePrice;
  final double averageCost;
  final String size;
  final int stockQuantity;
  final String supplierId;
  final int initialQuantity;
  final String note;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.color,
    required this.purchasePrice,
    required this.salePrice,
    required this.averageCost,
    required this.size,
    required this.stockQuantity,
    required this.supplierId,
    required this.initialQuantity,
    required this.note,
  });

  // Convert Firestore data to Product model
  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: (data['name'] != "NA") ? data['name'] ?? 'ل' : 'ل',
      categoryId:
          (data['category_id'] != "NA") ? data['category_id'] ?? 'ل' : 'ل',
      color: (data['color'] != "NA") ? data['color'] ?? 'ل' : 'ل',

      // Check if value is "NA", if so, return -1.0, otherwise convert to double
      purchasePrice:
          (data['purchase_price'] != "NA" && data['purchase_price'] is num)
              ? (data['purchase_price'] as num).toDouble()
              : -1.0,
      salePrice: (data['sale_price'] != "NA" && data['sale_price'] is num)
          ? (data['sale_price'] as num).toDouble()
          : -1.0,
      averageCost: (data['average_cost'] != "NA" && data['average_cost'] is num)
          ? (data['average_cost'] as num).toDouble()
          : -1.0,

      size: (data['size'] != "NA") ? data['size'] ?? 'ل' : 'ل',
      stockQuantity:
          (data['stock_quantity'] != "NA" && data['stock_quantity'] is int)
              ? data['stock_quantity'] as int
              : -1,
      supplierId:
          (data['supplier_id'] != "NA") ? data['supplier_id'] ?? 'ل' : 'ل',
      initialQuantity:
          (data['initial_quantity'] != "NA" && data['initial_quantity'] is int)
              ? data['initial_quantity'] as int
              : -1,
      note: (data['note'] != "NA") ? data['note'] ?? 'ل' : 'ل',
    );
  }
}
